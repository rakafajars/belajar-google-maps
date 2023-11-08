import 'package:flutter/material.dart';

class Gmaps extends StatefulWidget {
  const Gmaps({super.key});

  @override
  State<Gmaps> createState() => _GmapsState();
}

class _GmapsState extends State<Gmaps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
    );
  }
}
