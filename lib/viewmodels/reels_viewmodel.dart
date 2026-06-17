import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reel_model.dart';

class ReelsViewModel extends ChangeNotifier {
  List<ReelModel> _reels = [];
  Map<String, int> _likes = {};
  Map<String, List<String>> _comments = {};

  List<ReelModel> get reels => _reels;

  ReelsViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    

    final likesStr = prefs.getString('reels_likes');
    if (likesStr != null) {
      _likes = Map<String, int>.from(json.decode(likesStr));
    }


    final commentsStr = prefs.getString('reels_comments');
    if (commentsStr != null) {
      final decoded = json.decode(commentsStr) as Map<String, dynamic>;
      _comments = decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
    }


    // Use local video assets
    _reels = List.generate(5, (index) {
      final vIndex = index + 1;
      return ReelModel(
        title: 'Local Reel $vIndex',
        subtitle: 'By InstaClone',
        description: 'Enjoying this cool local video from the assets folder! #video #local',
        thumbUrl: 'assets/imgs/image-$vIndex.jpg',
        videoUrl: 'assets/video/video_$vIndex.mp4',
      );
    });
    
    notifyListeners();
  }

  int getLikes(String videoUrl) {
    return _likes[videoUrl] ?? 0;
  }

  void toggleLike(String videoUrl) async {
    final currentLikes = getLikes(videoUrl);
    _likes[videoUrl] = currentLikes + 1;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reels_likes', json.encode(_likes));
  }

  List<String> getComments(String videoUrl) {
    return _comments[videoUrl] ?? [];
  }

  void addComment(String videoUrl, String comment) async {
    final current = getComments(videoUrl);
    current.add(comment);
    _comments[videoUrl] = current;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reels_comments', json.encode(_comments));
  }
}
