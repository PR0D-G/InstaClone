class StoryModel {
  final String id;
  final String username;
  final String avatarUrl;
  final String imageUrl;
  final bool isViewed;

  StoryModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.imageUrl,
    this.isViewed = false,
  });
}
