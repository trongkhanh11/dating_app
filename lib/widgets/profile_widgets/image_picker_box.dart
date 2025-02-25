import 'dart:io';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

class MultiImagePicker extends StatefulWidget {
  final List<String>? imageUrls; // Danh sách URL ảnh từ server

  const MultiImagePicker({super.key, this.imageUrls});

  @override
  _MultiImagePickerState createState() => _MultiImagePickerState();
}

class _MultiImagePickerState extends State<MultiImagePicker> {
  List<dynamic> _images = []; // Chứa cả File (ảnh cục bộ) và String (URL)
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _images = List.generate(6, (index) => null);

    if (widget.imageUrls != null) {
      for (int i = 0; i < widget.imageUrls!.length && i < 6; i++) {
        _images[i] = widget.imageUrls![i]; // Lưu URL trực tiếp
      }
    }
  }

  Future<void> _pickImage(int index, ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        if (!mounted) return;
        setState(() {
          _images[index] = File(pickedFile.path);
        });

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        final userId = authProvider.userModel?.user.id ?? "";

        await profileProvider.uploadPhotos(
            userId, [_images[index] as File], context);
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi chọn ảnh: $e");
    }
  }

  /// Hiển thị Modal để chọn nguồn ảnh (Camera/Gallery)
  void _showImageSourceDialog(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Thêm ảnh",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(index, ImageSource.camera);
              },
              icon: Icon(Icons.camera_alt),
              label: Text("Chụp ảnh"),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(index, ImageSource.gallery);
              },
              icon: Icon(Icons.photo_library),
              label: Text("Chọn từ thư viện"),
            ),
            Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy",
                  style: TextStyle(color: Colors.red, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageSourceDialog(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: _images[index] != null
                  ? _images[index] is File
                      ? DecorationImage(
                          image: FileImage(_images[index] as File),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: NetworkImage(_images[index] as String),
                          fit: BoxFit.cover,
                        )
                  : null,
            ),
            child: _images[index] == null &&
                    (widget.imageUrls == null ||
                        index >= widget.imageUrls!.length)
                ? DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 1.5,
                    dashPattern: [6, 3],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.grey, size: 40),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white, size: 18),
                        onPressed: () => _showImageSourceDialog(index),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
