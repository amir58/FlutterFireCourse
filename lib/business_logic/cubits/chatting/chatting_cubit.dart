import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfirecourse/data/models/message.dart';
import 'package:meta/meta.dart';

part 'chatting_state.dart';

class ChattingCubit extends Cubit<ChattingStates> {
  ChattingCubit() : super(ChattingInitialState());

  List<Message> messages = [];

  void sendMessage(Message message) async {
    await FirebaseFirestore.instance
        .collection("flutterUsers")
        .doc(message.senderId)
        .collection("chats")
        .doc(message.reciverId)
        .collection("messages")
        .doc(message.messageId)
        .set(message.toJson());

    await FirebaseFirestore.instance
        .collection("flutterUsers")
        .doc(message.reciverId)
        .collection("chats")
        .doc(message.senderId)
        .collection("messages")
        .doc(message.messageId)
        .set(message.toJson());

    emit(SendMessageSuccessState());
  }

  void getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection("flutterUsers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .get()
        .then((value) {
      messages.clear();

      for (var element in value.docs) {
        Message message = Message.fromJson(element.data());
        messages.add(message);
      }
      emit(GetMessagesSuccessState());
    });
  }

  void listenToMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection("flutterUsers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("time")
        .limitToLast(1)
        .snapshots()
        .listen((event) {
      // messages.clear();

      print('Docs => ${event.docs.length}');

      Message message = Message.fromJson(event.docs[0].data());
      messages.add(message);

      emit(GetMessagesSuccessState());
    });
  }
}
