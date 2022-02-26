import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfirecourse/business_logic/cubits/users/users_cubit.dart';
import 'package:flutterfirecourse/data/models/user.dart';
import 'package:flutterfirecourse/ui/chatting_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late UsersCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<UsersCubit>(context);
    cubit.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit, UsersStates>(
      buildWhen: (previous, current) => current is GetUsersSuccessState,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Chats"),
          ),
          body: ListView.builder(
            itemCount: cubit.users.length,
            itemBuilder: (context, index) => buildChatItem(index),
          ),
        );
      },
    );
  }

  Widget buildChatItem(int index) {
    MyUser user = cubit.users[index];

    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChattingScreen(user: user),
          )),
      child: Container(
        margin: EdgeInsets.all(15.sp),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 26,
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
                  backgroundImage: NetworkImage(user.profileImageUrl),
                  radius: 23,
                ),
              ],
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                user.username,
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
    );
  }
}
