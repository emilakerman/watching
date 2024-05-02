import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watching/app.dart';
import 'package:watching/config/enums/enums.dart';

Future<void> mainBase({
  required WatchingEnvironment environment,
}) async {
  Logger().d('Starting app in ${dotenv.env['flavor']} environment');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: environment.firebaseOptions);
  await Supabase.initialize(
    anonKey: dotenv.env['supabaseAnonKey']!,
    url: dotenv.env['supabaseUrl']!,
    debug: true,
  );
  runApp(App(environment));
}
