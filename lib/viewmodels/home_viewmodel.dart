import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<StoryModel> _stories = [];
  List<PostModel> _posts = [];

  List<StoryModel> get stories => _stories;
  List<PostModel> get posts => _posts;

  HomeViewModel() {
    _loadDummyData();
  }

  void _loadDummyData() {
    // Generate 10 dummy stories
    _stories = List.generate(10, (index) {
      return StoryModel(
        id: 'story_$index',
        username: 'user_${index + 1}',
        avatarUrl: 'https://picsum.photos/seed/avatar_$index/150/150',
        isViewed: index > 2, // First 3 are unviewed
      );
    });

    // Generate 10 dummy posts
    _posts = List.generate(10, (index) {
      return PostModel(
        id: 'post_$index',
        username: 'photographer_$index',
        userAvatarUrl: 'https://picsum.photos/seed/post_avatar_$index/150/150',
        imageUrl: 'https://picsum.photos/seed/post_img_$index/800/800',
        likes: (index + 1) * 42,
        caption: 'This is a beautiful shot for post #$index! #nature #photography',
        commentCount: (index + 1) * 5,
        timestamp: '${index + 1} HOURS AGO',
      );
    });

    notifyListeners();
  }
}
