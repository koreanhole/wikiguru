class NamuWikiHtmlData {
  final String htmlString;
  final String currentUrl;
  final DateTime currentDateTime;

  NamuWikiHtmlData({
    required this.htmlString,
    required this.currentUrl,
    required this.currentDateTime,
  });

  factory NamuWikiHtmlData.fromJson(Map<String, dynamic> json) {
    return NamuWikiHtmlData(
      htmlString: json['htmlString'] as String,
      currentUrl: json['currentUrl'] as String,
      currentDateTime: json['currentDateTime'] as DateTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'htmlString': htmlString,
        'currentUrl': currentUrl,
        'currentDateTime': currentDateTime,
      };
}
