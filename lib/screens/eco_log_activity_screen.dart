import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_steps/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class EcoLogActivity extends StatefulWidget {
  const EcoLogActivity({super.key});
  @override
  _EcoLogActivityState createState() => _EcoLogActivityState();
}

class _EcoLogActivityState extends State<EcoLogActivity> {
       final url = Uri.https(
        'greensteps-226e2-default-rtdb.europe-west1.firebasedatabase.app',
        '/greensteps.json'
      );
  List<File> _imageFiles = [];
  List<String> _captions = [];
  List<String> _descriptions = [];
  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        List<File> imageFiles = [];
        List<String> captions = [];
        List<String> descriptions = [];
        data.forEach((key, value) {
          final path = value['imagePath'];
          final file = File(path);
          final caption = value['caption'];
          final description = value['description'];
          if (file.existsSync()) {
            imageFiles.add(file);
          }

          if (caption != null)
          {
            captions.add(caption);
          }

          if (description != null)
          {
            descriptions.add(description);
          }
        });

        setState(() {
          _imageFiles = imageFiles;
          _captions = captions;
          _descriptions = descriptions;
        });
      }
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.lightGreen,
    appBar: AppBar(
      title: const Text('EcoLog Activity'),
      backgroundColor: Colors.lightGreen,
    ),
    body: _imageFiles.isEmpty
        ? const Center(child: Text('No images available'))
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: _imageFiles.length,
            itemBuilder: (context, index) {
              final imageFile = _imageFiles[index];
              final caption = _captions[index];
              final desc = _descriptions[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        caption,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        desc,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    floatingActionButton: FloatingActionButton.extended(
      icon: const Icon(Icons.home_filled),
      label: Text('Home'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
    ),
  );
}
}