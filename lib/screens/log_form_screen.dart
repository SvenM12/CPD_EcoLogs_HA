import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:green_steps/screens/eco_log_activity_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class LogFormScreen extends StatefulWidget {
  const LogFormScreen({super.key});

  @override
  State<LogFormScreen> createState() => _LogFormScreenState();
}

class _LogFormScreenState extends State<LogFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _caption = "";
  String _description = "";
  final ImagePicker _picker = ImagePicker();
  File? _image; 

    late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    requestNotificationPermission();
  }

   Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }


  void showSimpleNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'eco_action_channel', 'eco action notifications',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'New Activity added!',
    'The eco activity $_caption has been added',
    platformChannelSpecifics,
  );
}

Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  void _submitLog() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String imagePath = _image!.path;
      final url = Uri.https(
        'greensteps-226e2-default-rtdb.europe-west1.firebasedatabase.app',
        '/greensteps.json',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'caption': _caption,
          'description': _description,
          'imagePath': imagePath,
        }),
      );
      if (response.statusCode == 200) {
        showSimpleNotification();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EcoLogActivity()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(title: const Text("Log Eco Action"),
            backgroundColor: Colors.lightGreen,
),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _image == null
                      ? ElevatedButton(
                          onPressed: _takePhoto,
                          child: const Text('Take Photo'),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.file(_image!, height: 250, width: 250),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _takePhoto();
                              },
                              child: const Text('Retake Photo'),
                            ),
                          ],
                        ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "What did you do?"),
                    onSaved: (val) => _caption = val ?? "",
                    validator: (val) => val == null || val.isEmpty ? "Enter a caption" : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Briefly describe the activity"),
                    onSaved: (val) => _description = val ?? "",
                    validator: (val) => val == null || val.isEmpty ? "Enter a description" : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitLog,
              child: const Text("Submit Log"),
            ),
          ],
        ),
      ),
    );
  }
}
