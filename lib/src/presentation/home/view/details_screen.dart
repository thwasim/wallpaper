import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver_example/src/presentation/home/bloc/wallpaper_bloc.dart';

class FullScreen extends StatelessWidget {
  final String imgUrl;
  const FullScreen({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<WallpaperBloc, WallpaperState>(
  builder: (context, state) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                key: context.read<WallpaperBloc>().globalKey,
                child: Image.network(imgUrl, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.download_sharp, color: Colors.white),
                  onPressed: () {
                    context.read<WallpaperBloc>().saveNetworkImage(context, imgUrl);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
    
  }
}
