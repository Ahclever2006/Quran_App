import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  runApp(const QuranApp());
}
