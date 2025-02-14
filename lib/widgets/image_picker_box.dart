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

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
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
          onTap: () => _pickImage(index), // Chọn ảnh
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: _images[index] != null
                  ? DecorationImage(image: FileImage(_images[index]!), fit: BoxFit.cover)
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
                              child: Icon(Icons.add, color: Colors.white, size: 18),
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
                        onPressed: () => _pickImage(index),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
