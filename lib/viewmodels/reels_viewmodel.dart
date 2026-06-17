import 'package:flutter/foundation.dart';
import '../models/reel_model.dart';
import '../repositories/social_repository.dart';

class ReelsViewModel extends ChangeNotifier {
  List<ReelModel> _reels = [];
  final SocialRepository _socialRepo = SocialRepository();

  List<ReelModel> get reels => _reels;

  ReelsViewModel() {
    _loadData();
  }

  void _loadData() {
    // Use local video assets mapped to firestore IDs
    _reels = List.generate(5, (index) {
      final vIndex = index + 1;
      return ReelModel(
        id: 'reel_$vIndex',
        videoUrl: 'assets/video/video_$vIndex.mp4',
        likes: 0,
        likedBy: [],
      );
    });
    
    notifyListeners();
  }

  Future<void> toggleLike(String reelId, String currentUserId) async {
    await _socialRepo.toggleLike(
      collection: 'reels',
      docId: reelId,
      currentUserId: currentUserId,
    );
  }

  Future<void> addComment(String reelId, String text, String currentUserId) async {
    await _socialRepo.addComment(
      collection: 'reels',
      docId: reelId,
      text: text,
      currentUserId: currentUserId,
    );
  }

  Stream getMetadataStream(String reelId) {
    return _socialRepo.getMetadataStream('reels', reelId);
  }

  Stream getCommentsStream(String reelId) {
    return _socialRepo.getCommentsStream('reels', reelId);
  }
}
