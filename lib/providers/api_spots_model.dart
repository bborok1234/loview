import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:loview/constants/constants.dart';
import 'package:loview/models/spot.dart';

class ApiSpotsModel extends ChangeNotifier {
  GlobalKey savedKey;
  var favoriteLoaded = false;
  var loviewSpotLoaded = false;
  var apiSpotLoaded = false;
  var festivalSpotLoaded = false;

  bool get finishInit => favoriteLoaded && loviewSpotLoaded && apiSpotLoaded && festivalSpotLoaded;

  ApiSpotsModel() {
    _currentApiSpots = new List<Spot>();
    _currentFestivalSpots = new List<Spot>();
    _representedSpots = new List<Spot>();

    _initPrefs();

    updateLoviewSpots();
    updateApiSpots();
    updateFestivalSpots();
  }

  Future _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var encoded = prefs.getString('loview_favorite');
    if (encoded != null) {
      Map<String, dynamic> decoded = json.decode(encoded);
      Map<String, Spot> savedSpot = <String, Spot>{};

      decoded.forEach((k, v) {
        savedSpot[k] = Spot.fromJson(v, spotType.loview);
      });

      _favoritedSpots = savedSpot;
    }
    else {
      _favoritedSpots = <String, Spot>{};
    }

    favoriteLoaded = true;
  }

  final Firestore _db = Firestore.instance;
  var prefs;
  var client = new http.Client();

  List<Spot> _currentLoviewSpots;

  List<Spot> _currentApiSpots;
  List<Spot> _currentFestivalSpots;
  List<Spot> _representedSpots;

  Spot _tappedSpot;
  Spot get tappedSpot => _tappedSpot;
  void setTappedSpot(Spot spot) {
    _tappedSpot = spot;
    notifyListeners();
  }

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  bool _apiStateError = false;
  bool get apiStateError => _apiStateError;

  void setapiStateError(bool value) {
    _apiStateError = value;
    notifyListeners();
  }

  get currentLoviewSpots => _currentLoviewSpots;
  set currentLoviewSpots(newSpots) {
    _currentLoviewSpots = newSpots;
    notifyListeners();
  }

  get currentApiSpots => _currentApiSpots;
  set currentApiSpots(newSpots) {
    _currentApiSpots = newSpots;
    notifyListeners();
  }

  get currentFestivalSpots => _currentFestivalSpots;
  set currentFestivalSpots(newSpots) {
    _currentFestivalSpots = newSpots;
    notifyListeners();
  }

  get representedSpots => _representedSpots;
  set representedSpots(newSpots) {
    _representedSpots = newSpots;
    notifyListeners();
  }

  String _currentState = '전체';

  get currentState {
    if (_currentState == null) {
      _currentState = '전체';
    }
    return _currentState;
  }
  void setCurrentState(state) {
    _currentState = state;
    notifyListeners();
  }

  String _currentCity = '전체';

  get currentCity {
    if (_currentCity == null) {
      _currentCity = '전체';
    }
    return _currentCity;
  }
  void setCurrentCity(city) {
    _currentCity = city;
    notifyListeners();
  }

  Map<String, Spot> _favoritedSpots = <String, Spot>{};

  List<Spot> get favoritedSpots {
    return _favoritedSpots.values.toList();
  }

  int get totalFavoriteCount {
    return _favoritedSpots.length;
  }

  void addSpotToFavorite(String contentId, Spot spot) {
    if (!_favoritedSpots.containsKey(contentId)) {
      _favoritedSpots[contentId] = spot;
    }

    var encoded = json.encode(_favoritedSpots);
    prefs.setString('loview_favorite', encoded);

    notifyListeners();
  }

  void removeSpotToFavorite(String contentId) {
    if (_favoritedSpots.containsKey(contentId)) {
      _favoritedSpots.remove(contentId);
    }

    var encoded = json.encode(_favoritedSpots);
    prefs.setString('loview_favorite', encoded);

    notifyListeners();
  }

  bool checkFavorited(String contentId) {
    return _favoritedSpots.containsKey(contentId);
  }

  void clearFavorite() {
    _favoritedSpots.clear();
    notifyListeners();
  }

  Future updateLoviewSpots() async {
    setBusy(true);

    var responseSpots = List<Spot>();

    try {
      QuerySnapshot document = await _db.collection('loview_spot')
          .getDocuments();
      List<DocumentSnapshot> templist = document.documents;
      List<Map<dynamic, dynamic>> list = templist.map((
          DocumentSnapshot docSnapshot) {
        return docSnapshot.data;
      }).toList();

      for (var spot in list) {
        responseSpots.add(Spot.fromFirestore(spot, spotType.loview));
      }
    } on Exception catch (error) {
      setapiStateError(true);
    }
    _currentLoviewSpots = responseSpots;

    setBusy(false);
    loviewSpotLoaded = true;
  }

  String _getApiSpotsUrl(
      {String stateCode = '', String cityCode = '', int numOfRow = 10000}) {
    return '$apiEndpoint/areaBasedList?'
        'ServiceKey=$serviceKey&'
        'pageNo=1&'
        'numOfRows=$numOfRow&'
        'MobileApp=AppTest&'
        'MobileOS=ETC&'
        'arrange=P&'
        'contentTypeId=12&'
        'areaCode=$stateCode&'
        'sigunguCode=&$cityCode'
        'listYN=Y&'
        '_type=json';
  }

  String _getApiFestivalsUrl(
      {String stateCode = '', String cityCode = '', int numOfRow = 10000}) {
    return '$apiEndpoint/searchFestival?'
        'ServiceKey=$serviceKey&'
        'pageNo=1&'
        'numOfRows=$numOfRow&'
        'MobileApp=AppTest&'
        'MobileOS=ETC&'
        'arrange=P&'
        'contentTypeId=12&'
        'areaCode=$stateCode&'
        'sigunguCode=&$cityCode'
        'listYN=Y&'
        '_type=json&'
        'eventStartDate=20191101';
  }

  Future updateApiSpots() async {
    setBusy(true);

    var responseSpots = List<Spot>();

    try {
      var response = await client.get(_getApiSpotsUrl(
        stateCode: _currentState == '전체' ? '' : _currentState,
        cityCode: _currentCity == '전체' ? '' : _currentCity,
      ));

      var parsed = json.decode(utf8.decode(response.bodyBytes));
      parsed = parsed['response']['body']['items']['item'] as List<dynamic>;

      for (var spot in parsed) {
        responseSpots.add(Spot.fromJson(spot, spotType.apiSpot));
      }
      _currentApiSpots = responseSpots;

      if (currentState == '전체') {
        List<Spot> rpSpot = new List<Spot>();

        List<bool> checkList =
        new List<bool>.filled(40, false, growable: false);
        for (Spot spot in responseSpots) {
          if (!checkList[spot.stateCode]) {
            rpSpot.add(spot);
            checkList[spot.stateCode] = true;
          }

          if (rpSpot.length >= 10) {
            break;
          }
        }

        _representedSpots = rpSpot;
      }
    } on Exception catch (error) {
      setapiStateError(true);
    }

    setBusy(false);
    apiSpotLoaded = true;
    notifyListeners();
  }

  Future updateFestivalSpots() async {
    setBusy(true);

    var responseSpots = List<Spot>();

    try {
      var response = await client.get(_getApiFestivalsUrl(
        stateCode: _currentState == '전체' ? '' : _currentState,
        cityCode: _currentCity == '전체' ? '' : _currentCity,
      ));

      var parsed = json.decode(utf8.decode(response.bodyBytes));
      parsed = parsed['response']['body']['items']['item'] as List<dynamic>;

      for (var spot in parsed) {
        responseSpots.add(Spot.fromJson(spot, spotType.apiSpot));
      }
      _currentFestivalSpots = responseSpots;

    } on Exception catch (error) {
      setapiStateError(true);
    }

    setBusy(false);
    festivalSpotLoaded = true;
    notifyListeners();
  }

  List<Spot> searchSpot() {
    if (_currentState == '전체') {
      return _currentApiSpots;
    }

    List<Spot> temp = _currentApiSpots.where((spot) {
      return spot.stateCode == stateCodes[_currentState];
    }).toList();

    if (_currentCity == '전체') {
      return temp;
    }

    return temp.where((spot) {
      return spot.cityCode == cityCodes[_currentState][_currentCity];
    }).toList() ?? [];
  }

  List<Spot> searchFestivalSpot() {
    if (_currentState == '전체') {
      return _currentFestivalSpots;
    }

    List<Spot> temp = _currentFestivalSpots.where((spot) {
      return spot.stateCode == stateCodes[_currentState];
    }).toList();

    if (_currentCity == '전체') {
      return temp;
    }

    return temp.where((spot) {
      return spot.cityCode == cityCodes[_currentState][_currentCity];
    }).toList();
  }

  List<Spot> searchTermLoview(String term) {
    String trimed = term.trim();

    return trimed.length > 0 ? _currentLoviewSpots.where((spot) {
      return spot.title.toLowerCase().contains(trimed.toLowerCase());
    }).toList() : [];
  }

  List<Spot> searchTermApi(String term) {
    String trimed = term.trim();

    return trimed.length > 0 ? _currentApiSpots.where((spot) {
      return spot.title.toLowerCase().contains(trimed.toLowerCase());
    }).toList() : [];
  }

  List<Spot> searchTermFestival(String term) {
    String trimed = term.trim();

    return trimed.length > 0 ? _currentFestivalSpots.where((spot) {
      return spot.title.toLowerCase().contains(trimed.toLowerCase());
    }).toList() : [];
  }
}
