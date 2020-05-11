import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iot_tar_project/mqtt_wrapper/mqttWrapper.dart';

///Class LightController
///
/// Builds the light controller page.
class LightController extends StatefulWidget {

  final LightControllerState state = new LightControllerState();

  void setCurrentValue(String val) {
    state.changeLight(val);
  }

  void setBrokerLink(MqttLink link) {
    state.setBrokerLink(link);
  }

   LightControllerState createState() => this.state;

}

class LightControllerState extends State<LightController> with AutomaticKeepAliveClientMixin<LightController> {
  
  Widget _currentLightState;
  Widget _lightStateButton;
  List<Widget> _widgets = [];
  final String _onLabel = "Ligar luz";
  final String _offLabel = "Desligar luz";
  String _currentState;
  MqttLink _link;

  LightControllerState();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_widgets.isEmpty) {
      _currentLightState = _currentLightStateConstructor(); 
      _lightStateButton = _lightStateButtonConstructor();
      _widgets.add(_currentLightState);
      _widgets.add(_lightStateButton);
    }

    return Padding(child:Align(child:Stack(children: _widgets),alignment: Alignment.center,),padding: const EdgeInsets.all(20.0),);
  }

  Widget _currentLightStateConstructor() {
    if (_currentState == "on")
      return Align(child:Container(child: Text("Luz Ligada", textAlign: TextAlign.center,style: TextStyle(fontSize: 25.0),),),alignment: Alignment.center,);
    else if (_currentState == "off")
      return Align(child:Container(child: Text("Luz Desligada", textAlign: TextAlign.center,style: TextStyle(fontSize: 25.0),),),alignment: Alignment.center,);
    else {
      return Align(child:Container(child: Text("Aguardando um valor do sensor de luz...", textAlign: TextAlign.center,style: TextStyle(fontSize: 25.0),),),alignment: Alignment.center,);
    }
  }

  Widget _lightStateButtonConstructor() {
    if (_currentState == "on") {
      return Align(alignment:Alignment.bottomCenter,child:Padding(child:RaisedButton(child: Text(_offLabel),onPressed: () {sendChangeLight();},),padding: const EdgeInsets.all(20),));
    }
    else if (_currentState == "off") {
      return Align(alignment:Alignment.bottomCenter,child:Padding(child:RaisedButton(child: Text(_onLabel),onPressed: () {sendChangeLight();},),padding: const EdgeInsets.all(20),));
    }
    else {
      return Align(alignment:Alignment.bottomCenter,child:Padding(child:RaisedButton(child: Text(_onLabel),onPressed: () {sendChangeLight();},),padding: const EdgeInsets.all(20),)); 
    }

  }

  void changeLight(String val) {
    setState(() {
      this._currentState = val;
      this._widgets.clear();
    });
  }

  void sendChangeLight() {
    if (this._currentState == "off" || this._currentState == null) {
      var jsonmessage = json.encode({"status": "on"});
      this._link.publishToTopic(jsonmessage,'tar/led');
    }
    else if (this._currentState == "on") {
      var jsonmessage = json.encode({"status": "off"});
      this._link.publishToTopic(jsonmessage,'tar/led');
    }
    else {}
  }

  void setBrokerLink(MqttLink link) {
    this._link = link;
  }

  @override
  bool get wantKeepAlive => true;
}
