import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class MultiImagePicker extends StatefulWidget {
  @override
  _MultiImagePickerState createState() => _MultiImagePickerState();
}

class _MultiImagePickerState extends State<MultiImagePicker> {
  List<File?> _images = List.generate(6, (index) => null); // Danh sách 6 ảnh
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Để hòa vào nền
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height, // Chiếm toàn bộ chiều cao
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Add Photos/Videos",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Chụp ảnh
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
                    Icon(Icons.camera_alt,
                        color: Colors.white, size: 28),
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

            // Chọn từ thư viện
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

            // Nút hủy
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy",
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
      shrinkWrap: true, // Để tránh lỗi khi đặt trong Column
      physics: NeverScrollableScrollPhysics(), // Không scroll riêng lẻ
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 cột
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1, // Ô vuông
      ),
      itemCount: 6, // Tổng cộng 6 ô
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageSourceDialog(index), // Chọn ảnh hoặc chụp ảnh
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: _images[index] != null
                  ? DecorationImage(
                      image: FileImage(_images[index]!), fit: BoxFit.cover)
                  : null,
            ),
            child: _images[index] == null
                ? DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 1.5,
                    dashPattern: [6, 3], // Độ dài nét đứt
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
