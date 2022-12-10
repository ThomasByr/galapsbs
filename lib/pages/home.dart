import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
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
  final int height;

  Post({
    required this.title,
    required this.description,
    required this.sponsored,
    required this.link,
    required this.image,
    required this.height,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      description: json['description'],
      sponsored: json['sponsored'],
      link: json['link'],
      image: json['image'],
      height: json['height'],
    );
  }
}

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
  const NavPages({super.key, required this.playerWidget, required this.postsData});

  final Widget playerWidget;
  final Future<PostsData> postsData;

  @override
  State<NavPages> createState() => _NavPagesState();
}

class _NavPagesState extends State<NavPages> {
  int currentPageIndex = 0;

  final String postPath = 'assets/posts/images/';

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
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_rounded),
            label: 'Explorer',
          ),
        ],
      ),
      body: <Widget>[
        Builder(
          builder: (context) => Center(
            child: Column(
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .65,
                    width: min(800, MediaQuery.of(context).size.width),
                    child: MyPlayer(playerWidget: widget.playerWidget),
                  ),
                ),
                const SizedBox(height: 48),
              ],
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
                            return Center(
                              child: Column(
                                children: <Widget>[
                                  TransparentImageCard(
                                    height: snapshot.data!.posts[index].height.toDouble(),
                                    width: min(600, MediaQuery.of(context).size.width),
                                    imageProvider: imageProvider,
                                    title: title,
                                    description: description,
                                    contentPadding: const EdgeInsets.all(24),
                                    borderRadius: 16,
                                    tags: <Widget>[
                                      snapshot.data!.posts[index].sponsored
                                          ? sponsoredWidget(snapshot.data!.posts[index].link)
                                          : Container(),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
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
  const MyPlayer({required this.playerWidget});

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
