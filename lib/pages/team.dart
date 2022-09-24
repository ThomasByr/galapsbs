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

class Data {
  final List<Member> members;

  Data({required this.members});

  factory Data.fromJson(Map<String, dynamic> data) {
    final List<Member> members =
        (data['profiles'] as List<dynamic>).map((dynamic item) => Member.fromJson(item)).toList();
    return Data(members: members);
  }
}

class Member {
  final String name, short, description, image;

  Member({required this.name, required this.short, required this.description, required this.image});

  factory Member.fromJson(Map<String, dynamic> data) {
    return Member(
      name: data['name'] as String,
      short: data['short'] as String,
      description: data['description'] as String,
      image: data['image'] as String,
    );
  }
}

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  int _nopeCount = 0, _likeCount = 0, _superCount = 0;
  bool isLoading = true, isDone = false;

  late List<Member> usersData;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/profiles.json');
    final data = Data.fromJson(json.decode(response));

    setState(
      () {
        usersData = data.members;

        if (usersData.isNotEmpty) {
          for (int i = 0; i < usersData.length; i++) {
            precacheImage(
              Image.asset(usersData[i].image).image,
              context,
            );

            _swipeItems.add(
              SwipeItem(
                content: Content(text: usersData[i].name),
                likeAction: () {
                  setState(() {
                    _likeCount++;
                  });
                },
                nopeAction: () {
                  setState(() {
                    _nopeCount++;
                  });
                },
                superlikeAction: () {
                  setState(() {
                    _superCount++;
                  });
                },
                onSlideUpdate: (SlideRegion? region) async {
                  debugPrint('Region $region');
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
        // usersData.shuffle(); //+ uncomment to shuffle
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: MyAppBar('👥 L\'équipe'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 24),
              const Text(
                '👋 Venez découvrir notre équipe dévouée !',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  width: min(500, MediaQuery.of(context).size.width),
                  child: isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 48,
                            width: 48,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : isDone
                          ? Center(
                              child: Text(
                                getEndString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
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
                                      shadowColor: Colors.purple,
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
                                          usersData[index].image,
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
                                                    usersData[index].name,
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
                                                    usersData[index].short,
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
                                                Container(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    usersData[index].description,
                                                    maxLines: 3,
                                                    softWrap: true,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      color: Palette.scaffold,
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
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
                                debugPrint('nopes: $_nopeCount | super: $_superCount | likes: $_likeCount');
                              },
                              itemChanged: (SwipeItem item, int index) {
                                debugPrint('item: ${item.content.text}, index: $index');
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
                color: Colors.red,
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
<<<<<<< HEAD
              backgroundColor: Colors.purple,
=======
              backgroundColor: Palette.purple,
>>>>>>> c11a8bd4dbb1cbfbab1f76ff71f63b1b46cf23fc
              child: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Palette.scaffold,
                ),
                onPressed: () {
                  _matchEngine!.currentItem?.superLike();
                },
                //child: const Text("Superlike"),
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
                color: Colors.red,
              ),
              onPressed: () {
                _matchEngine!.currentItem?.like();
              },
              //  child: const Text("Like"),
            ),
          ),
        ),
      ],
    );
  }

  String getEndString() {
    if (usersData.isNotEmpty) {
      if (_likeCount == usersData.length) {
        return '🙈 Tu as matché tous\nles membres de l\'équipe !\nMerci ❤️';
      } else if (_superCount == usersData.length) {
        return '🙈 Que des super-like !\nOn en a de la chance !\nMerci ❤️';
      } else if (_nopeCount == usersData.length) {
        return '🙈 Et dire que tu n\'aimes\npersonne dans l\'équipe... 🥲\nTon billet sera plus cher !';
      } else if (_nopeCount == 1) {
        return '🙊 Tu nous aimes tous !\nsauf un.e 😠\nBon promis je lui dit pas...';
      } else if (_superCount == 1) {
        return '🙉 On a un.e heureux.se élu.e !\nJe dis rien... promis !\nMais on se comprend 😇';
      } else if (_superCount >= _likeCount && _likeCount >= _nopeCount) {
        return '🙈 Un maximum de superlikes !\nC\'est la fête 🎉';
      } else if (_superCount > _nopeCount && _nopeCount >= _likeCount) {
        return '🙈 Un maximum de superlikes !\nMais plus de nopes que de likes...\n C\'est mieux que rien 😜';
      } else if (_likeCount >= _superCount && _superCount >= _nopeCount) {
        return '🙈 Un maximum de likes !\nEt de superlikes !\nMerci ❤️';
      } else if (_likeCount > _nopeCount && _nopeCount >= _superCount) {
        return '🙈 Globalement c\'est bon !\nTu nous détestes pas trop !\nMerci ❤️';
      } else if (_nopeCount >= _superCount && _superCount >= _likeCount) {
        return '🙊 Mais qu\'est-ce qu\'on a\nfait pour mériter ça ? 😭\n Soit ça passe\nsoit ça casse avec toi...';
      } else if (_nopeCount > _likeCount && _likeCount >= _superCount) {
        return '🙊 Globalement... C\'est la catastrophe\nMais on est sauvés par quelques\nlikes quand même ! 😮‍💨';
      }
      return 'Error on emptied queue';
    }
    return 'Error on empty queue';
  }
}
