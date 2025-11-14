import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gjol_app/provider/dev.dart';
class ManagePage extends StatelessWidget{
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context){
    return CupertinoApp(
      home: const ManageContent()
    );

  }
}

class ManageContent extends StatelessWidget{
  const ManageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('管理'),
      ),
      child: Consumer(builder: (context, ref, child) {
          final testResolve = ref.watch(devTestResolveProvider('2025-10-01'));
          return Text(testResolve.when(
            data: (data) => data.toString(),
            loading: () => 'Loading...',
            error: (error, stackTrace) => error.toString(),
          ));
        }),
    );
  }
}
