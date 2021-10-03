# IoT Proof-Of-Concept Android App 

***Advanced Networks Topics Class***

A proof-of-concept for an Android App using IoT (Internet of Things) technology.
The application was developed using the Flutter framework.

It communicates with a Raspberry Pi/Arduino using MQTT.

Therefore the app requires an active broker using the default MQTT protocol.

The app subscribes to the following topics:
- led 
- humidity
- temperature

It shows the readings of a temperature sensor, humidity sensor and the state of an LED. The LED can be turned off or on via the app too.

## Requirements
- Dart >= 2.0
- Flutter
- Device with Android >= 8.0

## Build and run 
1. Install the Dart and Flutter SDK's.
2. Download the repository to your PC.
3. Run "pub get" to retrieve the project dependencies.
4. Run "flutter build apk" to generate an APK or "flutter run" to run the app on the AVD or a connected device.

## Notes
You will require a way to generate the JSON's that are sent to the device.

The app uses the MQTT protocol default port.

Because of a bug in the language libraries, the JSON must be delimited by ' instead of ".