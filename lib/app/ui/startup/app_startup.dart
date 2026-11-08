import 'dart:io';
import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/app/ui/shell/homecontainer_screen.dart';
import 'package:Self.Tube/common/data/services/device/device_service.dart';
import 'package:Self.Tube/common/data/services/permissions/permission_service.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/ui/widgets/sections/connection_error_section.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class AppStartup extends ConsumerStatefulWidget {

  @override
  _AppStartupState createState() => _AppStartupState();
}  

class _AppStartupState extends ConsumerState<AppStartup> {

  @override
  void initState() {
    super.initState();

    if(Platform.isAndroid && 
        DeviceService.androidInfo != null && 
        DeviceService.androidInfo!.version.sdkInt >= 37 && 
        SettingsService.localNetworkPermission != true 
      ) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.localNetPermission,
          (route) => false
        );
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {

    final user = ref.watch(userSessionProvider);

    return user.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("$error")),
      data: (isSuccess) {

        if (isSuccess) {  
          return HomeContainer();
        } else {
          return Scaffold(
            body: Center(
              child: ConnectionErrorSection(
                provider: userSessionProvider,
                ref: ref
              )
            ),
          );
        }
      } 
    );
  }
}
