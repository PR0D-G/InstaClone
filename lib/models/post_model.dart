class PostModel {
  final String id;
  final String username;
  final String userAvatarUrl;
  final String imageUrl;
  final int likes;
  final List<String> likedBy;
  final String caption;
  final int commentCount;
  final String timestamp;

  PostModel({
    required this.id,
    required this.username,
    required this.userAvatarUrl,
    required this.imageUrl,
    required this.likes,
    required this.likedBy,
    required this.caption,
    required this.commentCount,
    required this.timestamp,
  });
}
