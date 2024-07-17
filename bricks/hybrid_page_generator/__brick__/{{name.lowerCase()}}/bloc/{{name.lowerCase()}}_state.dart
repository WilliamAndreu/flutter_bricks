part of '{{name.lowerCase()}}_bloc.dart';

sealed class {{name.titleCase()}}State extends Equatable {
  const {{name.titleCase()}}State();

  @override
  List<Object> get props => [];
}

final class {{name.titleCase()}}Initial extends {{name.titleCase()}}State {}
