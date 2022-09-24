import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

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
      looping: true,
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
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: MyAppBar('🎉 Accueil'),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            children: <Widget>[
              // const SizedBox(height: 48),
              SizedBox(
                height: MediaQuery.of(context).size.height * .65,
                width: min(400, MediaQuery.of(context).size.width),
                child: isLoading ? loadingWidget() : Center(child: playerWidget),
              ),
              const SizedBox(height: 48),
              Container(
                width: min(window.physicalSize.width, 400),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: OpenNavWidget(
                  icon: Icons.menu,
                  text: 'Voir Plus',
                  onClicked: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
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
              image: AssetImage('assets/images/logo.png'),
              height: 200,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}
