import 'package:flutter/material.dart';

final stateCodes = {
  '전체': 0,
  '서울': 1,
  '인천': 2,
  '대전': 3,
  '대구': 4,
  '광주': 5,
  '부산': 6,
  '울산': 7,
  '세종특별자치시': 8,
  '경기도': 31,
  '강원도': 32,
  '충청북도': 33,
  '충청남도': 34,
  '경상북도': 35,
  '경상남도': 36,
  '전라북도': 37,
  '전라남도': 38,
  '제주도': 39,
};

final stateNames = {
  0: '전체',
  1: '서울',
  2: '인천',
  3: '대전',
  4: '대구',
  5: '광주',
  6: '부산',
  7: '울산',
  8: '세종특별자치시',
  31: '경기도',
  32: '강원도',
  33: '충청북도',
  34: '충청남도',
  35: '경상북도',
  36: '경상남도',
  37: '전라북도',
  38: '전라남도',
  39: '제주도',
};

final cityCodes = {
  '전체': {
    '전체': 0,
  },
  '서울': {
    '전체': 0,
  },
  '인천': {
    '전체': 0,
  },
  '대전': {
    '전체': 0,
  },
  '대구': {
    '전체': 0,
  },
  '광주': {
    '전체': 0,
  },
  '부산': {
    '전체': 0,
  },
  '울산': {
    '전체': 0,
  },
  '세종특별자치시': {
    '전체': 0,
  },
  '경기도': {
    '전체': 0,
    '가평군': 1,
    '고양시': 2,
    '과천시': 3,
    '광명시': 4,
    '광주시': 5,
    '구리시': 6,
    '군포시': 7,
    '김포시': 8,
    '남양주시': 9,
    '동두천시': 10,
    '부천시': 11,
    '성남시': 12,
    '수원시': 13,
    '시흥시': 14,
    '안산시': 15,
    '안성시': 16,
    '안양시': 17,
    '양주시': 18,
    '양평군': 19,
    '여주시': 20,
    '연천군': 21,
    '오산시': 22,
    '용인시': 23,
    '의왕시': 24,
    '의정부시': 25,
    '이천시': 26,
    '파주시': 27,
    '평택시': 28,
    '포천시': 29,
    '하남시': 30,
    '화성시': 31,
  },
  '강원도': {
    '전체': 0,
    '강릉시': 1,
    '고성군': 2,
    '동해시': 3,
    '삼청시': 4,
    '속초시': 5,
    '양구군': 6,
    '양야군': 7,
    '영월군': 8,
    '원주시': 9,
    '인제군': 10,
    '정선군': 11,
    '철원군': 12,
    '춘천시': 13,
    '태백시': 14,
    '평창군': 15,
    '홍천군': 16,
    '화천군': 17,
    '횡성군': 18,
  },
  '충청북도': {
    '전체': 0,
    '괴산군': 1,
    '단양군': 2,
    '보은군': 3,
    '영동군': 4,
    '옥천군': 5,
    '음성군': 6,
    '제천시': 7,
    '진천군': 8,
    '청원군': 9,
    '청주시': 10,
    '충주시': 11,
    '증편군': 12,
  },
  '충청남도': {
    '전체': 0,
    '공주시': 1,
    '금산군': 2,
    '논산시': 3,
    '당진시': 4,
    '보령시': 5,
    '부여군': 6,
    '서산시': 7,
    '서천군': 8,
    '아산시': 9,
    '예산군': 11,
    '천안시': 12,
    '청양군': 13,
    '태안군': 14,
    '홍성군': 15,
    '계룡시': 16,
  },
  '경상북도': {
    '전체': 0,
    '경산시': 1,
    '경주시': 2,
    '고령군': 3,
    '구미시': 4,
    '군위군': 5,
    '김천시': 6,
    '문경시': 7,
    '봉화군': 8,
    '상주시': 9,
    '성주군': 10,
    '안동시': 11,
    '영덕군': 12,
    '영양군': 13,
    '영주시': 14,
    '영천시': 15,
    '예천군': 16,
    '울릉군': 17,
    '울진군': 18,
    '의성군': 19,
    '청도군': 20,
    '청송군': 21,
    '칠곡군': 22,
    '포항시': 23,
  },
  '경상남도': {
    '전체': 0,
    '거제시': 1,
    '거창군': 2,
    '고성군': 3,
    '김해시': 4,
    '남해군': 5,
    '마산시': 6,
    '밀양시': 7,
    '사천시': 8,
    '산청군': 9,
    '양산시': 10,
    '의령군': 12,
    '진주시': 13,
    '진해시': 14,
    '창녕군': 15,
    '창원시': 16,
    '통영시': 17,
    '하동군': 18,
    '함안군': 19,
    '함양군': 20,
    '합천군': 21,
  },
  '전라북도': {
    '전체': 0,
    '고창군': 1,
    '군산시': 2,
    '김제시': 3,
    '남원시': 4,
    '무주군': 5,
    '부안군': 6,
    '순창군': 7,
    '완주군': 8,
    '익산시': 9,
    '임실군': 10,
    '장수군': 11,
    '전주시': 12,
    '정읍시': 13,
    '진안군': 14,
  },
  '전라남도': {
    '전체': 0,
    '강진군': 1,
    '고흥군': 2,
    '곡성군': 3,
    '광양시': 4,
    '구례군': 5,
    '나주시': 6,
    '담양군': 7,
    '목포시': 8,
    '무안군': 9,
    '보성군': 10,
    '순천시': 11,
    '신안군': 12,
    '여수시': 13,
    '영광군': 16,
    '영암군': 17,
    '완도군': 18,
    '장성군': 19,
    '장흥군': 20,
    '진도군': 21,
    '함평군': 22,
    '해남군': 23,
    '화순군': 24,
  },
  '제주도': {
    '전체': 0,
  },
};

enum spotType {
  loview,
  apiSpot,
  apiFestival,
}

List<DropdownMenuItem<String>> getDropDownStates() {
  List<DropdownMenuItem<String>> items = new List();
  for (String city in stateCodes.keys.toList()) {
    // here we are creating the drop down menu items, you can customize the item right here
    // but I'll just use a simple text for this
    items.add(new DropdownMenuItem(
      value: city,
      child: new Text(
        city == '전체' ? '전체' : city,
        style: TextStyle(
          color: Color.fromARGB(255, 97, 0, 237),
          fontSize: 20,
          letterSpacing: 1.247,
          fontFamily: "Roboto",
        ),
        textAlign: TextAlign.center,
      ),
    ));
  }
  return items;
}

List<DropdownMenuItem<String>> getDropDownCities(String state) {
  List<DropdownMenuItem<String>> items = new List();
  for (String city in cityCodes[state].keys.toList()) {
    // here we are creating the drop down menu items, you can customize the item right here
    // but I'll just use a simple text for this
    items.add(new DropdownMenuItem(
      value: city,
      child: new Text(
        city,
        style: TextStyle(
          color: Color.fromARGB(255, 97, 0, 237),
          fontSize: 20,
          letterSpacing: 1.247,
          fontFamily: "Roboto",
        ),
        textAlign: TextAlign.center,
      ),
    ));
  }
  return items;
}

final serviceKey =
    'np4eQg%2BEsDuLFH3wpqSMjng4q8QiOU%2F94lmVD7yVbsqkR4EpSnMRz9GY0sdeijuZBr24rBnPjyFJ0bll2PkQIA%3D%3D';
final apiEndpoint =
    'http://api.visitkorea.or.kr/openapi/service/rest/KorService';

final admobAppId = 'ca-app-pub-1761120770090270~9374867307';
final bannerId = 'ca-app-pub-1761120770090270/5216130445';

final testId = 'ff11ca23896189d0';