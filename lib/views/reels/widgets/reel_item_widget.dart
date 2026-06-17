import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../models/reel_model.dart';
import '../../../viewmodels/reels_viewmodel.dart';
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
      builder: (context) => CommentDialog(videoUrl: widget.reel.videoUrl),
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
                widget.reel.title,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.reel.description,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    widget.reel.subtitle,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),


        Positioned(
          bottom: 20,
          right: 8,
          child: Consumer<ReelsViewModel>(
            builder: (context, viewModel, child) {
              final likes = viewModel.getLikes(widget.reel.videoUrl);
              final comments = viewModel.getComments(widget.reel.videoUrl).length;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildAction(
                    icon: Icons.favorite,
                    label: likes.toString(),
                    onTap: () => viewModel.toggleLike(widget.reel.videoUrl),
                  ),
                  const SizedBox(height: 16),
                  _buildAction(
                    icon: Icons.chat_bubble_outline,
                    label: comments.toString(),
                    onTap: _showComments,
                  ),
                  const SizedBox(height: 16),
                  _buildAction(
                    icon: Icons.send_outlined,
                    label: 'Share',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Shared!')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Icon(Icons.more_vert, color: Colors.white, size: 30),
                  const SizedBox(height: 16),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        widget.reel.thumbUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAction({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 35),
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
