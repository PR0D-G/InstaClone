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
    _stories = List.generate(10, (index) {
      final imgIndex = (index % 10) + 1;
      final storyImgIndex = ((index + 5) % 10) + 1;
      return StoryModel(
        id: 'story_$index',
        username: 'user_${index + 1}',
        avatarUrl: 'assets/imgs/image-$imgIndex.jpg',
        imageUrl: 'assets/imgs/image-$storyImgIndex.jpg',
        isViewed: index > 2,
      );
    });

    _posts = List.generate(10, (index) {
      final imgIndex = (index % 10) + 1;
      final avatarIndex = ((index + 3) % 10) + 1;
      return PostModel(
        id: 'post_$index',
        username: 'photographer_$index',
        userAvatarUrl: 'assets/imgs/image-$avatarIndex.jpg',
        imageUrl: 'assets/imgs/image-$imgIndex.jpg',
        likes: (index + 1) * 42,
        caption: 'This is a beautiful shot for post #$index! #nature #photography',
        commentCount: (index + 1) * 5,
        timestamp: '${index + 1} HOURS AGO',
      );
    });

    notifyListeners();
  }
}
