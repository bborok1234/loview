import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:loview/constants/constants.dart';
import 'package:loview/providers/api_spots_model.dart';

import 'package:loview/ui/subtitle.dart';
import 'package:loview/ui/grid_spots.dart';

class ApiSpotDetail extends StatelessWidget {
  const ApiSpotDetail({
    Key key,
    this.sType,
  }) : super(key: key);

  final spotType sType;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ApiSpotsModel>(context);

    Widget scaffold = new Scaffold(
      appBar: AppBar(
        title: Text(
          sType == spotType.apiSpot ? '지역별 여행코스' : '페스티벌 정보',
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
        margin: EdgeInsets.all(8),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8, top: 8, right: 8),
              child: Row(
                // row size is 56
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '지역 선택',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.154,
                        fontFamily: "Roboto",
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 200,
                    child: new DropdownButton(
                      items: getDropDownStates(),
                      value: model.currentState,
                      onChanged: (value) => model.setCurrentState(value),
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8, top: 8, right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '시군구 선택',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.154,
                        fontFamily: "Roboto",
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 200,
                    child: new DropdownButton(
                      items: getDropDownCities(model.currentState),
                      value: model.currentCity,
                      onChanged: (value) => model.setCurrentCity(value),
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
            ),
            SubTitle(title: "지역별 여행코스", more: false),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GridSpots(
                    spots: sType == spotType.apiFestival ? model.searchFestivalSpot() : model.searchSpot(),
                    represented: false,
                    onClickWidget: null,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 1,
                    cardScale: 2,
                    showAddr: true,
                    usedHeight: 350,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

//    getSizes(_keyAppBar);
    return scaffold;
  }
}
