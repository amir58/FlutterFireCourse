import 'package:flutter/material.dart';
import 'package:flutterfirecourse/ui/compnents.dart';
import 'package:flutterfirecourse/ui/login_screen.dart';


class ShopRegisterScreen extends StatefulWidget {
  ShopRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ShopRegisterScreen> createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {

  var userNameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var phoneController = TextEditingController();

  bool isPasswordVisable = false;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),backgroundColor: Colors.white,
        elevation: 0,),
      body: Form(
        key: formKey,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 22),
          //margin: EdgeInsets.only(bottom: 60),
          child: ListView(
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center
            children: [
              Text(
                "REGISTER",
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Register now to browse our hot 🔥 offers",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500]),
              ),
              SizedBox(
                height: 18,
              ),
              myshopTextFormField(
                label: "User Name",
                validator: (value) {
                  if(value!.isEmpty)
                    return "required";
                },
                controller: userNameController,
                prefixIcon: Icons.person,
              ),
              SizedBox(
                height: 16,
              ),
              myshopTextFormField(
                  label: "ُEmail Address",
                  validator: (value) { if(value!.isEmpty)
                    return "required";},
                  controller: emailController,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress),
              SizedBox(
                height: 16,
              ),
              myshopTextFormField(
                  label: "Password",
                  validator: (value) {  if(value!.isEmpty)
                    return "required";},
                  controller: passwordController,
                  prefixIcon: Icons.lock,
                  obscureText: isPasswordVisable,
                  suffixIcon: myiconwidg()
              ),
              SizedBox(
                height: 16,
              ),
              myshopTextFormField(
                label: "Phone",
                validator: (value) { if(value!.isEmpty)
                  return "required";},
                controller: phoneController,
                prefixIcon: Icons.phone,keyboardType: TextInputType.phone
              ),
              SizedBox(
                height: 32,
              ),
              myshopButtonWidget(
                texts: "REGISTER",
                onPressed: () {
                  if(formKey.currentState!.validate()){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShopLoginScreen(),));
                    userNameController.text="";
                    phoneController.text="";
                    passwordController.text="";
                    emailController.text="";
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myiconwidg() {return InkWell(
      onTap: () {
        isPasswordVisable = !isPasswordVisable;
        setState(() {});
      },
      child: isPasswordVisable
          ? Icon(Icons.visibility_off)
          : Icon(Icons.visibility));}
}
