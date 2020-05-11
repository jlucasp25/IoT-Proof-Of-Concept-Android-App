# IoT Proof-Of-Concept Android App 

IoT Proof-Of-Concept Android App deployed in Flutter in order to communicate with a MQTT broker.
The application requires an active broker using the default MQTT protocol.
The app subscribes to the following topics:
- led
- humidity
- temperature

## Requirements
Dart >= 2.0
Flutter
Device with Android >= 8.0

## Build and run 
1. Install the Dart and Flutter SDK's.
2. Download the repository to your PC.
3. Run "pub get" to retrieve the project dependencies.
4. Run "flutter build apk" to generate an APK or "flutter run" to run the app on the AVD or a connected device.

## Notes
You will require a way to generate the JSON's that are sent to the device.
The app uses the MQTT protocol default port.
Because of a bug in the language libraries, the JSON must be delimited by ' instead of ".