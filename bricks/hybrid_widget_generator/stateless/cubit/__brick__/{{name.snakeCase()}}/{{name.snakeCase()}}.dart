import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '{{name.snakeCase()}}_cubit.dart';

class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<{{name.pascalCase()}}Cubit>(
      create: (context) => {{name.pascalCase()}}Cubit(),
      child: const _{{name.pascalCase()}}View(),
    );
  }
}

class _{{name.pascalCase()}}View extends StatelessWidget {
  const _{{name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<{{name.pascalCase()}}Cubit, int>(
      builder: (context, state) {
        return Center(
          child: Text('$state'),
        );
      },
    )
  }
}