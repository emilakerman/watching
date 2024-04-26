import 'package:watching/config/enums/enums.dart';
import 'package:watching/main.dart';

import 'config/config.dart';

Future<void> main() async {
  // await dotenv.load(fileName: 'dotEnv.staging');
  await mainBase(environment: WatchingEnvironment.staging);
}
