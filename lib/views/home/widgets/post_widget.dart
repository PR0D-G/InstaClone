import 'package:flutter/material.dart';
import '../../../models/post_model.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(post.userAvatarUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const Icon(Icons.more_vert),
            ],
          ),
        ),

        AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: Colors.grey[200],
            child: Image.asset(
              post.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Row(
            children: [
              const Icon(Icons.favorite_border, size: 28),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline, size: 26),
              const SizedBox(width: 16),
              const Icon(Icons.send_outlined, size: 26),
              const Spacer(),
              const Icon(Icons.bookmark_border, size: 28),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            '${post.likes} likes',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 13),
              children: [
                TextSpan(
                  text: '${post.username} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: post.caption),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'View all ${post.commentCount} comments',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Text(
            post.timestamp,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
