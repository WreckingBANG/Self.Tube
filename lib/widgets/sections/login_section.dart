import 'package:Self.Tube/services/api/user_api.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/services/settings_service.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';

class LoginSectionWidget extends StatefulWidget{
  final VoidCallback? onLoginSuccess;

  const LoginSectionWidget({
    Key? key, 
    this.onLoginSuccess
  }) : super(key: key);

  @override
  _LoginSectionWidgetState createState() => _LoginSectionWidgetState();
}

class _LoginSectionWidgetState extends State<LoginSectionWidget> with SingleTickerProviderStateMixin {
  final TextEditingController _instanceUrlController = TextEditingController();
  final TextEditingController _apiTokenController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: _tabController,
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
        ElevatedButton(
          onPressed: () async {
            String url = _instanceUrlController.text;
            if (_tabController.index == 0) {
              final response = await UserApi().fetchSession(
                url,
                _usernameController.text,
                _passwordController.text
              );
              if (response?.sessionToken != null && response?.csrfToken != null){
                final ping = await UserApi().testConnectionSession(
                  url, 
                  response!.sessionToken, 
                  response.csrfToken
                );
                if (ping?.response == 'pong') {
                  await SettingsService.setInstanceUrl(url);
                  await SettingsService.setSessionToken(response.sessionToken);
                  await SettingsService.setCSRFToken(response.csrfToken);
                  await SettingsService.setApiTokenAuth(false);
                  await SettingsService.setDoneSetup(true);
                  widget.onLoginSuccess?.call();
                }
              }
            } else if (_tabController.index == 1) {
              final ping = await UserApi().testConnectionToken(
                _apiTokenController.text,
                url,
              );
              if (ping != null && ping.response == 'pong') {
                await SettingsService.setInstanceUrl(url);
                await SettingsService.setApiToken(_apiTokenController.text);
                await SettingsService.setApiTokenAuth(true);
                await SettingsService.setDoneSetup(true);
                widget.onLoginSuccess?.call();
              }
            }
          }, 
          child: Text(localizations.onboardingLogin)
        )
      ],
    );
  }
}