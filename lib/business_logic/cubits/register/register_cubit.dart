import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterfirecourse/data/models/user.dart';
import 'package:meta/meta.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());
  late String username;
  late String email;
  late String phone;
  late File imageFile;
  late String imageUrl;

  void register({
    required String username,
    required String email,
    required String password,
    required String phone,
    required File imageFile,
  }) async {
    this.username = username;
    this.email = email;
    this.phone = phone;
    this.imageFile = imageFile;

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        //emit(RegisterSuccessState());
        _uploadImage();
      },
    ).catchError(
      (error) {
        if (error is FirebaseAuthException && error.code == 'weak-password') {
          emit(RegisterFailureState("The password provided is too weak."));
        } else if (error is FirebaseAuthException &&
            error.code == 'email-already-in-use') {
          emit(RegisterFailureState(
              "The account already exists for that email."));
        } else {
          emit(RegisterFailureState(error.toString()));
        }
      },
    );
  }

  void _uploadImage() async {
    try {
      await FirebaseStorage.instance
          // .ref('uploads/file-to-upload.png')
          .ref('profileImages/${FirebaseAuth.instance.currentUser!.uid}')
          .putFile(imageFile);

      _getImageUrl();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      emit(RegisterFailureState(e.toString()));
    }
  }

  void _getImageUrl() async {
    imageUrl = await FirebaseStorage.instance
        .ref('profileImages/${FirebaseAuth.instance.currentUser!.uid}')
        .getDownloadURL();

    _insertUserData();
  }

  void _insertUserData() {
    MyUser user = MyUser(
      username: username,
      email: email,
      phone: phone,
      profileImageUrl: imageUrl,
    );

    print(user.toJson());

    FirebaseFirestore.instance
        .collection("flutterUsers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(user.toJson())
        .then((value) {
      emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterFailureState(error.toString()));
    });
  }
}
