import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  final videoPlayerController = VideoPlayerController.network(
      'https://drive.google.com/u/0/uc?id=1U-VfvExjcJBZTjguUMpjwKilD1cMOkEj&export=download');
  late ChewieController chewieController;
  late Chewie playerWidget;

  @override
  void initState() {
    super.initState();
    videoPlayerController.addListener(() {
      setState(() {});
    });
    videoPlayerController.initialize().then((_) {
      setState(() {
        isLoading = false;
      });
    });

    videoPlayerController.setLooping(true);
    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: true,
    );

    final playerWidget = Chewie(
      controller: chewieController,
    );

    setState(() {
      this.chewieController = chewieController;
      this.playerWidget = playerWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
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
                decoration: const BoxDecoration(
                  color: Palette.bg,
                ),
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
          // 100x100 progress indicator
          Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
          Center(
            child: Image(
              image: AssetImage('assets/images/logo.png'),
              height: 100,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}
