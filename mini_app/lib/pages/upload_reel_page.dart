import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadReelPage extends StatefulWidget {
  const UploadReelPage({super.key});

  @override
  State<UploadReelPage> createState() => _UploadReelPageState();
}

class _UploadReelPageState extends State<UploadReelPage> {
  File? videoFile;
  VideoPlayerController? controller;
  bool isUploading = false;

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);

    if (picked != null) {
      videoFile = File(picked.path);
      controller = VideoPlayerController.file(videoFile!)
        ..initialize().then((_) {
          controller!.setLooping(true);
          controller!.play();
          setState(() {});
        });
    }
  }

  Future<void> uploadVideo() async {
    if (videoFile == null) return;

    setState(() => isUploading = true);

    final fileName =
        'reels/${DateTime.now().millisecondsSinceEpoch}.mp4';

    try {
      await Supabase.instance.client.storage
          .from('videos') // bucket name
          .upload(fileName, videoFile!);

      final publicUrl = Supabase.instance.client.storage
          .from('videos')
          .getPublicUrl(fileName);

      // Save URL to Postgres
      await Supabase.instance.client.from('reels').insert({
        'video_url': publicUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload successful")),
      );

      Navigator.pop(context, publicUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload failed")),
      );
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Reel")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// PICK VIDEO
            if (videoFile == null)
              ElevatedButton.icon(
                onPressed: pickVideo,
                icon: const Icon(Icons.video_library),
                label: const Text("Pick Video"),
              ),

            /// VIDEO PREVIEW + UPLOAD
            if (videoFile != null) ...[
              AspectRatio(
                aspectRatio: controller!.value.aspectRatio,
                child: VideoPlayer(controller!),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.4,
                child: ElevatedButton(
                  onPressed: isUploading ? null : uploadVideo,
                  child: isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Upload Reel"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
