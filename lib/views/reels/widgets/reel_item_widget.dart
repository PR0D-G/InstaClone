import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../models/reel_model.dart';
import '../../../viewmodels/reels_viewmodel.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment_dialog.dart';

class ReelItemWidget extends StatefulWidget {
  final ReelModel reel;
  final bool isFocused;

  const ReelItemWidget({super.key, required this.reel, required this.isFocused});

  @override
  State<ReelItemWidget> createState() => _ReelItemWidgetState();
}

class _ReelItemWidgetState extends State<ReelItemWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFocused) {
      _initVideo();
    }
  }

  @override
  void didUpdateWidget(covariant ReelItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFocused && !oldWidget.isFocused) {
      if (_controller == null) {
        _initVideo();
      } else {
        _controller?.play();
        _isPlaying = true;
      }
    } else if (!widget.isFocused && oldWidget.isFocused) {
      _controller?.pause();
      _isPlaying = false;
    }
  }

  void _initVideo() {
    _controller = VideoPlayerController.asset(widget.reel.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller?.setLooping(true);
          if (widget.isFocused) {
            _controller?.play();
          }
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  void _showComments() {
    showDialog(
      context: context,
      builder: (context) => CommentDialog(collection: 'reels', docId: widget.reel.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

        GestureDetector(
          onTap: _togglePlay,
          child: _hasError
              ? const Center(child: Icon(Icons.error, color: Colors.red, size: 50))
              : (_controller?.value.isInitialized ?? false)
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : Container(
                      color: Colors.black,
                      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
        ),


        if (!_isPlaying)
          const Center(
            child: Icon(Icons.play_arrow, color: Colors.white54, size: 80),
          ),


        Positioned(
          bottom: 20,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@user_${widget.reel.id.split('_').last}',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Check out this local asset reel! #local #flutter',
                style: TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Original Audio',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),


        Positioned(
          bottom: 20,
          right: 8,
          child: Consumer2<ReelsViewModel, AuthViewModel>(
            builder: (context, viewModel, authViewModel, child) {
              final currentUserId = authViewModel.currentUser?.id ?? 'guest';

              return StreamBuilder<DocumentSnapshot>(
                stream: viewModel.getMetadataStream(widget.reel.id) as Stream<DocumentSnapshot>,
                builder: (context, metaSnapshot) {
                  int likes = 0;
                  bool hasLiked = false;

                  if (metaSnapshot.hasData && metaSnapshot.data!.exists) {
                    final data = metaSnapshot.data!.data() as Map<String, dynamic>;
                    likes = data['likes'] ?? 0;
                    final likedBy = List<String>.from(data['likedBy'] ?? []);
                    hasLiked = likedBy.contains(currentUserId);
                  }

                  return StreamBuilder<QuerySnapshot>(
                    stream: viewModel.getCommentsStream(widget.reel.id) as Stream<QuerySnapshot>,
                    builder: (context, commentsSnapshot) {
                      int comments = 0;
                      if (commentsSnapshot.hasData) {
                        comments = commentsSnapshot.data!.docs.length;
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildAction(
                            icon: hasLiked ? Icons.favorite : Icons.favorite_border,
                            color: hasLiked ? Colors.red : Colors.white,
                            label: likes.toString(),
                            onTap: () => viewModel.toggleLike(widget.reel.id, currentUserId),
                          ),
                          const SizedBox(height: 16),
                          _buildAction(
                            icon: Icons.chat_bubble_outline,
                            color: Colors.white,
                            label: comments.toString(),
                            onTap: _showComments,
                          ),
                          const SizedBox(height: 16),
                          _buildAction(
                            icon: Icons.send_outlined,
                            color: Colors.white,
                            label: 'Share',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Shared!')),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Icon(Icons.more_vert, color: Colors.white, size: 30),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAction({required IconData icon, required String label, required VoidCallback onTap, Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
