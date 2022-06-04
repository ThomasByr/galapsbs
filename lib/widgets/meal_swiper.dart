import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import '../cfg/cfg.dart';

class CustomMealSwiper extends Swiper {
  CustomMealSwiper({Key? key, required List items})
      : super(
          key: key,
          autoplay: false,
          autoplayDelay: 5000,
          autoplayDisableOnInteraction: true,
          duration: 1000,
          controller: SwiperController(),
          physics: const ClampingScrollPhysics(),
          itemCount: items.length,
          viewportFraction: window.physicalSize.width <= window.physicalSize.height ? 0.8 : 0.4,
          scale: 0.7,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 30),
              decoration: const BoxDecoration(
                  color: Palette.scaffold, borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: <Widget>[
                  Text(
                    items[index]['name'],
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Palette.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: Image.asset(items[index]['image']).image,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ImageIcon(
                                items[index]['is_vegan']
                                    ? const AssetImage('assets/icons/vegan.png')
                                    : const AssetImage('assets/icons/non_vegan.png'),
                                size: 20,
                                color: items[index]['is_vegan'] ? Palette.green : Palette.red,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                items[index]['is_vegan'] ? 'végétarien' : 'non végé',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Palette.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            items[index]['description'],
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Palette.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
}
