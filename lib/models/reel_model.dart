class ReelModel {
  final String id;
  final String videoUrl;
  final int likes;
  final List<String> likedBy;

  ReelModel({
    required this.id,
    required this.videoUrl,
    required this.likes,
    required this.likedBy,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String? ?? '',
      likes: json['likes'] as int? ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }
}
