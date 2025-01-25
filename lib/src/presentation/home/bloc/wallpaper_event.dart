part of 'wallpaper_bloc.dart';

abstract class WallpaperEvent {}

class FetchWallpapers extends WallpaperEvent {
  final int page;

  FetchWallpapers({this.page = 1});
}
