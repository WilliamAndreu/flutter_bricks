import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/{{name.lowerCase()}}_bloc.dart';

//TODO {{name.titleCase()}} Page
class {{name.titleCase()}}Page extends StatelessWidget {
  const {{name.titleCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => {{name.titleCase()}}Bloc(),
      child: const _{{name.titleCase()}}View(),
    );
  }
}

class _{{name.titleCase()}}View extends StatelessWidget {
  const _{{name.titleCase()}}View();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('{{name.titleCase()}}Page'),
      ),
    );
  }
}
