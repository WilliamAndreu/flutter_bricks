import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part '{{name.lowerCase()}}_event.dart';
part '{{name.lowerCase()}}_state.dart';

class {{name.titleCase()}}Bloc extends Bloc<{{name.titleCase()}}Event, {{name.titleCase()}}State> {
  {{name.titleCase()}}Bloc() : super({{name.titleCase()}}Initial()) {
    on<{{name.titleCase()}}Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}
