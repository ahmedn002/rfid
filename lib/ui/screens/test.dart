import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Map<String, dynamic> students = {};

  @override
  void initState() {
    FirebaseFirestore.instance.collection('Students').get().then((QuerySnapshot querySnapshot) {
      setState(() {
        for (var doc in querySnapshot.docs) {
          students[doc.id] = doc.data();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            // Extract entry by index
            final MapEntry entry = students.entries.elementAt(index);

            // username
            // first_name
            // card_id

            return ListTile(
              title: Text(entry.value?['username'] ?? 'No username'),
              subtitle: Text(entry.value['first_name']),
              trailing: Text((entry.value['card_ID'] as double).toInt().toString()),
            );
          },
        ),
      ),
    );
  }
}
