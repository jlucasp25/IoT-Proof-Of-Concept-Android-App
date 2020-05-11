import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ControllerPage.dart';

void main() => runApp(IoTApp());

/// Class IoTApp
///
/// Builds the main app.

class IoTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tópicos Avançados de Redes: IoT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/controller': (context) => ControllerPage()
      }
    );
  }
}

/// Class MainPage
///
/// Builds the entry page.
class MainPage extends StatelessWidget {
  
  MainPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TAR: Proof-of-concept IoT')),
      body: Align(alignment:Alignment.center,child:Center(child: Column(children: <Widget>[
        Container(child:Text("Introduza o endereço IP do broker:"),margin: const EdgeInsets.all(5)),
        NetworkForm()
      ],),))
    );
 }
}

/// Class NetworkForm
///
/// Builds and controls the form to enter the IP address.
class NetworkForm extends StatefulWidget {

   @override
  NetworkFormState createState() {
    return NetworkFormState();
  }

}

class NetworkFormState extends State<NetworkForm> {
  
  final _formKey = GlobalKey<FormState>();
  final _ipOctet1Controller = TextEditingController();
  final _ipOctet2Controller = TextEditingController();
  final _ipOctet3Controller = TextEditingController();
  final _ipOctet4Controller = TextEditingController();
  final _portController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: 
          <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ipOctetTextFieldConstructor(_ipOctet1Controller),
              octetSeparatorConstructor(),
              ipOctetTextFieldConstructor(_ipOctet2Controller),
              octetSeparatorConstructor(),
              ipOctetTextFieldConstructor(_ipOctet3Controller),
              octetSeparatorConstructor(),
              ipOctetTextFieldConstructor(_ipOctet4Controller),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(children: <Widget>[
                  Padding(padding: EdgeInsets.all(40.00)),
                  connectButtonConstructor()
                ],)          
            ],)],
      )
    );
  }

  Widget ipOctetTextFieldConstructor(TextEditingController controller) {
    return Container(child:TextFormField(validator: ipValidator,maxLength:3,inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],keyboardType: TextInputType.number,controller: controller,),width: 50.0,margin: const EdgeInsets.all(5),);
  }

  Widget octetSeparatorConstructor() {
    return Text(".");
  }

  Widget connectButtonConstructor() {

    Function buttonCallback = () {
                if (_formKey.currentState.validate()) {
                  processConnect(this);
                }
              };

    return RaisedButton(
          onPressed: buttonCallback,
          child: const Text(
            'Conectar',
            style: TextStyle(fontSize: 20)
          ),
        );
  }

  void processConnect(dynamic state) {
    String ip = _ipOctet1Controller.text + '.' + _ipOctet2Controller.text + '.' + _ipOctet3Controller.text + '.' + _ipOctet4Controller.text;
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ControllerPage(),
      settings: RouteSettings(
        arguments: ip
      )
    ));
  }

  @override
  void dispose() {
    _ipOctet1Controller.dispose();
    _ipOctet2Controller.dispose();
    _ipOctet3Controller.dispose();
    _ipOctet4Controller.dispose();
    _portController.dispose();
    super.dispose();
  }

  String ipValidator(String value) {
    if (value.isEmpty) {
      return '!';
    }
    return null;
  }
  
}
