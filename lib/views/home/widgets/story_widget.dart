import 'package:flutter/material.dart';
import '../../../models/story_model.dart';

class StoryWidget extends StatelessWidget {
  final StoryModel story;

  const StoryWidget({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: story.isViewed
                  ? const LinearGradient(
                      colors: [Colors.grey, Colors.grey],
                    )
                  : const LinearGradient(
                      colors: [
                        Color(0xFFFBAA47),
                        Color(0xFFD91A46),
                        Color(0xFFA60F93),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(story.avatarUrl),
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            story.username,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
