import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodappsales/mainscreen/home_screen.dart';
import 'package:foodappsales/global/global.dart';
import 'package:foodappsales/model/seller_model.dart';
import 'package:foodappsales/widgets/custom_button.dart';
import 'package:foodappsales/widgets/custom_text_field.dart';
import 'package:foodappsales/widgets/error_dialog.dart';
import 'package:foodappsales/widgets/loading_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();

  String sellerImageURL = "";
  String completeAddress = "";

  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController confirmPasswordCtrl = TextEditingController();
  TextEditingController shopAddressCtrl = TextEditingController();

  Position? position;
  List<Placemark>? placeMakers;

  void _getImage() async {
    imageXFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  _getCurrentLocation() async {
    Position newPostion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    position = newPostion;
    placeMakers = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMakers![0];
    completeAddress =
        "${pMark.thoroughfare}, ${pMark.locality}, ${pMark.administrativeArea}, ${pMark.country}";
    shopAddressCtrl.text = completeAddress;
  }

  Future<void> _formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) => const ErrorDialog(message: "Please select an Image"));
    } else {
      if (passwordCtrl.text == confirmPasswordCtrl.text) {
        if (userNameCtrl.text.isNotEmpty &&
            emailCtrl.text.isNotEmpty &&
            phoneCtrl.text.isNotEmpty &&
            passwordCtrl.text.isNotEmpty &&
            confirmPasswordCtrl.text.isNotEmpty &&
            shopAddressCtrl.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) =>
                  const LoadingDialog(message: "Registering Your Account"));
          autanticateSellerAndSignUp();
        } else {
          showDialog(
              context: context,
              builder: (c) => const ErrorDialog(
                  message: "Please write the complete required Info"));
        }
      } else {
        showDialog(
            context: context,
            builder: (c) => const ErrorDialog(message: "Password don't match"));
      }
    }
  }

  void autanticateSellerAndSignUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailCtrl.text.trim(), password: passwordCtrl.text.trim())
          .then((auth) {
        saveUserDataToFirestore(auth.user!).then((value) =>
            Navigator.of(context).pushReplacementNamed(HomeScreen.id));
      }).catchError((onError) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (c) => ErrorDialog(message: onError.message.toString()));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future saveUserDataToFirestore(User currentUser) async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child("sellers").child(fileName);
    UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    sellerImageURL = await taskSnapshot.ref.getDownloadURL();

    final sellerModel = SellerModel(
        status: "approved",
        sellerName: userNameCtrl.text.trim(),
        sellerEmail: currentUser.email.toString(),
        sellerPhone: phoneCtrl.text.trim(),
        sellerUID: currentUser.uid,
        sellerPhotoURL: sellerImageURL,
        sellerAddress: shopAddressCtrl.text.trim(),
        latitude: position!.latitude,
        longitude: position!.longitude,
        earning: 0.0);

    FirebaseFirestore.instance
        .collection("sellers")
        .doc(currentUser.uid)
        .set(sellerModel.toJson());
    //save data locally
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("name", userNameCtrl.text.trim());
    await sharedPreferences!.setString("email", currentUser.email!);
    await sharedPreferences!.setString("photoURL", sellerImageURL);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () => _getImage(),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.19,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null
                      ? null
                      : FileImage(File(imageXFile!.path)),
                  child: imageXFile == null
                      ? Icon(Icons.add_a_photo,
                          size: MediaQuery.of(context).size.width * 0.19,
                          color: Colors.grey)
                      : null,
                )),
            CustomTextField(
                controller: userNameCtrl,
                iconData: Icons.person,
                hintText: "Enter Your Name"),
            CustomTextField(
                controller: emailCtrl,
                iconData: Icons.email,
                hintText: "Enter Your E-Mail"),
            CustomTextField(
                controller: phoneCtrl,
                iconData: Icons.phone,
                hintText: "Enter Your Phone"),
            CustomTextField(
                controller: passwordCtrl,
                iconData: Icons.password,
                hintText: "Enter Your Password",
                isObsecure: true),
            CustomTextField(
                controller: confirmPasswordCtrl,
                iconData: Icons.password,
                hintText: "Confim Your Password",
                isObsecure: true),
            CustomTextField(
                controller: shopAddressCtrl,
                iconData: Icons.my_location,
                hintText: "Enter Your Shop Address",
                enable: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: CustomButton(
                  onPressed: () => _getCurrentLocation(),
                  text: "Get my current Location",
                  icon: true,
                  color: Colors.amber),
            ),
            const SizedBox(height: 25),
            CustomButton(
              onPressed: () => _formValidation(),
              text: "Sign Up",
              color: Colors.cyan,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
