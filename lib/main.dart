import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterfirecourse/business_logic/cubits/add_post/add_post_cubit.dart';
import 'package:flutterfirecourse/business_logic/cubits/chatting/chatting_cubit.dart';
import 'package:flutterfirecourse/business_logic/cubits/comments/comments_cubit.dart';
import 'package:flutterfirecourse/business_logic/cubits/posts/posts_cubit.dart';
import 'package:flutterfirecourse/business_logic/cubits/register/register_cubit.dart';
import 'package:flutterfirecourse/business_logic/cubits/users/users_cubit.dart';
import 'package:flutterfirecourse/data/local/my_shared.dart';
import 'package:flutterfirecourse/ui/map/map_screen.dart';
import 'package:flutterfirecourse/ui/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'business_logic/cubits/login/login_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyShared.init();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await flutterNotification
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(DevicePreview(
    enabled: false,
    builder: (context) => MyApp(),
  ));
}

var flutterNotification = FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  "id",
  "name",
  description: "desc",
  importance: Importance.high,
  playSound: true,
);

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => RegisterCubit()),
          BlocProvider(create: (context) => AddPostCubit()),
          BlocProvider(create: (context) => PostsCubit()),
          BlocProvider(create: (context) => CommentsCubit()),
          BlocProvider(create: (context) => UsersCubit()),
          BlocProvider(create: (context) => ChattingCubit()),
        ],
        child: MaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            focusColor: Colors.white,
            textTheme: const TextTheme(
                bodyText1: TextStyle(
              color: Colors.white,
              fontSize: 16,
            )),
            primarySwatch: Colors.blue,
          ),
          home: ResponsiveSizer(
            builder: (p0, p1, p2) => MapScreen(),
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) => print(value));

    FirebaseMessaging.onMessage.listen((event) {
      print('listen => ');
      print('listen => ${event.notification!.title}');
      print('listen => ${event.notification!.body}');
      print('listen => ${event.notification!.android}');
      print('listen => ${event.notification!.apple}');

      if (event.notification != null && event.notification!.android != null) {
        flutterNotification.show(
          event.notification.hashCode,
          event.notification?.title,
          event.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }
}
