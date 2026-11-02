import 'dart:io';

import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/data/services/device/device_service.dart';
import 'package:Self.Tube/common/data/services/permissions/permission_service.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/onboarding/domain/controllers/auth_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginSectionWidget extends StatefulWidget{
  final VoidCallback? onLoginSuccess;

  const LoginSectionWidget({
    super.key, 
    this.onLoginSuccess
  });

  @override
  _LoginSectionWidgetState createState() => _LoginSectionWidgetState();
}

class _LoginSectionWidgetState extends State<LoginSectionWidget> with SingleTickerProviderStateMixin {
  final TextEditingController _instanceUrlController = TextEditingController();
  final TextEditingController _apiTokenController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late TabController _tabController;
  bool _isLoading = false; 
  bool _isLoggedIn = false;
  bool _allowSelfSigned = false;
  bool _localNetworkPermission = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _allowSelfSigned = SettingsService.allowSelfSigned ?? false;
    checkLocalNetworkPermission();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> checkLocalNetworkPermission() async {
    print("checking");
    final status = await PermissionService.checkLocalNetworkPermission();
    if (status.isGranted) {
      setState(() {
        _localNetworkPermission = true;
      });
      SettingsService.setLocalNetworkPermission(true);
    } else {
      setState(() {
        _localNetworkPermission = false;
      });
    }
  }

  Future<void> requestNetPermission() async {
    bool showRationaleBefore = await Permission.accessLocalNetwork.shouldShowRequestRationale;    
    await PermissionService.requestLocalNetworkPermission();
    if (!showRationaleBefore) {
      await openAppSettings();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.onboarding,
        (route) => false
      );
    }
    checkLocalNetworkPermission();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(
              text: localizations.onboardingPassword,
            ),
            Tab(
              text: localizations.onboardingToken,
            )
          ]
        ),
        SizedBox(
          height: 200,
          child: TabBarView(
            controller: _tabController,
            children: [
              ListSectionContainer(
                children: [
                  TextField(
                    controller: _instanceUrlController,
                    decoration: InputDecoration(
                      labelText: localizations.onboardingInstanceUrl,
                      hint: Text(localizations.onboardingUrlExample),
                      border: InputBorder.none,
                    ),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: localizations.onboardingUsername,
                      border: InputBorder.none,
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: localizations.onboardingPassword,
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ]
              ),
              ListSectionContainer(
                children: [
                  TextField(
                    controller: _instanceUrlController,
                    decoration: InputDecoration(
                      labelText: localizations.onboardingInstanceUrl,
                      hint: Text(localizations.onboardingUrlExample),
                      border: InputBorder.none,
                    ),
                  ),
                  TextField(
                    controller: _apiTokenController,
                    decoration: InputDecoration(
                      labelText: localizations.onboardingToken,
                      hint: Text(localizations.onboardingTokenExample),
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ],
              )
            ]
          )
        ),
        SwitchListTile(
          thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const Icon(Icons.check);
              }
              return const Icon(Icons.close);
            },
          ),
          title: Text(localizations.onboardingAllowSelfSigned),
          subtitle: Text(localizations.onboardingAllowSelfSignedDesc),
          value: _allowSelfSigned, 
          onChanged: (bool value) {
            setState( () {
              _allowSelfSigned = value;
              SettingsService.setAllowSelfSigned(value);
            });
          }
        ),
        if (Platform.isAndroid && DeviceService.androidInfo != null && DeviceService.androidInfo!.version.sdkInt >= 37)
          IgnorePointer(
            ignoring: _localNetworkPermission,
            child: Opacity(
              opacity: _localNetworkPermission ? 0.4 : 1.0,
              child: SwitchListTile(
                thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Icon(Icons.check);
                    }
                    return const Icon(Icons.close);
                  },
                ),
                title: Text("Local Network Access"),
                subtitle: Text("Since Android 17, you need to grant Apps Permission to access Servers on your Local Network"),
                value: _localNetworkPermission, 
                onChanged: (bool value) {
                  setState( () {
                    _localNetworkPermission = value;
                    requestNetPermission();
                  });
                }
              ),
            ),
          ),
        ElevatedButton(
          onPressed: _isLoading || _isLoggedIn
              ? null
              : () => _handleLogin(context),
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : Text(_isLoggedIn ? "Logged in" : localizations.onboardingLogin),
        ),
      ],
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    setState(() => _isLoading = true);
  
    final controller = AuthController();
  
    final success = await controller.login(
      _tabController.index == 1,
      _instanceUrlController.text,
      _usernameController.text,
      _passwordController.text,
      _apiTokenController.text,
    );
  
    setState(() {
      _isLoading = false;
      _isLoggedIn = success;
    });
  
    if (success) {
      widget.onLoginSuccess?.call();
    }
  }

}

