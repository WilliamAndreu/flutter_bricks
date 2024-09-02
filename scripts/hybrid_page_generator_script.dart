import 'package:mason/mason.dart';
import 'dart:io';

final logger = Logger(theme: const LogTheme());

void main() async {
  try {
    final pageName = await promptPageName();

    if (pageName.isEmpty) {
      logger.err('Page name cannot be empty.');
      return;
    }

    if (checkIfPageExists(pageName)) {
      logger.warn('The page "$pageName" already exists.');
    } else {
      await generatePage(pageName);
    }
  } catch (e) {
    logger.err('An error occurred: $e');
  }
}

Future<String> promptPageName() async {
  return logger.prompt('Please enter the name of your page:');
}

Future<void> generatePage(String name) async {
  name = name.trim();
  final progress = logger.progress('Obtaining Git Bricks');
  try {
    checkValidName(name);

    await Future<void>.delayed(const Duration(seconds: 1));

    // Provide an update.
    progress.update('Generating Files');
    await Future<void>.delayed(const Duration(seconds: 1));

    final brick = Brick.git(
      const GitPath(
        'https://github.com/WilliamAndreu/flutter_bricks',
        path: 'bricks/hybrid_page_generator',
      ),
    );

    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(
      Directory.fromUri(Uri.parse('lib/layers/presentation/features')),
    );
    await generator.generate(target, vars: <String, dynamic>{'name': name});
    progress.complete('Done!');
    logger.success('Page "$name" generated successfully.');
  } on FormatException catch(e) {
    logger.err(e.message);
    progress.cancel();
  } catch (e) {
    logger.err('An error occurred while generating page: $e');
    progress.cancel();
    // Handle the error accordingly, e.g., logging, notifying the user, etc.
  }
}

bool checkIfPageExists(String name) {
  final directory = Directory('lib/layers/presentation/features/$name');
  return directory.existsSync();
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