import 'package:mason/mason.dart';
import 'dart:io';

final logger = Logger(theme: const LogTheme());

enum WidgetType {
  statelessDefault,
  statefulDefault,
  statelessCubit,
  statefulCubit
}

void main() async {
  try {
    final widgetName = (await promptWidgetName()).trim();

    checkValidName(widgetName);

    final widgetType = await getWidgetType();
    final widgetLocation = await getWidgetDirectory();

    if (checkIfWidgetExists(name: widgetName, directoryPath: widgetLocation)) {
      logger.warn('The widget "$widgetName" already exists in "$widgetLocation".');
    } else {
      await generateWidget(name: widgetName, widgetType: widgetType, directoryPath: widgetLocation);
    }
  } on FormatException catch(e) {
    logger.err(e.message);
  } catch (e) {
    logger.err('An error occurred: $e');
  }
}

Future<String> promptWidgetName() async {
  return logger.prompt('Please enter the name of your widget:');
}

void checkValidName(String name) {
  if (name.isEmpty) {
    throw FormatException('Widget name cannot be empty.');
  }

  final invalidChars = RegExp(r'[^\w\s\-]');

  if (invalidChars.hasMatch(name)) {
    throw FormatException('Widget name contains invalid characters. Only letters, numbers, underscores, and hyphens are allowed.');
  }
}

bool checkIfWidgetExists({required String name, required String directoryPath}) {
  final directory = Directory('$directoryPath/$name');
  return directory.existsSync();
}

Future<WidgetType> getWidgetType() async {
  final typeSelection = await logger.chooseOne(
    'What type of widget do you want to generate?',
    choices: ['Stateless', 'Stateful'],
    defaultValue: 'Stateless',
  );

  final isCubit = await logger.confirm(
    'Would you like to use cubit?', 
    defaultValue: false,
  );

  if (isCubit) {
    return typeSelection == 'Stateless' ? WidgetType.statelessCubit : WidgetType.statefulCubit;
  } else {
    return typeSelection == 'Stateless' ? WidgetType.statelessDefault : WidgetType.statefulDefault;
  }
}

Future<String> getWidgetDirectory() async {
  final globalWidgetsPath = 'lib/layers/presentation/widgets';
  final featuresDir = Directory('lib/layers/presentation/features');

  if (!featuresDir.existsSync()) {
    return globalWidgetsPath;
  }

  final featuresList = featuresDir.listSync().whereType<Directory>().toList();

  if (featuresList.isEmpty) {
    return globalWidgetsPath;
  }

  final userSelection = await logger.chooseOne(
    'Where do you want to generate your widget?',
    choices: [
      'Global (At presentation folder)',
      ...featuresList.map((e) => e.path.split('/').last),
    ],
    defaultValue: 'Global (At presentation folder)',
  );

  if (userSelection == 'Global (At presentation folder)') {
    return globalWidgetsPath;
  } else {
    return 'lib/layers/presentation/features/$userSelection/widgets';
  }
}

Future<void> generateWidget({required String name, required WidgetType widgetType, required String directoryPath}) async {
  final progress = logger.progress('Obtaining Git Bricks');
  try {
    await Future<void>.delayed(const Duration(seconds: 1));

    progress.update('Generating Files');
    await Future<void>.delayed(const Duration(seconds: 1));

    final gitPath = getGitPath(widgetType: widgetType);

    final brick = Brick.git(gitPath);

    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(
      Directory.fromUri(Uri.parse(directoryPath)),
    );
    await generator.generate(target, vars: <String, dynamic>{'name': name});
    progress.complete('Done!');
    logger.success('Page "$name" generated successfully.');
  } catch (e) {
    logger.err('An error occurred while generating widget: $e');
    progress.cancel();
  }
}

GitPath getGitPath({required WidgetType widgetType}) {
  switch (widgetType) {
    case WidgetType.statelessDefault:
      return const GitPath(
        'https://github.com/WilliamAndreu/flutter_bricks',
        path: 'bricks/hybrid_widget_generator/stateless/base',
      );
    case WidgetType.statelessCubit:
      return const GitPath(
        'https://github.com/WilliamAndreu/flutter_bricks',
        path: 'bricks/hybrid_widget_generator/stateless/cubit',
      );
    case WidgetType.statefulDefault:
      return const GitPath(
        'https://github.com/WilliamAndreu/flutter_bricks',
        path: 'bricks/hybrid_widget_generator/stateful/base',
      );
    case WidgetType.statefulCubit:
      return const GitPath(
        'https://github.com/WilliamAndreu/flutter_bricks',
        path: 'bricks/hybrid_widget_generator/stateful/cubit',
      );
  }
}