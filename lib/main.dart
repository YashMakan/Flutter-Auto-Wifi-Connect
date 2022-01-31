import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Wifi',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int level = 0;
  String ssid = 'Redmi 9 Power', password = 'password';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wifi Connection'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.wifi),
                hintText: 'Your wifi ssid',
                labelText: 'ssid',
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                ssid = value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.lock_outline),
                hintText: 'Your wifi password',
                labelText: 'password',
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                password = value;
              },
            ),
            RaisedButton(
              child: Text('connection'),
              onPressed: connection,
            ),
          ],
        )
      ),
    );
  }

  void loadData() async {

  }

  Future<Null> connection() async {
    WifiConnector.connectToWifi(ssid: ssid, password: password);
  }
}


class WifiConnector {
  static const MethodChannel _channel = const MethodChannel('flutteriot/wifi');

  static Future<bool> connectToWifi({String ssid, String password, bool isWEP = false}) async {
    final result = await _channel.invokeMethod('connectWifi', {
      "ssid": ssid,
      "password": password
    });
    print(result);
    return result == true;
  }
}
