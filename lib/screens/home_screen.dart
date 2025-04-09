import 'package:flutter/material.dart';
import 'package:green_steps/screens/log_form_screen.dart';
import 'eco_log_activity_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(title: const Text("Welcome to Eco Logs"),
      centerTitle: true,
      backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Eco Logs Home Menu", style: TextStyle(fontSize: 32, color: Colors.green, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Image.asset('assets/ecofriend.png'),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            icon: const Icon(Icons.list),
            label: Text('View Activities'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EcoLogActivity()),
              );
            },
          ),
          const SizedBox(width: 50),
          FloatingActionButton.extended(
            heroTag: "fab_right",
            icon: const Icon(Icons.add_a_photo_rounded),
            label: Text('Add new Activity'),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const LogFormScreen()));
            }
          )
        ],
      ),
    );
  }
}
