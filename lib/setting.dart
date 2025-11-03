import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siprocalsdk_helios/siprocalsdk_helios.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

final _siprocalsdkHelios = SiprocalsdkHelios();

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool switchState = false;
  bool switchOptin = true;
  bool switchSensitiveData = false;
  bool switchSensitiveApp = false;
  bool switchSensitivePhone = false;
  bool switchSensitiveTel = false;

  @override
  void initState() {
    _sendEvent();
    getOptInStatus();
  }

  Future<void> getOptInStatus() async {
    bool optInStatus;
    bool sensitiveData;
    try {
      optInStatus = await _siprocalsdkHelios.getOptIntStatus() ?? false;
    } on PlatformException {
      optInStatus = false;
    }

    if (!mounted) return;

    setState(() {
      switchOptin = optInStatus;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [

          SwitchListTile(
            title: Text('Opt-In'),
            value: switchOptin,
            onChanged: (value) {
              setState(() {
                switchOptin = value;
              });
              _handleUpdateOptinStatus(value);
            },
          )
        ],
      ),
    );
  }

  void _handleStatusSDK(bool value) {
    _siprocalsdkHelios.setSDKStatus(value);
  }

  void _handleUpdateOptinStatus(bool value) {
    _siprocalsdkHelios.updateOptIntStatus(value);
  }

  void _handleSensitiveData(bool value) {
    _siprocalsdkHelios.setSensitiveData(value);
  }

  void _handleSensitiveApp(bool value) {
    _siprocalsdkHelios.setSensitivePermissionAppService(value);
  }

  void _handleSensitivePhone(bool value) {
    _siprocalsdkHelios.setSensitivePermissionPhoneServices(value);
  }

  void _handleSensitiveTelephony(bool value) {
    _siprocalsdkHelios.setSensitivePermissionTelephonyServices(value);
  }

  void _requestPermission() async{
    if (await Permission.notification.status.isDenied) {
      if(Platform.isAndroid){
        await Permission.notification.request();
      } else {
        _siprocalsdkHelios.requestPushPermission();
      }
    }
  }

  void _sendEvent(){
    if(Platform.isAndroid){
      _siprocalsdkHelios.trackInAppEvents("EVENT_TEST");
    } else {
      Map<String, dynamic> eventParameters = {
        "trackInAppEvents": {
          "EVENT_NAME": "TEST_EVENT_IOS",
        },
      };
      _siprocalsdkHelios.sendEvent(eventParameters);
    }
  }

// Repetir para los otros métodos _handleSwitchX para cada switch
}