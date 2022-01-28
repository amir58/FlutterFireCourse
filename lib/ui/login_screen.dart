

import 'package:flutter/material.dart';
import 'package:flutterfirecourse/ui/compnents.dart';
import 'package:flutterfirecourse/ui/home_screen.dart';
import 'package:flutterfirecourse/ui/register_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class ShopLoginScreen extends StatefulWidget {
   const ShopLoginScreen({Key? key}) : super(key: key);

  @override
  _ShopLoginScreenState createState() => _ShopLoginScreenState();
}

class _ShopLoginScreenState extends State<ShopLoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  bool isPasswordVisable = false;

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          alignment: Alignment.center,
          padding:  EdgeInsets.symmetric(horizontal: 20.sp),
          //margin: EdgeInsets.only(bottom: 60),
          child: ListView(
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center
            children: [
               Text(
                "LOGIN",
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
              ),
               SizedBox(
                height: 15.sp,
              ),
              Text(
                "Login now to browse our hot 🔥 offers",
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500]),
              ),
              SizedBox(
                height: 25.sp,
              ),
              myshopTextFormField(
                  label: "ُEmail Address",
                  validator: (value) { if(value!.isEmpty) {
                    return "required";
                  }},
                  controller: emailController,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress),
               SizedBox(
                height: 16.sp,
              ),
              myshopTextFormField(
                  label: "Password",
                  validator: (value) {  if(value!.isEmpty) {
                    return "required";
                  }},
                  controller: passwordController,
                  prefixIcon: Icons.lock,
                  obscureText: isPasswordVisable,
                  suffixIcon: myIconWidget()
              ),
               SizedBox(
                height: 26.sp,
              ),
              myshopButtonWidget(
                texts: "LOGIN",
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));

                  if(formKey.currentState!.validate()){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));

                    passwordController.text="";
                    emailController.text="";

                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Don't have an account ? "  ,style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  ),),TextButton(onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => ShopRegisterScreen(),));
                  }, child:  Text("REGISTER"  ,style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
                ),))],)
            ],
          ),
        ),
      ),
    );
  }

  Widget myIconWidget() {return InkWell(
      onTap: () {
        isPasswordVisable = !isPasswordVisable;
        setState(() {});
      },
      child: isPasswordVisable
          ?  Icon(Icons.visibility_off, size: 22.sp,)
          :  Icon(Icons.visibility, size: 22.sp,));}
}
