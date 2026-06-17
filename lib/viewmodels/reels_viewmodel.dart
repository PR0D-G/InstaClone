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


    final decoded = json.decode(_jsonData) as Map<String, dynamic>;
    final categories = decoded['categories'] as List<dynamic>;
    if (categories.isNotEmpty) {
      final videos = categories[0]['videos'] as List<dynamic>;
      _reels = videos.map((v) => ReelModel.fromJson(v)).toList();
    }
    
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

  static const String _jsonData = '''
{
  "categories": [
    {
      "name": "Movies",
      "videos": [
        {
          "description": "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\\n\\nLicensed under the Creative Commons Attribution license\\nhttp://www.bigbuckbunny.org",
          "sources": [
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
          ],
          "subtitle": "By Blender Foundation",
          "thumb": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg",
          "title": "Big Buck Bunny"
        },
        {
          "description": "The first Blender Open Movie from 2006",
          "sources": [
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
          ],
          "subtitle": "By Blender Foundation",
          "thumb": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg",
          "title": "Elephant Dream"
        },
        {
          "description": "HBO GO now works with Chromecast -- the easiest way to enjoy online video on your TV. For when you want to settle into your Iron Throne to watch the latest episodes. For \$35.\\nLearn how to use Chromecast with HBO GO and more at google.com/chromecast.",
          "sources": [
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
          ],
          "subtitle": "By Google",
          "thumb": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg",
          "title": "For Bigger Blazes"
        },
        {
          "description": "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when Batman's escapes aren't quite big enough. For \$35. Learn how to use Chromecast with Google Play Movies and more at google.com/chromecast.",
          "sources": [
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
          ],
          "subtitle": "By Google",
          "thumb": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg",
          "title": "For Bigger Escape"
        },
        {
          "description": "Introducing Chromecast. The easiest way to enjoy online video and music on your TV. For \$35.  Find out more at google.com/chromecast.",
          "sources": [
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"
          ],
          "subtitle": "By Google",
          "thumb": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerFun.jpg",
          "title": "For Bigger Fun"
        }
      ]
    }
  ]
}''';
}
