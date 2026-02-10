import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
import '../pages/full_reel.dart';

class ReelsViewPage extends StatefulWidget {
  final List<String> reels;
  final int startIndex;

  const ReelsViewPage({
    super.key,
    required this.reels,
    required this.startIndex,
  });

  @override
  State<ReelsViewPage> createState() => _ReelsViewPageState();
}

class _ReelsViewPageState extends State<ReelsViewPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.startIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.reels.length,
        itemBuilder: (context, index) {
          return FullReel(videoPath: widget.reels[index]);
        },
      ),
    );
  }
}
