import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:swipe_cards/draggable_card.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class Content {
  final String? text;

  Content({this.text});
}

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  bool isLoading = true, isDone = false;

  late List usersData;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/profiles.json');
    final data = await json.decode(response);

    setState(
      () {
        usersData = data['profile'];

        if (usersData.isNotEmpty) {
          for (int i = 0; i < usersData.length; i++) {
            precacheImage(
              Image.asset(usersData[i]['image']).image,
              context,
            );

            _swipeItems.add(
              SwipeItem(
                content: Content(text: usersData[i]['name']),
                // likeAction: () {
                //   _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                //     content: Text('Liked '),
                //     duration: Duration(milliseconds: 500),
                //   ));
                // },
                // nopeAction: () {
                //   _scaffoldKey.currentState?.showSnackBar(SnackBar(
                //     content: Text('Nope ${usersData[i]['name']}'),
                //     duration: const Duration(milliseconds: 500),
                //   ));
                // },
                // superlikeAction: () {
                //   _scaffoldKey.currentState?.showSnackBar(SnackBar(
                //     content: Text('Superliked ${usersData[i]['name']}'),
                //     duration: const Duration(milliseconds: 500),
                //   ));
                // },
                onSlideUpdate: (SlideRegion? region) async {
                  print('Region $region');
                },
              ),
            );
          }
        }
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    readJson().then((_) {
      setState(() {
        isLoading = false;
        // usersData.shuffle(); // uncomment to shuffle
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      drawer: const NavigationDrawerWidget(),
      appBar: MyAppBar('👥 L\'équipe'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 48),
              const Text(
                '👋 Venez découvrir notre équipe dévouée !',
                style: TextStyle(
                  fontSize: 16,
                  color: Palette.scaffold,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .6,
                      width: min(600, MediaQuery.of(context).size.width),
                      child: isLoading
                          ? const Center(
                              child: SizedBox(
                                height: 48,
                                width: 48,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Palette.scaffold),
                                  color: Palette.scaffold,
                                ),
                              ),
                            )
                          : isDone
                              ? const Center(
                                  child: Text(
                                    '🙈 Vous avez déjà matché\ntoutes les personnes ! ❤️',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Palette.scaffold,
                                    ),
                                  ),
                                )
                              : SwipeCards(
                                  matchEngine: _matchEngine!,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Card(
                                          margin: const EdgeInsets.all(16.0),
                                          shadowColor: Palette.purple,
                                          elevation: 12.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24.0),
                                          ),
                                          color: Palette.scaffold,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(24.0),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(24.0)),
                                            color: Palette.black,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                            child: Image.asset(
                                              usersData[index]['image'],
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.high,
                                              isAntiAlias: true,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: 136.0,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(24.0),
                                                bottomRight: Radius.circular(24.0),
                                              ),
                                              color: Color.fromARGB(155, 51, 51, 51),
                                            ),
                                            margin: const EdgeInsets.all(24.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        usersData[index]['name'].toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        style: const TextStyle(
                                                          color: Palette.scaffold,
                                                          fontSize: 26,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Text(
                                                        usersData[index]['short'].toString(),
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        textAlign: TextAlign.left,
                                                        style: const TextStyle(
                                                          color: Palette.scaffold,
                                                          fontSize: 18.0,
                                                          fontWeight: FontWeight.bold,
                                                          fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Text(
                                                        usersData[index]['description'].toString(),
                                                        maxLines: 3,
                                                        softWrap: false,
                                                        textAlign: TextAlign.left,
                                                        style: const TextStyle(
                                                          color: Palette.scaffold,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  onStackFinished: () {
                                    setState(() {
                                      isDone = true;
                                    });
                                    _scaffoldKey.currentState!.showSnackBar(const SnackBar(
                                      content: Text('Stack Finished'),
                                      duration: Duration(milliseconds: 500),
                                    ));
                                    // isLoading = true;
                                    // initState();
                                  },
                                  itemChanged: (SwipeItem item, int index) {
                                    print('item: ${item.content.text}, index: $index');
                                  },
                                  upSwipeAllowed: true,
                                  fillSpace: true,
                                ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  makeBottomButtons(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: Palette.scaffold,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Palette.black,
                spreadRadius: 2,
              )
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Palette.scaffold,
            child: IconButton(
              icon: const Icon(
                Icons.thumb_down_alt_rounded,
                color: Palette.red,
              ),
              onPressed: () {
                _matchEngine!.currentItem?.nope();
              },
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Palette.scaffold,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Palette.black,
                spreadRadius: 2,
              )
            ],
          ),
          child: CircleAvatar(
            radius: 36.0,
            backgroundColor: Palette.scaffold,
            child: CircleAvatar(
              radius: 32.0,
              backgroundColor: Palette.purple,
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Palette.scaffold,
                    size: 36.0,
                  ),
                  onPressed: () {
                    _matchEngine!.currentItem?.superLike();
                  },
                  //child: const Text("Superlike"),
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Palette.scaffold,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Palette.black,
                spreadRadius: 2,
              )
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Palette.scaffold,
            child: IconButton(
              icon: const Icon(
                Icons.thumb_up_alt_rounded,
                color: Palette.red,
              ),
              onPressed: () {
                _matchEngine!.currentItem?.like();
              },
              //  child: const Text("Like"),
            ),
          ),
        )
      ],
    );
  }
}
