import 'package:flutter/material.dart';

class FalastraCard extends StatelessWidget {
  const FalastraCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 100,
      child: Image.asset(
        'assets/falastra.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
