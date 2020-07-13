import 'package:loview/constants/constants.dart';

import 'dart:convert';

class Spot {
  int stateCode;
  int cityCode;
  String id;
  bool isFeatured;
  String title;
  String desc;
  String addr;
  List<String> images;
  String video;
  spotType type;
  DateTime startDate;
  DateTime endDate;
  String tell;
  String blog;

  Spot({
    this.stateCode,
    this.cityCode,
    this.id,
    this.isFeatured,
    this.title,
    this.addr,
    this.images,
    this.type,
    this.video,
    this.desc,
    this.startDate,
    this.endDate,
    this.tell,
    this.blog,
  });

  Spot.fromJson(Map<String, dynamic> json, spotType type) {
    var responsedImages = List<String>();
    if (json['images'] != null) {
      responsedImages.add(json['images'][0]);
    }
    if (json['firstimage'] != null) {
      responsedImages.add(json['firstimage']);
    }
    if (json['firstimage2'] != null) {
      responsedImages.add(json['firstimage2']);
    }
    if (responsedImages.length == 0) {
      responsedImages.add('https://firebasestorage.googleapis.com/v0/b/favorable-kiln-259504.appspot.com/o/loview_contents%2Floview_recom.jpg?alt=media&token=3fc15d70-41b9-466e-ade5-3aace49dd459');
    }

    var savedType;
    if (json['type'] != null) {
      switch (json['type']) {
        case 0:
          savedType = spotType.loview;
          break;
        case 1:
          savedType = spotType.apiSpot;
          break;
        case 2:
          savedType = spotType.apiFestival;
          break;
      }
    }

    stateCode = json['areacode'] ?? stateCodes['전체'];
    cityCode = json['sigungucode'] ?? cityCodes['전체']['전체'];
    id = json['contentid'] != null ? json['contentid'].toString() : json['id'] != null ? json['id'] : '';
    isFeatured = false;
    title = json['title'] ?? '';
    desc = '';
    addr = json['addr1'] ?? json['addr'] ?? '';
    images = responsedImages;
    video = '';
    startDate = json['eventstartdate'] != null ? DateTime.parse(json['eventstartdate'].toString()) : null;
    endDate = json['eventenddate'] != null ? DateTime.parse(json['eventenddate'].toString()) : null;
    tell = json['tel'].toString() ?? '';
    this.type = json['type'] != null ? savedType : type;
  }

  Spot.fromFirestore(Map<String, dynamic> map, spotType type) {
    var responsedImages = List<String>();
    for (var image in map['images']) {
      responsedImages.add(image);
    }
    stateCode = map['stateCode'] ?? stateCodes['전체'];
    cityCode = map['cityCode'] == stateCodes['전체'] ?
    map['cityCode'] : cityCodes['전체']['전체'] ?? cityCodes['전체']['전체'];
    id = map['id'] ?? '';
    isFeatured = false;
    title = map['title'] ?? '';
    desc = map['desc'] ?? '';
    addr = map['addr'] ?? '';
    images = responsedImages ?? [];
    video = map['video'];
    blog = map['blog'];
    tell = null.toString();
    this.type = type;
  }

  Map<String, dynamic> toJson() {
    int type = this.type == spotType.loview ? 0 : this.type == spotType.apiSpot ? 1 : 2;
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stateCode'] = this.stateCode;
    data['cityCode'] = this.cityCode;
    data['id'] = this.id;
    data['isFeatured'] = this.isFeatured;
    data['title'] = this.title;
    data['addr'] = this.addr;
    data['images'] = this.images;
    data['type'] = this.type;
    data['video'] = this.video;
    data['desc'] = this.desc;
    data['tel'] = this.tell;
    data['type'] = type;
    return data;
  }

  String toString() {
    return json.encode(toJson());
  }
}
