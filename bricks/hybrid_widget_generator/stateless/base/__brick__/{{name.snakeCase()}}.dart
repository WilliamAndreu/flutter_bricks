import 'package:flutter/material.dart';

class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('{{name.pascalCase()}} Widget'),
    );
  }
}