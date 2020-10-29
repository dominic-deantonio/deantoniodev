import 'package:flutter/material.dart';

class Util {
  static String plural(int i, String single, String plural) {
    String result;
    i != 1 ? result = plural : result = single;
    return result;
  }

  static List<DropdownMenuItem<T>> createDropdownMenuItems<T>(List<T> items) {
    //https://api.flutter.dev/flutter/package-collection_collection/DelegatingList/map.html

    return items.map<DropdownMenuItem<T>>((T value) {
      return DropdownMenuItem<T>(
        value: value,
        child: Text(
          value.toString(),
          textAlign: TextAlign.left,
        ),
      );
    }).toList();
  }

  static List<Text> createDropdownDisplayItem(List<String> items) {
    //https://github.com/flutter/flutter/issues/9211#issuecomment-532806508
    List<Text> out = List<Text>();
    items.forEach((element) => out.add(Text(element)));
    return out;
  }

  static Future waitMilliseconds(int milliseconds) => Future.delayed(
        Duration(milliseconds: milliseconds),
      );

  static String conditionalComma(bool condition) {
    if (condition) {
      return ',';
    } else {
      return '';
    }
  }

//  static String getHowLongAgo(DateTime olderDate) {
//    DateTime now = DateTime.now();
//    Duration diff = now.difference(olderDate);
//    int t = diff.inMinutes;
//    int h = diff.inHours;
//    int d = diff.inDays;
//    String day = DateFormat('EEEE').format(olderDate);
//    String out = 'Error';
//
//    if (t < 1) {
//      out = 'now';
//    } else if (t >= 1 && t < 60) {
//      out = '${t}m ago';
//    } else if (h >= 1 && h < 24) {
//      out = '${h}h ago';
//    } else if (d >= 1 && d < 2) {
//      out = 'Yesterday';
//    } else if (d >= 2 && d < 7) {
//      out = day;
//    } else if (d >= 7) {
//      out = DateFormat('d MMM yy').format(olderDate).toString();
//    } else {
//      out = 'Error :(';
//    }
//
//    return out;
//  }

  static int getPercent(var a, var b) => (a / b * 100).round();

  //The most commonly traded
  static const List<String> currencySymbols = ['\$', '\€', '\¥', '\£'];
}
