import 'package:flutter/material.dart';

///Class HumidityController
///
/// Builds the humidity controller page.
class HumidityController extends StatefulWidget {
  
  final HumidityControllerState state = new HumidityControllerState();

  void setCurrentValue(String val) {
    state.resetState(val);
  }
  
  HumidityControllerState createState() => this.state;

}

class HumidityControllerState extends State<HumidityController> with AutomaticKeepAliveClientMixin<HumidityController> {
  
  String _currentValue;
  
  HumidityControllerState();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (this._currentValue == "" || this._currentValue == null)
      this._currentValue = "Aguardando um valor do sensor de humidade...";
    
    return Padding(child:Align(child:Container(child: Text(this._currentValue, textAlign: TextAlign.center,style: TextStyle(fontSize: 25.0),),),alignment: Alignment.center,),padding: const EdgeInsets.all(10.0),);
  }

  resetState(String newValue) {
    setState( () {
      this._currentValue = newValue;
    });
  }

  @override
  bool get wantKeepAlive => true;

}