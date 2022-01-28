import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterfirecourse/ui/compnents.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PostScreen extends StatelessWidget {
  final File imageFile;

  const PostScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "New Post",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(50.sp),
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 15.sp),
              child: Text(
                "Share",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 18.sp),
              ),
            ),
          )
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15.sp),
              width: 30.w,
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              )),
          Expanded(
            child: TextFormField(
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              decoration: InputDecoration(
                  hintText: "Write a caption.",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp)),
            ),
          )
        ],
      ),
    );
  }
}
