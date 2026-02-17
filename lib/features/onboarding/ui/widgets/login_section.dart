import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/onboarding/domain/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

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

