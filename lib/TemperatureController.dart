import 'package:flutter/material.dart';

///Class TemperatureController
///
/// Builds the temperature controller page.
class TemperatureController extends StatefulWidget {
  
  final TemperatureControllerState state = new TemperatureControllerState();

  void setCurrentValue(String val) {
    state.resetState(val);
  }

  TemperatureControllerState createState() => this.state;
  
}

class TemperatureControllerState extends State<TemperatureController> with AutomaticKeepAliveClientMixin<TemperatureController> {
  
  String _currentValue;
  
  TemperatureControllerState();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (this._currentValue == "" || this._currentValue == null)
      this._currentValue = "Aguardando um valor do sensor de temperatura...";
    
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