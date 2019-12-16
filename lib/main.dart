import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:loview/constants/constants.dart';

import 'package:loview/providers/api_spots_model.dart';
import 'package:loview/providers/app_state_model.dart';

import 'package:loview/ui/app_main.dart';

void main() {
  runApp(LoviewApp());
  FirebaseAdMob.instance.initialize(appId: admobAppId);
}

class LoviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppStateModel>(
          create: (_) => AppStateModel(),
        ),
        ChangeNotifierProvider<ApiSpotsModel>(
          create: (_) => new ApiSpotsModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Loview',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: LoviewAppMain(),
      ),
    );
  }
}
