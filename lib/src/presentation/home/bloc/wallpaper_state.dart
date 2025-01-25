part of 'wallpaper_bloc.dart';

abstract class WallpaperState {}

class WallpaperInitial extends WallpaperState {}

class WallpaperLoading extends WallpaperState {}

class WallpaperLoaded extends WallpaperState {
  final List<String> images;

  WallpaperLoaded(this.images);
}

class WallpaperError extends WallpaperState {
  final String message;

  WallpaperError(this.message);
}
