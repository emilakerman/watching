import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';
import 'package:watching/app.dart';
import 'package:watching/config/enums/enums.dart';
// import 'package:watching/firebase_options.dart';

Future<void> mainBase({
  required WatchingEnvironment environment,
}) async {
  Logger().d('Starting app in ${dotenv.env['flavor']} environment');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: 'watching-${dotenv.env['flavor']}',
    options: environment.firebaseOptions,
  );
  runApp(App(environment));
}
