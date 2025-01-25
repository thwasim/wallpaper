import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_gallery_saver_example/src/presentation/home/bloc/wallpaper_bloc.dart';
import 'package:image_gallery_saver_example/src/presentation/home/view/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 1;
  List<String> images = [];
  bool isLoading = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    fetchWallpapers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchWallpapers() {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    context.read<WallpaperBloc>().add(FetchWallpapers(page: currentPage));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !isLoading) {
      setState(() {
        currentPage++;
      });
      fetchWallpapers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpapers', style: TextStyle(color: Colors.amber)),
      ),
      body: BlocListener<WallpaperBloc, WallpaperState>(
        listener: (context, state) {
          if (state is WallpaperLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is WallpaperLoaded) {
            setState(() {
              images.addAll(state.images);
              isLoading = false;
            });
          } else if (state is WallpaperError) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: images.isEmpty
                  ? const Center(child: Text('check availability of wallpaper'))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MasonryGridView.builder(
                        controller: _scrollController,
                        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (ctx, animation, secondaryAnimation) => FullScreen(imgUrl: images[index].toString()),
                                transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
                                  var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
                                  var scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
                                  return FadeTransition(
                                    opacity: fadeAnimation,
                                    child: ScaleTransition(
                                      scale: scaleAnimation,
                                      child: child,
                                    ),
                                  );
                                },
                              ));
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.network(images[index], fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
