import 'package:flutter/material.dart';
import 'third.dart';

class SecondPage extends StatefulWidget {
  final String userName;

  const SecondPage({super.key, required this.userName});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String selectedUserName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome! Glad to have you here',
              style: TextStyle(fontSize: 18),
            ),

            Text(
              '${widget.userName}',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const Spacer(),
            Center(
              child: Text(
                selectedUserName.isEmpty ? 'Selected User Name' : selectedUserName,
                style: const TextStyle(fontSize: 31, fontWeight: FontWeight.bold),
              ),
            ),

            const Spacer(),
            SizedBox(
              width: 400,
              height: 38,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThirdPage(),
                    ),
                  );

                  if (result != null && result is String) {
                    setState(() {
                      selectedUserName = result;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Choose a User'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
