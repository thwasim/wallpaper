import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

part 'wallpaper_event.dart';
part 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  final Dio dio;
  final String accessKey = '8qaG5t0PT6BFN_MKn7nyjGCTtlx8fBGk5GpNnF2waFk';
  final String baseUrl = 'https://api.unsplash.com/photos';

  WallpaperBloc(this.dio) : super(WallpaperInitial()) {
    on<FetchWallpapers>(_onFetchWallpapers);
  }

  Future<void> _onFetchWallpapers(FetchWallpapers event, Emitter<WallpaperState> emit) async {
    try {
      emit(WallpaperLoading());
      final response = await dio.get(
        baseUrl,
        queryParameters: {
          'client_id': accessKey,
          'per_page': 20,
          'page': event.page,
        },
      );

      if (response.statusCode == 200) {
        final List<String> images = (response.data as List).map((item) => item['urls']['regular'].toString()).toList();

        emit(WallpaperLoaded(images));
      } else {
        emit(WallpaperError('Failed to fetch wallpapers.'));
      }
    } catch (e) {
      emit(WallpaperError(e.toString()));
    }
  }

  final GlobalKey globalKey = GlobalKey();

  Future<void> saveNetworkImage(BuildContext context, imgUrl) async {
    try {
      var response = await Dio().get(
        imgUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 80,
        name: "image",
      );
      log("Network Image saved: $result");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("image saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save image: $e")),
      );
    }
  }
}
