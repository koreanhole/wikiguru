class NamuWikiOutline {
  final String href;
  final String label;
  final int depth;

  NamuWikiOutline({
    required this.href,
    required this.label,
    required this.depth,
  });

  factory NamuWikiOutline.fromJson(Map<String, dynamic> json) {
    return NamuWikiOutline(
      href: json['href'] as String,
      label: json['label'] as String,
      depth: json['depth'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'href': href,
        'label': label,
        'depth': depth,
      };
}
