import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gjol_app/provider/auth.dart';
import 'package:gjol_app/views/webview.dart';
import 'package:gjol_app/views/manage.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isOpenManage = ref.watch(isOpenManageProvider);
    return isOpenManage.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (data) {
        if (!data.isOpenManage) {
          return const WebViewPage(initialUrl: 'https://gjoldb.info');
        }

        final pages = <Widget>[
          const WebViewPage(initialUrl: 'https://gjoldb.info'),
          const ManagePage(),
        ];

        return Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.public), label: '主页'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: '管理'),
            ],
            onTap: (i) => setState(() => _currentIndex = i),
          ),
        );
      },
    );
  }
}
