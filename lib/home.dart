import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'setting.dart';
import 'dart:io';
import 'package:siprocalsdk_helios/siprocalsdk_helios.dart';

final _siprocalsdkHelios = SiprocalsdkHelios();

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String jsonData = '{}';
  TextEditingController clientAttributesController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeJsonData();
    _requestPermissions();
  }


  Future<void> _requestPermissions() async {
    if (await Permission.notification.status.isDenied) {
      if(Platform.isAndroid){
        await Permission.notification.request();
      } else {
        _siprocalsdkHelios.requestPushPermission();
        _siprocalsdkHelios.requestPermissionForGL();
      }
    }
  }

  Future<void> _initializeJsonData() async {
    String? sdkInfo = await _siprocalsdkHelios.getSdkInformation();
    setState(() {
      jsonData = sdkInfo ?? '{"error": "Failed to get SDK information"}';
    });
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );
  }

  String _formatJson(String jsonStr) {
    Map<String, dynamic> parsedJson = jsonDecode(jsonStr);
    List<String> formattedLines = [];
    parsedJson.forEach((key, value) {
      formattedLines.add('  "$key": $value,');
    });
    return '{\n${formattedLines.join('\n')}\n}';
  }

  void _updateJsonData() {
    setState(() {
      _initializeJsonData();
    });
  }

  void setClientAttribute(String value) {
    Map<String, dynamic> parameters = {
      'Flutter': value,
    };
    try {
      _siprocalsdkHelios.setClientAttributes(parameters);
    } on PlatformException {
      // Manejar error si es necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedJson = _formatJson(jsonData);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Client Id:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: _updateJsonData,
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: jsonData));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('JSON copied to clipboard!')),
                    );
                  },
                  child: Text(
                    formattedJson, // Mostrar el JSON formateado
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }
}