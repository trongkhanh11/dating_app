import 'dart:io';

import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

class MultiImagePicker extends StatefulWidget {
  final List? imageUrls;
  const MultiImagePicker({super.key, this.imageUrls});

  @override
  _MultiImagePickerState createState() => _MultiImagePickerState();
}

class _MultiImagePickerState extends State<MultiImagePicker> {
  final List<File?> _images =
      List.generate(6, (index) => null); // Danh sách 6 ảnh
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Nếu imageUrl được truyền vào, bạn sẽ gán nó vào danh sách _images
    if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) {
      for (int i = 0; i < widget.imageUrls!.length && i < 6; i++) {
        _images[i] = File(widget.imageUrls![i]);
      }
    }
  }
  //final profileProvider = Provider.o // Khởi tạo APIProvider của bạn

  Future<void> _pickImage(int index, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final userId = authProvider.userModel?.user.id ?? "";
    await profileProvider.uploadPhotos(userId, _images, context);
  }

  void _showImageSourceDialog(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text(
              "Add Photos/Videos",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _pickImage(index, ImageSource.camera);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Text(
                      "Take a selfie photo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _pickImage(index, ImageSource.gallery);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_library, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Text(
                      "Choose from gallery",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",
                  style: TextStyle(color: Colors.red, fontSize: 18)),
            ),
            SizedBox(height: 10),
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
                  ? DecorationImage(
                      image: _images[index]!.path.startsWith('http')
                          ? NetworkImage(
                              _images[index]!.path) // Nếu là URL từ server
                          : FileImage(File(_images[index]!.path))
                              as ImageProvider, // Nếu là file cục bộ
                      fit: BoxFit.cover)
                  : null,
            ),
            child: _images[index] == null
                ? DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 1.5,
                    dashPattern: [6, 3],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.add,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
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
