class ReelModel {
  final String title;
  final String subtitle;
  final String description;
  final String thumbUrl;
  final String videoUrl;

  ReelModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.thumbUrl,
    required this.videoUrl,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      thumbUrl: json['thumb'] as String? ?? '',
      videoUrl: (json['sources'] as List<dynamic>?)?.first as String? ?? '',
    );
  }
}
