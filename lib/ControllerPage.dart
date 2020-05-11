import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iot_tar_project/HumidityController.dart';
import 'package:iot_tar_project/mqtt_wrapper/mqttWrapper.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt_wrapper/mqttWrapper.dart';
import 'package:flushbar/flushbar.dart';
import 'package:iot_tar_project/LightController.dart';
import 'package:iot_tar_project/TemperatureController.dart';


/// Class ControllerPage
///
/// Builds the page that contains the sub-pages
class ControllerPage extends StatefulWidget {
  ControllerPageState createState() => ControllerPageState();
}

class ControllerPageState extends State<ControllerPage> {

  String _hostIP;
  MqttLink _connection;
  List<Widget> _active = [];
  TemperatureController temperatureSubpage;
  LightController lightSubpage;
  HumidityController humiditySubpage;
  bool _connected = false;
  
  ControllerPageState();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => connectToServer(context));
  }

  void connectToServer(BuildContext context) {
    if (!this._connected) {
        this._hostIP = ModalRoute.of(context).settings.arguments;
        this._connection = new MqttLink(this._hostIP, true, 20, MqttQos.exactlyOnce);
        connectAndSubscribe(context).then(
          (bool status) {
            if (status)
              listenToBroker();
          }
      );
    }
    //Allows the app to send mqtt messages by forwarding the connection object to the child page
    lightSubpage.setBrokerLink(_connection);
  }

  @override
  Widget build(BuildContext context) {

    if (_active.isEmpty) {
      temperatureSubpage = TemperatureController();
      lightSubpage = LightController();
      humiditySubpage = HumidityController();
      _active.add(temperatureSubpage);
      _active.add(humiditySubpage);
      _active.add(lightSubpage); 
    }
    
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.ac_unit)),
                Tab(icon: Icon(Icons.local_drink)),
                Tab(icon: Icon(Icons.highlight)),
              ],
            ),
            title: Text('Controlador IoT'),
          ),
          body: TabBarView(
            children: this._active,
          ),
        ),
      ),
    );
  }

   Future<bool> connectAndSubscribe(BuildContext context) async {

    return this._connection.connect().then( (hasConnected) {
      if (hasConnected) {
        Flushbar(message:"A conexão ao broker foi bem sucedida!",duration:Duration(seconds: 3))..show(context);
        return true;
      }
      else {
        Flushbar(message:"Não foi possível conectar ao broker!",duration:Duration(seconds: 3))..show(context);
        return false;
      }     
    }).then( (bool status) {
        this._connection.subscribeToTopic('tar/temperature');
        return status;
    }).then( (bool status) {
        this._connection.subscribeToTopic('tar/humidity');
        return status;
    }).then( (bool status) {
        this._connection.subscribeToTopic('tar/led');
        return status;
    }).then( (bool status) {
      this._connected = status;
      return status;
    });
  }

   Future<void> listenToBroker() async {
        this._connection.getClient().updates.listen(
          (List<MqttReceivedMessage<MqttMessage>> l) {
            MqttPublishMessage msgPayload = l[0].payload;
            String msg = MqttPublishPayload.bytesToStringAsString(msgPayload.payload.message);
            var jsonMsg = json.decode(msg); 
            if (jsonMsg.containsKey('temperature')) {
              updateTemperature(jsonMsg['temperature']);
            }
            if (jsonMsg.containsKey('humidity')) {
              updateHumidity(jsonMsg['humidity']);
            }
            if (jsonMsg.containsKey('status')) {
              updateLight(jsonMsg['status']);
            }
        }
    );
  }

  void updateTemperature(String newValue) {
      this.temperatureSubpage.setCurrentValue(newValue);
  }

  void updateHumidity(String newValue) {
      this.humiditySubpage.setCurrentValue(newValue);
  }

  void updateLight(String newValue) {
    this.lightSubpage.setCurrentValue(newValue);
  }

}