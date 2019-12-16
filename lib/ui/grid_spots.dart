import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:loview/constants/constants.dart';

import 'package:loview/providers/api_spots_model.dart';

import 'package:loview/models/spot.dart';
import 'package:loview/ui/image_card.dart';

class GridSpots extends StatelessWidget {
  const GridSpots({
    Key key,
    this.spots,
    this.represented,
    this.onClickWidget,
    this.scrollDirection,
    this.crossAxisCount,
    this.cardScale,
    this.showAddr,
    this.length = 0,
    this.favorite = false,
    this.usedHeight = 0,
  }) : super(key: key);

  final List<Spot> spots;
  final bool represented;
  final Widget onClickWidget;
  final Axis scrollDirection;
  final int crossAxisCount;
  final int cardScale;
  final bool showAddr;
  final int length;
  final bool favorite;
  final double usedHeight;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = (size.width - 16) / 2;
    final double itemHeight = 216;

    final model = Provider.of<ApiSpotsModel>(context);

    return model.busy
      ? Center(
          child: CircularProgressIndicator(),
      )
      : Container(
          margin: EdgeInsets.only(top: 8),
          height: usedHeight == 0 ? 216.0 * cardScale : size.height - usedHeight,
          child: GridView.count(
            scrollDirection: scrollDirection,
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            childAspectRatio: (itemHeight / itemWidth) * cardScale,
            crossAxisCount: crossAxisCount,
            // Generate 100 widgets that display their index in the List.
            children: List.generate((length != 0 && spots.length >= length) ? length : spots.length, (index) {
              return Center(
                child: ImageCard(
                  index: index,
                  spot: spots[index],
                  isFavorite: model.checkFavorited(spots[index].id),
                  represented: represented,
                  scale: cardScale,
                  showAddr: showAddr,
                ),
              );
            },
          ),
        ),
      );
  }
}
