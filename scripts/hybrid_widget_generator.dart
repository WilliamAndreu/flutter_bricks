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
      logger.warn('The page "$widgetName" already exists.');
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
    throw FormatException('Page name cannot be empty.');
  }

  final invalidChars = RegExp(r'[^\w\s\-]');

  if (invalidChars.hasMatch(name)) {
    throw FormatException('Page name contains invalid characters. Only letters, numbers, underscores, and hyphens are allowed.');
  }
}

bool checkIfWidgetExists({required String name, required String directoryPath}) {
  final directory = Directory('$directoryPath/$name');
  return directory.existsSync();
}

Future<WidgetType> getWidgetType() async {
  logger.info('What type of widget do you want to generate?');
  logger.info('1. Stateless');
  logger.info('2. Stateful');
  final typeSelection = await logger.prompt(': ');

  if (!['1', '2'].contains(typeSelection)) {
    throw FormatException('Invalid choice. Please enter 1 or 2.');
  }

  final isCubit = await logger.prompt('Would you like to use cubit? (y/n)');

  if (!['y', 'n'].contains(isCubit)) {
    throw FormatException('Invalid choice. Please enter y or n.');
  }

  if (isCubit == 'y') {
    return typeSelection == '1' ? WidgetType.statelessCubit : WidgetType.statefulCubit;
  } else {
    return typeSelection == '1' ? WidgetType.statelessDefault : WidgetType.statefulDefault;
  }
}

Future<String> getWidgetDirectory() async {
  final globalWidgetsPath = 'lib/layers/presentation/widgets';

  try {
    final featuresDir = Directory('lib/layers/presentation/features');
    final featuresList = featuresDir.listSync().whereType<Directory>().toList();

    if (featuresList.isEmpty) {
      return globalWidgetsPath;
    }

    logger.info('Where do you want to generate your widget?');
    logger.info('0. Global (At presentation folder)');

    for (int index = 0; index < featuresList.length; index++) {
      logger.info('${index + 1}. ${featuresList[index].path.split('/').last} feature');
    }

    final userSelection = await logger.prompt(': ');
    final userSelectionInt = int.tryParse(userSelection);

    if (userSelectionInt == null || userSelectionInt < 0 || userSelectionInt > featuresList.length) {
      throw FormatException('Invalid choice. Please enter a number between 0 and ${featuresList.length}.');
    }

    if (userSelectionInt == 0) {
      return globalWidgetsPath;
    } else {
      final featureName = featuresList[userSelectionInt - 1].path.split('/').last;
      return 'lib/layers/presentation/features/$featureName/widgets';
    }
  } catch (e) {
    logger.err('An error occurred: $e');
    return globalWidgetsPath;
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
    logger.err('An error occurred while generating page: $e');
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