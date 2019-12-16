import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:loview/constants/constants.dart';

import 'package:loview/providers/api_spots_model.dart';

import 'package:loview/models/spot.dart';

import 'package:loview/ui/api_spot_detail.dart';
import 'package:loview/ui/loview_spot_detail.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    this.index,
    this.spot,
    this.isFavorite,
    this.represented,
    this.scale,
    this.showAddr,
  });

  final Spot spot;
  final int index;
  final bool isFavorite;
  final bool represented;
  // scale = 1 or 2
  final int scale;
  final bool showAddr;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ApiSpotsModel>(context);
    var size = MediaQuery.of(context).size;
    final double itemWidth = (size.width - 16) / 2;

    return GestureDetector(
      onTap: () {
        model.setTappedSpot(spot);
        model.setCurrentState(stateNames[spot.stateCode]);

        Widget onClickWidget;

        switch (spot.type) {
          case spotType.loview:
            onClickWidget = LoviewDetail(spot: spot);
            break;
          case spotType.apiSpot:
            if (represented) {
              onClickWidget = ApiSpotDetail(sType: spot.type);
            }
            break;
          case spotType.apiFestival:
            onClickWidget = null;
            break;
        }

        if (onClickWidget != null) {
          Navigator.of(context).push(
            PageRouteBuilder(pageBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return onClickWidget;
            }, transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return FadeTransition(opacity: animation, child: child);
            }),
          );
        }
      },
      child: Container(
        height: 216,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: 216,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(51, 0, 0, 0),
                      offset: Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/spinner.gif',
                  image: spot.images[0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 36.0 * scale + 12.0,
                decoration: BoxDecoration(
                  color: Colors.black54,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: itemWidth / (-1.0 * scale + 2.8),
                      margin: EdgeInsets.only(left: 16),
                      child: !showAddr ? Text(
                        represented ? stateNames[spot.stateCode] :
                          spot.title,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                          letterSpacing: 0.154,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ) : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              represented ? stateNames[spot.stateCode] :
                                spot.title,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14,
                                letterSpacing: 0.154,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              spot.addr,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 12,
                                letterSpacing: 0.154,
                                fontFamily: "Roboto",
                              ),
                              textAlign: TextAlign.left,
                            ),
                            spot.tell != 'null'? Text(
                              spot.tell,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 12,
                                letterSpacing: 0.154,
                                fontFamily: "Roboto",
                              ),
                              textAlign: TextAlign.left,
                            ): null,
                          ].where((e) => e != null).toList(),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 12),
                      child: Opacity(
                        opacity: represented ? 0.0 : 0.8,
                        child: IconButton(
                          iconSize: 30,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            if (model.checkFavorited(spot.id)) {
                              model.removeSpotToFavorite(spot.id);
                            }
                            else {
                              model.addSpotToFavorite(spot.id, spot);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
