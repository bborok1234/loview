import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  final String title;
  final bool more;
  final Widget moreWidget;

  SubTitle({
    @required this.title,
    this.more,
    this.moreWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, top: 8, right: 8),
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.258,
                          fontFamily: "Roboto",
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Spacer(),
                  more ? Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        if (moreWidget != null) {
                          Navigator.of(context).push(
                            PageRouteBuilder(pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return moreWidget;
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
                        margin: EdgeInsets.only(right: 8),
                        child: Text(
                          "더보기",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14,
                            letterSpacing: 0.258,
                            fontFamily: "Roboto",
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ) : Spacer(),
                ]),
          ],
        ),
      ),
    );
  }
}
