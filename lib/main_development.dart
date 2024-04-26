import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watching/config/enums/enums.dart';
import 'package:watching/main.dart';

import 'config/config.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'dotEnv.dev');
  await mainBase(environment: WatchingEnvironment.development);
}
