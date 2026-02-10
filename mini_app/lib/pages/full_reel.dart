import 'package:flutter/material.dart';
// import  '../pages/reels_view_page.dart';
// import '../widgets/reel_card.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';


class FullReel extends StatefulWidget {
  final String videoPath;
  const FullReel({super.key, required this.videoPath});

  @override
  State<FullReel> createState() => _FullReelState();
}

class _FullReelState extends State<FullReel> {
  late VideoPlayerController _controller;
  bool isMuted = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPath.startsWith("asset")
      ? VideoPlayerController.asset(widget.videoPath)
      : VideoPlayerController.file(File(widget.videoPath));
  
    _controller.initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0); // muted initially
        _controller.play();
        setState(() {});
      });
  }

  void toggleAudio() {
    setState(() {
      isMuted = !isMuted;
      _controller.setVolume(isMuted ? 0 : 1);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // VIDEO
        Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),

        // BACK BUTTON
        Positioned(
          top: 40,
          left: 15,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        // AUDIO BUTTON
        Positioned(
          bottom: 30,
          right: 20,
          child: IconButton(
            iconSize: 30,
            icon: Icon(
              isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: toggleAudio,
          ),
        ),
      ],
    );
  }
}
