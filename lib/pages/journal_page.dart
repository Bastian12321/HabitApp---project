import 'package:flutter/material.dart';
import 'package:habitapp/util/audio.dart';


class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State <JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State <JournalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Journal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Journal for today',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 150,),
            Audio()
          ],
        )
      ),
    );
  }
}