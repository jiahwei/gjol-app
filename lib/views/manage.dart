import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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
        middle: Text('iOS Home'),
      ),
      child: Center(child: Text('Hello iOS')),
    );
  }
}
