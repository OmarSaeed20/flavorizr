import 'package:flutter/material.dart';
import '../config/flavors.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(F.title)),
      body: Center(
        child: Column(
          children: [
            Text('Hello ${F.title}'),

            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.of(context).pushNamed('/home'),
            ),
          ],
        ),
      ),
    );
  }
}
