import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver_example/src/presentation/home/bloc/wallpaper_bloc.dart';
import 'package:image_gallery_saver_example/src/presentation/home/view/home_screen.dart';

void main() {
  final Dio dio = Dio();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WallpaperBloc(dio)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
