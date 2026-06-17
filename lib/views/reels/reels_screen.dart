import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/reels_viewmodel.dart';
import 'widgets/reel_item_widget.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<ReelsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.reels.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: viewModel.reels.length,
            itemBuilder: (context, index) {
              return ReelItemWidget(reel: viewModel.reels[index]);
            },
          );
        },
      ),
    );
  }
}
