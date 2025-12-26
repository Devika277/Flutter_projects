import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(String imageUrl) onImagePicked;

  const UserImagePicker({
    super.key,
    required this.onImagePicked,
  });

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  Uint8List? _webImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 150,
    );

    if (pickedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      const cloudName = 'dujwymp5c';
      const uploadPreset = 'unsigned_preset'; // EXACT preset name

      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset;

      if (kIsWeb) {
        // 🌐 WEB
        _webImage = await pickedImage.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            _webImage!,
            filename: 'profile.jpg',
          ),
        );
      } else {
        // 📱 MOBILE
        _pickedImageFile = File(pickedImage.path);

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            _pickedImageFile!.path,
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);

      if (response.statusCode != 200) {
        throw Exception(data['error']['message']);
      }

      widget.onImagePicked(data['secure_url']);
      debugPrint('✅ Uploaded: ${data['secure_url']}');
    } catch (e) {
      debugPrint('❌ Upload failed: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (kIsWeb && _webImage != null) {
      imageProvider = MemoryImage(_webImage!);
    } else if (_pickedImageFile != null) {
      imageProvider = FileImage(_pickedImageFile!);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: imageProvider,
          child: _isUploading
              ? const CircularProgressIndicator(color: Colors.white)
              : imageProvider == null
                  ? const Icon(Icons.person, size: 40, color: Colors.white)
                  : null,
        ),
        TextButton.icon(
          onPressed: _isUploading ? null : _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add image'),
        ),
      ],
    );
  }
}