import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gjol_app/core/network/api_provider.dart';
import 'package:gjol_app/services/desvice_id.dart';
import 'package:flutter/material.dart';
import 'views/webview.dart';
import 'views/manage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();

  // final result = await request('/bulletins/query', method: 'GET', data: {'bulletin_id': 1});
  // print(result);
  runApp(MyApp());
}
Future<void> init() async{
  final env = String.fromEnvironment('ENV', defaultValue: 'dev');
  await dotenv.load(fileName: '.env.$env');
  await ApiProvider.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkAndroidId() async {
    final androidId = await getAndroidId();
    // TODO 这里逻辑应该从服务器获取
    return androidId == 'XXXXXXX';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: FutureBuilder<bool>(
        future: checkAndroidId(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          return snapshot.data == true
              ? const ManagePage()
              : const WebViewPage(initialUrl: 'https://gjoldb.info');
        },
      ),
    );
  }
}

