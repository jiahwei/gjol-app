import 'package:flutter/material.dart';
import 'views/webview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gjol_app/network/api_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  await ApiProvider.init();
  final result = await request('/bulletins/query', method: 'GET', data: {'bulletin_id': 1});
  print(result);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const WebViewPage(initialUrl: 'https://gjoldb.info'),
    );
  }
}
