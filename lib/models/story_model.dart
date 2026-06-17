class StoryModel {
  final String id;
  final String username;
  final String avatarUrl;
  final bool isViewed;

  StoryModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    this.isViewed = false,
  });
}
