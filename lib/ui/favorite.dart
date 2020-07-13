import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:loview/constants/constants.dart';
import 'package:loview/providers/api_spots_model.dart';

import 'package:loview/ui/grid_spots.dart';

class FavoriteView extends StatefulWidget {
  @override
  _FavoriteViewState createState() => new _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
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
      anchorOffset: 56,
    );
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ApiSpotsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '즐겨찾기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.258,
            fontFamily: "Roboto",
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: !model.apiStateError ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: GridSpots(
                    spots: model.favoritedSpots,
                    represented: false,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 1,
                    cardScale: 2,
                    showAddr: true,
                    favorite: true,
                    usedHeight: 202,
                  ),
              )
            ],
          ),
        ) : AlertDialog(
          title: new Text("네트워크 연결 오류"),
          content: new Text("네트워크 연결 확인 후 다시 실행해주세요"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            ),
          ],
        ),
      ),
    );
  }
}
