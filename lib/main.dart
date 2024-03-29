import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'injectable.dart';
import 'router.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CABloc Demo',
      routerConfig: router,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
        ),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
        multitouchDragStrategy: MultitouchDragStrategy.latestPointer, // Disable double+ scroll speed. Since Flutter 3.19.0
      ),
    );
  }
}
