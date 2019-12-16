import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:loview/constants/constants.dart';
import 'package:loview/providers/api_spots_model.dart';

import 'package:loview/ui/grid_spots.dart';
import 'package:loview/ui/loview_spot_detail.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() {
    return _SearchViewState();
  }
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';
  spotType sType = spotType.loview;
  BannerAd myBanner;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
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
    _focusNode.dispose();
    _controller.dispose();
    myBanner?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _terms = _controller.text;
    });
  }

  void _onTypeChanged(spotType value) {
    setState(() {
      sType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ApiSpotsModel>(context);
    var results;

    switch(sType) {
      case spotType.loview:
        results = model.searchTermLoview(_terms);
        break;
      case spotType.apiSpot:
        results = model.searchTermApi(_terms);
        break;
      case spotType.apiFestival:
        results = model.searchTermFestival(_terms);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '여행지 검색',
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
        height: 624.4,
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
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                    ),
                    DropdownButton(
                      items: [
                        DropdownMenuItem(
                          value: spotType.loview,
                          child: new Text(
                            '추천'
                          ),
                        ),
                        DropdownMenuItem(
                          value: spotType.apiSpot,
                          child: new Text(
                            '지역별'
                          ),
                        ),
                        DropdownMenuItem(
                          value: spotType.apiFestival,
                          child: new Text(
                            '페스티벌'
                          ),
                        ),
                      ],
                      value: sType,
                      onChanged: (value) {
                        _onTypeChanged(value);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                      ),
                    ),
                    GestureDetector(
                      onTap: _controller.clear,
                      child: const Icon(
                        Icons.clear,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: GridSpots(
                    spots: results,
                    represented: false,
                    onClickWidget: sType == spotType.loview ? LoviewDetail() : null,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 1,
                    cardScale: 2,
                    showAddr: true,
                    usedHeight: 258,
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
