class Postmodel {
  final String title;
  final String source;
  final String urlToImage;

  Postmodel({
    required this.title,
    required this.source,
    required this.urlToImage,
  });

  factory Postmodel.fromJson(Map<String, dynamic> json) {
    return Postmodel(
      title: json['title'] ?? 'No Title',
      source: json['source']?['name'] ?? 'Unknown Source',
      urlToImage: json['urlToImage'] ?? '',
    );
  }
}
