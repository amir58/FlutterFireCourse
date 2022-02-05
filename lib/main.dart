import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfirecourse/business_logic/cubits/add_post/add_post_cubit.dart';
import 'package:flutterfirecourse/business_logic/cubits/register/register_cubit.dart';
import 'package:flutterfirecourse/ui/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'business_logic/cubits/login/login_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(DevicePreview(
    enabled: false,
    builder: (context) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => RegisterCubit()),
          BlocProvider(create: (context) => AddPostCubit()),
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
            builder: (p0, p1, p2) => ShopLoginScreen(),
          ),
        ));
  }
}
