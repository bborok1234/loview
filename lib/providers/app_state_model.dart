import 'package:flutter/material.dart';

class AppStateModel extends ChangeNotifier {
  int _appIndex = 0;

  get appIndex => _appIndex;

  set appIndex(int index) {
    _appIndex = index;
    notifyListeners();
  }

  bool _videoMute = false;

  get videoMute => _videoMute;
  void setVideoMute(bool flag) {
    _videoMute = flag;
    notifyListeners();
  }
}
