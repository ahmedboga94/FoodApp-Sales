import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodappsales/mainscreen/home_screen.dart';
import 'package:foodappsales/global/global.dart';
import 'package:foodappsales/model/seller_model.dart';
import 'package:foodappsales/widgets/custom_button.dart';
import 'package:foodappsales/widgets/custom_text_field.dart';
import 'package:foodappsales/widgets/error_dialog.dart';
import 'package:foodappsales/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  void _formValidation() {
    if (emailCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty) {
      signinUserWithEmail();
    } else {
      showDialog(
          context: context,
          builder: (c) => const ErrorDialog(
              message: "Please write the complete required Info"));
    }
  }

  void signinUserWithEmail() async {
    showDialog(
        context: context,
        builder: (c) => const LoadingDialog(message: "Login to Your Account"));

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailCtrl.text.trim(), password: passwordCtrl.text.trim())
          .then((auth) {
        _readAndSetDataLocally(auth.user!);
      }).catchError((onError) {
        Navigator.pop(context);

        showDialog(
            context: context,
            builder: (c) => ErrorDialog(message: onError.message.toString()));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _readAndSetDataLocally(User user) async {
    final navigator = Navigator.of(context);
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(user.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        final sellerModel =
            SellerModel.fromJson(snapshot.data() as Map<String, dynamic>);
        if (sellerModel.status == "approved") {
          await sharedPreferences!.setString("uid", sellerModel.sellerUID);
          await sharedPreferences!.setString("name", sellerModel.sellerName);
          await sharedPreferences!.setString("email", sellerModel.sellerEmail);
          await sharedPreferences!
              .setString("photoURL", sellerModel.sellerPhotoURL);
          navigator.pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (c) => const ErrorDialog(
                  message:
                      "You are blocked from Admin \n Contact on: admin@gmail.com"));
          FirebaseAuth.instance.signOut();
        }
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) => const ErrorDialog(
                message: "You don't have permission to login"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 275,
              width: 275,
              child: Image.asset("assets/images/seller.png"),
            ),
            CustomTextField(
                controller: emailCtrl,
                iconData: Icons.email,
                hintText: "Enter Your E-Mail"),
            CustomTextField(
                controller: passwordCtrl,
                iconData: Icons.password,
                hintText: "Enter Your Password",
                isObsecure: true),
            const SizedBox(height: 25),
            CustomButton(
              onPressed: () => _formValidation(),
              text: "Sign In",
              color: Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }
}
