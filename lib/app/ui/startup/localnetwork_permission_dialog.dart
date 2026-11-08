import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/data/services/permissions/permission_service.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes_extended/flutter_m3shapes_extended.dart';
import 'package:permission_handler/permission_handler.dart';


class LocalNetworkPermissionScreen extends StatefulWidget {
  
  @override
  _LocalNetworkPermisionScreenState createState() => _LocalNetworkPermisionScreenState();
}

class _LocalNetworkPermisionScreenState extends State<LocalNetworkPermissionScreen> with WidgetsBindingObserver {
  bool _localNetworkPermission = false;


  @override
  void initState() {
    super.initState();
    checkLocalNetworkPermission();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkLocalNetworkPermission();
    }
  }

  Future<void> checkLocalNetworkPermission() async {
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
    final result = await PermissionService.requestLocalNetworkPermission();
    if (result == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }    
    checkLocalNetworkPermission();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Continue"),
        icon: Icon(Icons.check),
        onPressed: () {
          SettingsService.setLocalNetworkPermission(true);
          Navigator.pushNamedAndRemoveUntil(
            context, 
            AppRouter.startup,
            (route) => false
          );
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          M3EContainer.arrow(
            width: 100,
            height: 100,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Icon(
                Icons.router,
                size: 40,
              )
            )
          ),

          const SizedBox(height: 16),

          Text(
            "Local Network Permission",
            style: TextStyle(
              fontSize: 20,
              //fontWeight: FontWeight(25)
            )
          ),

          const SizedBox(height: 16),

          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Android 17 requires permission for apps to access your local network. "
              "If your server is on your local network, allow this app to access it.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          
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
        ],
      )
    );
  }
}
