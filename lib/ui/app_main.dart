import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:custom_navigator/custom_scaffold.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:loview/constants/constants.dart';
import 'package:loview/providers/app_state_model.dart';

import 'package:loview/ui/favorite.dart';
import 'package:loview/ui/home.dart';
import 'package:loview/ui/search.dart';


var currentTab = [
  HomeView(),
  SearchView(),
  FavoriteView(),
];

class LoviewAppMain extends StatefulWidget {
  LoviewAppMain({
    Key key,
  }) : super(key: key);

  @override
  _LoviewAppMainState createState() => new _LoviewAppMainState();
}

class _LoviewAppMainState extends State<LoviewAppMain> {
  BannerAd myBanner;

  @override
  void initState() {
    super.initState();
    myBanner = new BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      targetingInfo: new MobileAdTargetingInfo(),
      listener: (MobileAdEvent event) {},
    );
    myBanner..load()..show(
      // Banner Position
      anchorType: AnchorType.bottom,
    );
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);

    return SplashScreen(
      seconds: 5,
      title: new Text(
        'LOVIEW',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.258,
          fontFamily: "Roboto",
          shadows: [
            Shadow( // bottomLeft
              offset: Offset(-1.5, -1.5),
              color: Colors.black,
            ),
            Shadow( // bottomRight
              offset: Offset(1.5, -1.5),
              color: Colors.black
            ),
            Shadow( // topRight
              offset: Offset(1.5, 1.5),
              color: Colors.black
            ),
            Shadow( // topLeft
              offset: Offset(-1.5, 1.5),
              color: Colors.black
            ),
          ],
        ),
      ),
      image: new Image.asset('assets/images/loview.png'),
      imageBackground: new AssetImage('assets/images/splash.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: const TextStyle(
        fontSize: 32,
        color: Color.fromARGB(255, 255, 255, 255),
        fontFamily: "Roboto",
      ),
      loadingText: new Text(
        'Now Loading',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.258,
          fontFamily: "Roboto",
        ),
      ),
      photoSize: 100.0,
      loaderColor: Colors.red,
      navigateAfterSeconds: CustomScaffold(
        scaffold: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            //nav bar size is 56
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('여행지 추천'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text('검색'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                title: Text('좋아요'),
              ),
            ],
            currentIndex: model.appIndex,
            onTap: (index) {
              model.appIndex = index;
            },
          ),
          body: currentTab[model.appIndex],
        ),
        children: currentTab,
        onItemTap: (index) {
          model.appIndex = index;
        },
      ),
    );
  }
}
