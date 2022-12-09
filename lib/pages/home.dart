import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';
import '../helper/splitview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Wrapper<bool> isLoading = Wrapper(true);
  int _selectedIndex = 0;

  final videoPlayerController = VideoPlayerController.asset('assets/posts/movies/Gala_2022.mp4');
  late ChewieController chewieController;
  late Chewie playerWidget;

  @override
  void initState() {
    super.initState();
    videoPlayerController.initialize();

    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      useRootNavigator: true,
      aspectRatio: 16 / 9,
      autoInitialize: false,
    );

    final playerWidget = Chewie(
      controller: chewieController,
    );

    setState(() {
      this.chewieController = chewieController;
      this.playerWidget = playerWidget;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Splitview(
      left: NavigationDrawerWidget(),
      right: NavPages(
        playerWidget: playerWidget,
        isLoading: isLoading,
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}

class NavPages extends StatefulWidget {
  const NavPages({super.key, required this.playerWidget, required this.isLoading});

  final Widget playerWidget;
  final Wrapper<bool> isLoading;

  @override
  State<NavPages> createState() => _NavPagesState();
}

class _NavPagesState extends State<NavPages> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
        ],
      ),
      body: <Widget>[
        Builder(
          builder: (context) => Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .65,
                  width: min(800, MediaQuery.of(context).size.width),
                  child: widget.isLoading.value ? loadingWidget() : widget.playerWidget,
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            children: const <Widget>[
              SizedBox(height: 48),
              Text('Commute'),
            ],
          ),
        ),
      ][currentPageIndex],
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Stack(
        children: const <Widget>[
          Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
          Center(
            child: Image(
              image: AssetImage('assets/images/gala.png'),
              height: 200,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}
