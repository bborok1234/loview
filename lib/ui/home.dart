import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:device_info/device_info.dart';

import 'package:loview/constants/constants.dart';
import 'package:loview/providers/api_spots_model.dart';

import 'package:loview/ui/api_spot_detail.dart';
import 'package:loview/ui/grid_spots.dart';
import 'package:loview/ui/subtitle.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  BannerAd myBanner;

  @override
  void initState() {
    super.initState();
    myBanner = new BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      targetingInfo: new MobileAdTargetingInfo(
        testDevices: [testId],
      ),
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
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          title: Text(
            'LOVIEW',
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
      ),
//      appBar: PreferredSize(
//        preferredSize: Size.fromHeight(80),
//        child: AppBar(
//          backgroundColor: Color.fromARGB(255, 255, 255, 255),
//          flexibleSpace: Container(
//            margin: EdgeInsets.only(left: 8, top: 32, right: 8, bottom: 8),
//            child: Image.asset(
//              "assets/images/loview_logo.png",
//              fit: BoxFit.fitHeight,
//            ),
//          ),
//        ),
//      ),
      body: Container(
        constraints: BoxConstraints.expand(height: size.height - 56 - 56 - 56 - 18),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: !model.apiStateError ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: SubTitle(title: "추천여행코스", more: false)),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: GridSpots(
                    spots: model.currentLoviewSpots,
                    represented: false,
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 1,
                    cardScale: 1,
                    showAddr: false,
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: SubTitle(
                    title: "지역별 여행코스",
                    more: true,
                    moreWidget: ApiSpotDetail(sType: spotType.apiSpot),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: GridSpots(
                    spots: model.representedSpots,
                    represented: true,
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 1,
                    cardScale: 1,
                    showAddr: false,
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: SubTitle(
                    title: "페스티벌 정보",
                    more: true,
                    moreWidget: ApiSpotDetail(sType: spotType.apiFestival),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: GridSpots(
                    spots: model.currentFestivalSpots,
                    represented: false,
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 1,
                    cardScale: 1,
                    showAddr: false,
                    length: 10,
                  )),
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
