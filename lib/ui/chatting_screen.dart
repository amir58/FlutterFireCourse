import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfirecourse/business_logic/cubits/chatting/chatting_cubit.dart';
import 'package:flutterfirecourse/data/models/message.dart';
import 'package:flutterfirecourse/data/models/user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChattingScreen extends StatefulWidget {
  final MyUser user;

  const ChattingScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  late ChattingCubit cubit;

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ChattingCubit>(context);
    cubit.getMessages(widget.user.userId);

    cubit.listenToMessages(widget.user.userId);
  }

  @override
  void dispose() {
    super.dispose();
    cubit.messages.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChattingCubit, ChattingStates>(
      listener: (context, state) {
        if (state is SendMessageSuccessState) {}
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            Color(0xff833ab4),
                            Color(0xfffd1d1d),
                            Color(0xfffcb045),
                          ])),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.profileImageUrl),
                    radius: 18,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.user.username,
                  // "Amir Mohammed",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            buildChattingListView(),
            buildMessageTextFromFiled(),
          ],
        ),
      ),
    );
  }

  Widget buildChattingListView() {
    return Expanded(
      child: BlocBuilder<ChattingCubit, ChattingStates>(
        buildWhen: (previous, current) => current is GetMessagesSuccessState,
        builder: (context, state) {
          return ListView.builder(
            itemCount: cubit.messages.length,
            itemBuilder: (context, index) {
              Message message = cubit.messages[index];

              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return buildSenderMessage(message.message);
              } else {
                return buildReceiverMessage(message.message);
              }
            },
          );
        },
      ),
    );
  }

  Widget buildSenderMessage(String message) {
    return Container(
      margin:
          EdgeInsets.only(top: 10.sp, bottom: 10.sp, right: 15.sp, left: 25.w),
      padding: EdgeInsets.symmetric(
        vertical: 15.sp,
        horizontal: 10.sp,
      ),
      width: double.infinity,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.sp),
          topRight: Radius.circular(15.sp),
          bottomLeft: Radius.circular(15.sp),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget buildReceiverMessage(String message) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.sp,
        bottom: 10.sp,
        right: 25.w,
        left: 15.sp,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 15.sp,
        horizontal: 10.sp,
      ),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.sp),
          topRight: Radius.circular(15.sp),
          bottomRight: Radius.circular(15.sp),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget buildMessageTextFromFiled() {
    return Container(
      margin: EdgeInsets.all(15.sp),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: messageController,
              style: TextStyle(color: Colors.black, fontSize: 17.sp),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Write your message",
                hintStyle: TextStyle(color: Colors.black, fontSize: 17.sp),
              ),
            ),
          ),
          IconButton(
              onPressed: () => sendMessage(),
              icon: Icon(
                Icons.send,
                color: Colors.blue[200],
                size: 22.sp,
              ))
        ],
      ),
    );
  }

  void sendMessage() {
    String messageContent = messageController.text;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String time = DateTime.now().toString();

    Message message = Message(
      messageId: time + userId,
      senderId: userId,
      reciverId: widget.user.userId,
      message: messageContent,
      time: time,
    );

    cubit.sendMessage(message);
    messageController.clear();
  }
}
