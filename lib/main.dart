import 'package:flutter/material.dart';
import 'package:reso_coder/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Number Trivia',
        theme: ThemeData(
            colorScheme: ColorScheme.light(primary: Colors.green.shade600)),
        home: const NumberTriviaPage());
  }
}
