import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import 'widgets/story_widget.dart';
import 'widgets/post_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Instagram',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Segoe UI',
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.stories.length,
                        itemBuilder: (context, index) {
                          return StoryWidget(story: viewModel.stories[index]);
                        },
                      ),
                    ),
                    const Divider(height: 1, color: Colors.grey),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return PostWidget(post: viewModel.posts[index]);
                  },
                  childCount: viewModel.posts.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
