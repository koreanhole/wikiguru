import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wikiguru/base/data/namu_wiki_outline.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';

class WebViewProvider with ChangeNotifier {
  List<NamuWikiOutline>? _namuWikiOutlines;

  List<NamuWikiOutline> get namuWikiOutlines =>
      _namuWikiOutlines ?? List.empty();

  void setNamuWikiOutlines() async {
    _namuWikiOutlines = null;
    notifyListeners();
    // Delay for page fully loaded -> 대문 페이지 갔을 때 이전 페이지의 목차가 보일때 있음
    await Future.delayed(Duration(milliseconds: 500));
    final resultString =
        await WikiGuruWebViewController().webViewController?.evaluateJavascript(
      source: r'''
        (function() {
          var results = [];
          document.querySelectorAll('a[id^="s-"]').forEach(function(aTag) {
            if (/^s-(\d+(\.\d+)*)$/.test(aTag.id)) {
              var numberPart = aTag.id.slice(2);
              var depth = numberPart.split('.').length - 1;
              var nextElem = aTag.nextElementSibling;
              if (nextElem && nextElem.tagName.toLowerCase() === 'span' && nextElem.id) {
                results.push({
                  href: aTag.id,
                  label: nextElem.id,
                  depth: depth
                });
              }
            }
          });
          return JSON.stringify(results);
        })()
      ''',
    ) as String;
    final List<dynamic> jsonList = jsonDecode(resultString);
    _namuWikiOutlines =
        jsonList.map((item) => NamuWikiOutline.fromJson(item)).toList();
    notifyListeners();
  }
}
