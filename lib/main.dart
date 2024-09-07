import 'package:flutter/material.dart';
import 'package:vietnam_flag/const.dart';
import 'package:vietnam_flag/vietnam_flag.dart';
import 'package:vietnam_flag/vietnam_flag_sketch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Việt Nam muôn năm - Chủ tịch Hồ Chí Minh muôn năm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: VietnamFlagColorPalette.red,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool paintSketchDone = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final flagSize = Size(size.width, 2 / 3 * size.width);

    return Container(
      color: Colors.white,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: !paintSketchDone
            ? Padding(
                padding: const EdgeInsets.all(64),
                child: VietnamFlagSketch(
                  flagSize: flagSize,
                  onPaintDone: () {
                    setState(() => paintSketchDone = true);
                  },
                ),
              )
            : VietnamFlag(flagSize: flagSize),
      ),
    );
  }
}
