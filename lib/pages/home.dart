import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../image_card/image_card.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';
import '../helper/splitview.dart';

class PostsData {
  final List<Post> posts;

  PostsData({required this.posts});

  factory PostsData.fromJson(Map<String, dynamic> json) {
    var list = json['posts'] as List;
    List<Post> posts = list.map((i) => Post.fromJson(i)).toList();

    return PostsData(posts: posts);
  }
}

class Post {
  final String title;
  final String description;
  final bool sponsored;
  final String link;
  final String image;
  final String logo;
  final int height;

  Post({
    required this.title,
    required this.description,
    required this.sponsored,
    required this.link,
    required this.image,
    required this.logo,
    required this.height,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'] as String,
      description: json['description'] as String,
      sponsored: json['sponsored'] as bool,
      link: json['link'] as String,
      image: json['image'] as String,
      logo: json['logo'] as String,
      height: json['height'] as int,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.index = 0});

  final int index;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  final videoPlayerController = VideoPlayerController.asset('assets/posts/movies/Gala_2022.mp4');
  late ChewieController chewieController;
  late Chewie playerWidget;

  late Future<PostsData> postsData;

  Future<void> readJson() async {
    final String response = await DefaultAssetBundle.of(context).loadString('assets/json/posts.json');
    final data = await json.decode(response);

    setState(() {
      postsData = Future.value(PostsData.fromJson(data));
    });
  }

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
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    final playerWidget = Chewie(
      controller: chewieController,
    );

    setState(() {
      this.chewieController = chewieController;
      this.playerWidget = playerWidget;
    });

    readJson().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Splitview(
      left: NavigationDrawerWidget(),
      right: isLoading
          ? const Center(child: CircularProgressIndicator())
          : NavPages(
              playerWidget: playerWidget,
              postsData: postsData,
              index: widget.index,
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
  const NavPages({super.key, required this.playerWidget, required this.postsData, this.index = 0});

  final Widget playerWidget;
  final Future<PostsData> postsData;
  final int index;

  @override
  State<NavPages> createState() => _NavPagesState();
}

class _NavPagesState extends State<NavPages> {
  final String postPath = 'assets/posts/images/';
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentPageIndex = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('🎉 Accueil'),
      drawer: MediaQuery.of(context).size.width < breakpoint ? NavigationDrawerWidget() : null,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 56,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.explore_rounded),
            icon: Icon(Icons.explore_outlined),
            label: 'Explorer',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.photo_size_select_actual_rounded),
            icon: Icon(Icons.photo_size_select_actual_outlined),
            label: 'Affiche',
          ),
        ],
      ),
      body: <Widget>[
        Builder(
          builder: (context) => Center(
            child: SizedBox(
              width: min(800, MediaQuery.of(context).size.width),
              child: MyPlayer(playerWidget: widget.playerWidget),
            ),
          ),
        ),
        Builder(
          builder: (context) => Center(
            child: Column(
              children: <Widget>[
                FutureBuilder<PostsData>(
                  future: widget.postsData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.posts.length,
                          itemBuilder: (context, index) {
                            ImageProvider imageProvider =
                                AssetImage(postPath + snapshot.data!.posts[index].image);
                            ImageProvider logoProvider =
                                AssetImage(postPath + snapshot.data!.posts[index].logo);
                            Widget title = Text(
                              snapshot.data!.posts[index].title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                            Widget description = Text(
                              snapshot.data!.posts[index].description,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            );
                            return Column(
                              children: <Widget>[
                                TransparentImageCard(
                                  height: snapshot.data!.posts[index].height.toDouble(),
                                  width: min(600, MediaQuery.of(context).size.width),
                                  imageProvider: imageProvider,
                                  logoProvider: snapshot.data!.posts[index].logo != '' ? logoProvider : null,
                                  title: title,
                                  description: description,
                                  contentPadding: const EdgeInsets.all(24),
                                  borderRadius: 16,
                                  tags: <Widget>[
                                    snapshot.data!.posts[index].sponsored
                                        ? sponsoredWidget(snapshot.data!.posts[index].link)
                                        : const SizedBox(),
                                  ],
                                ),
                                const SizedBox(height: 48),
                              ],
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ),
        Builder(
          builder: (context) => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: const <Widget>[
                  Text(
                    'Notre Magnifique Affiche',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '👏 Bravo à Arielle !\nTu gagnes ta place pour le Gala ! 🥳',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48),
                  ICard(img_path: 'assets/images/affiche.png'),
                ],
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }

  Widget sponsoredWidget(String link) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          launchUrlString(link);
        },
        child: const Text('Sponsorisé 🤑'),
      ),
    );
  }
}

class MyPlayer extends StatefulWidget {
  const MyPlayer({super.key, required this.playerWidget});

  final Widget playerWidget;

  @override
  State<MyPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? loadingWidget() : widget.playerWidget;
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

class ICard extends StatefulWidget {
  const ICard({required this.img_path});

  final String img_path;

  @override
  State<ICard> createState() => _ICardState();
}

class _ICardState extends State<ICard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hover = true;
        });
      },
      onExit: (event) {
        setState(() {
          hover = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: min(600, MediaQuery.of(context).size.width),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: hover
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()
              ..scale(hover ? 1.05 : 1.0)
              ..translate(
                hover ? -min(600, MediaQuery.of(context).size.width) * 0.025 : 0,
                hover ? -min(600, MediaQuery.of(context).size.width) * 0.025 : 0,
              ),
            child: Image(
              image: AssetImage(widget.img_path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
