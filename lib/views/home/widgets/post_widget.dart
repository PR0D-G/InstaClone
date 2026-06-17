import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/post_model.dart';
import '../../../viewmodels/home_viewmodel.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../reels/widgets/comment_dialog.dart';

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

        Consumer2<HomeViewModel, AuthViewModel>(
          builder: (context, viewModel, authViewModel, child) {
            final currentUserId = authViewModel.currentUser?.id ?? 'guest';

            return StreamBuilder<DocumentSnapshot>(
              stream: viewModel.getMetadataStream(post.id) as Stream<DocumentSnapshot>,
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
                  stream: viewModel.getCommentsStream(post.id) as Stream<QuerySnapshot>,
                  builder: (context, commentsSnapshot) {
                    int comments = 0;
                    if (commentsSnapshot.hasData) {
                      comments = commentsSnapshot.data!.docs.length;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => viewModel.toggleLike(post.id, currentUserId),
                                child: Icon(
                                  hasLiked ? Icons.favorite : Icons.favorite_border,
                                  color: hasLiked ? Colors.red : Colors.black,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CommentDialog(collection: 'posts', docId: post.id),
                                  );
                                },
                                child: const Icon(Icons.chat_bubble_outline, size: 26),
                              ),
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
                            '$likes likes',
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
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => CommentDialog(collection: 'posts', docId: post.id),
                              );
                            },
                            child: Text(
                              'View all $comments comments',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
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
