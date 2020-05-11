import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';

///  MQTT Wrapper for IoT application
///  A wrapper to enable easy access to MQTT operations on the main app. 
///  Uses the MQTT client implementation by Steve Hamblett.
///  Author: João Lucas Pires, up201606617

class MqttLink {
  String _serverURL;
  String _clientIdentifier = "TAR-Client";
  MqttClient _client;
  MqttQos _qosValue;
  List<String> _subscribedTopics = [];

  MqttLink(String url, bool enableLogging, int keepAlivePeriod, MqttQos chosenQOS) {
    _serverURL = url;
    _client = MqttClient(url,_clientIdentifier);
    _client.logging(on: enableLogging);
    _client.onDisconnected = this.onDisconnect;
    _client.onConnected = this.onConnected;
    _client.onSubscribed = this.onSubscribed;
    _qosValue = chosenQOS;
    _client.connectionMessage = this.createConnectMessage();
  }

  MqttConnectMessage createConnectMessage() {
    print('Creating connect message...');
    return MqttConnectMessage()
    .withClientIdentifier(_client.clientIdentifier)
    .keepAliveFor(_client.keepAlivePeriod)
    .withWillTopic('entry')
    .withWillMessage('App connecting to server')
    .startClean() //Clears the message queue to make this one the first
    .withWillQos(_qosValue);
  }

  Future<bool> connect() async {
    try {
      await _client.connect();
    } 
    on Exception catch (e)
    {
      print('!Exception! --> $e');
      _client.disconnect();
    }

    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      print('Connection state is sucessful (CONNECTED)');
      return true;
    }
    else {
      print('Connection state is failed (FAILED) | Current Status is ${_client.connectionStatus}');
      print('Trying to disconnect...');
      _client.disconnect();
      return false;
    }
  }

  void subscribeToTopic(String topic) {
    print("Subscribing to topic $topic");
    _subscribedTopics.add(topic);
    _client.subscribe(topic, _qosValue);
  }

  void unsubscribeToTopic(String topic) {
    print("Unsubscribing to topic $topic");
    if (_subscribedTopics.contains(topic))
      _subscribedTopics.remove(topic);
    _client.unsubscribe(topic);
  }

  void publishToTopic(String message, String topic) async {
    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, _qosValue, builder.payload);
  }

  List<String> getSubscribedTopics() {
    return _subscribedTopics;
  }

  String getClientIdentifier() {
    return _clientIdentifier;
  }

  MqttClient getClient() {
    return _client;
  }

   String getServerURL() {
    return _serverURL;
  }

  MqttQos getQoSValue() {
    return _qosValue;
  }

  void sleep(int time) async {
    await MqttUtilities.asyncSleep(time);
  }
  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void onDisconnect() {
    print('Disconnected from the server');
  }

  void onConnected() {
    print('Connected to the server');
  }
  
}

