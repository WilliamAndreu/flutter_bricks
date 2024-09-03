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

class _{{name.pascalCase()}}View extends StatefulWidget {
  const _{{name.pascalCase()}}View({super.key});

  @override
  State<_{{name.pascalCase()}}View> createState() => __{{name.pascalCase()}}ViewState();
}

class __{{name.pascalCase()}}ViewState extends State<_{{name.pascalCase()}}View> {

  {{name.pascalCase()}}Cubit get cubit => context.read<{{name.pascalCase()}}Cubit>();

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