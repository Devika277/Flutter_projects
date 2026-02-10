import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../pages/reels_view_page.dart';
import 'dart:io';

class ReelCard extends StatefulWidget {
  final String videoPath;
  final List<String> reels;
  final int index;

  const ReelCard({
    super.key,
    required this.videoPath,
    required this.reels,
    required this.index,
  });

  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  late VideoPlayerController _controller;
  bool isMuted = true;

  @override
  void initState() {
    super.initState();

    _controller = widget.videoPath.startsWith("asset")
      ? VideoPlayerController.asset(widget.videoPath)
      : VideoPlayerController.file(File(widget.videoPath));
  
    _controller.
      initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0); // muted by default
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReelsViewPage(
              reels: widget.reels,
              startIndex: widget.index,
            ),
          ),
        );
      },
      child: Container(
        height: 250,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // VIDEO
              _controller.value.isInitialized
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),

              // AUDIO BUTTON
              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(
                    isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                  ),
                  onPressed: toggleAudio,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
