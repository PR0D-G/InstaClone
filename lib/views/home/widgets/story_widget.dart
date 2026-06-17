import 'package:flutter/material.dart';
import '../../../models/story_model.dart';
import '../story_view_screen.dart';

class StoryWidget extends StatelessWidget {
  final StoryModel story;

  const StoryWidget({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryViewScreen(story: story),
          ),
        );
      },
      child: Padding(
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
                        Colors.blue,
                        Colors.lightBlueAccent,
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
                backgroundImage: AssetImage(story.avatarUrl),
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
    ),
    );
  }
}

class YourStoryWidget extends StatelessWidget {
  const YourStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: const AssetImage('assets/imgs/image-10.jpg'),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Your Story',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
