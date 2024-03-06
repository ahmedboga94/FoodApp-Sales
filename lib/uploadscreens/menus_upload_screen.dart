import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodappsales/global/global.dart';
import 'package:foodappsales/mainscreen/home_screen.dart';
import 'package:foodappsales/model/menu_model.dart';
import 'package:foodappsales/widgets/custom_button.dart';
import 'package:foodappsales/widgets/custom_text_field.dart';
import 'package:foodappsales/widgets/error_dialog.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/progress_bar.dart';

class MenusUploadScreen extends StatefulWidget {
  static const String id = "menusUploadScreen";
  const MenusUploadScreen({super.key});

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool uploadingImage = false;

  TextEditingController menuTitleContriller = TextEditingController();
  TextEditingController menuInfoContriller = TextEditingController();

  _takeImage() {
    return showDialog(
        context: context,
        builder: (builder) {
          return SimpleDialog(
            title:
                const Text("Menu Image", style: TextStyle(color: Colors.amber)),
            children: [
              SimpleDialogOption(
                  child: const Text("Capture with Camera",
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () => _imageFromCamera()),
              SimpleDialogOption(
                  child: const Text("Select from Gallery",
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () => _imageFromGallery()),
              SimpleDialogOption(
                  child: const Center(
                      child: Text("Cancel",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  onPressed: () => Navigator.pop(context)),
            ],
          );
        });
  }

  _imageFromCamera() async {
    Navigator.pop(context);
    imageXFile = await _imagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 720, maxWidth: 1280);
    setState(() {
      imageXFile;
    });
  }

  _imageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 720, maxWidth: 1280);

    setState(() {
      imageXFile;
    });
  }

  _validateFormAndUpload() async {
    final navigator = Navigator.of(context);
    if (imageXFile != null) {
      if (menuTitleContriller.text.isNotEmpty &&
          menuInfoContriller.text.isNotEmpty) {
        setState(() {
          uploadingImage = true;
        });
        // upload Image
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        Reference reference =
            FirebaseStorage.instance.ref().child("menus").child(fileName);
        UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String menuImageURL = await taskSnapshot.ref.getDownloadURL();

        saveToFirebase(fileName, menuImageURL);

        setState(() {
          uploadingImage = false;
        });

        navigator.pushReplacementNamed(HomeScreen.id);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                  message: "Please complete Menu Information");
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(message: "Please pic an image");
          });
    }
  }

  saveToFirebase(nameID, imageURL) async {
    final CollectionReference menuCollection = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus");

    final menuModel = MenuModel(
        menuID: nameID,
        sellerUID: sharedPreferences!.getString("uid").toString(),
        menuImageURL: imageURL,
        menuTitle: menuTitleContriller.text,
        menuInfo: menuInfoContriller.text,
        publishedData: Timestamp.now(),
        status: "available");

    await menuCollection.doc(nameID).set(menuModel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
          ))),
          title: const Text("Add New Menu",
              style: TextStyle(fontFamily: "Lobster", fontSize: 35)),
          centerTitle: true),
      body: WillPopScope(
        onWillPop: () async {
          if (imageXFile == null) {
            return true;
          } else {
            return await showDialog(
                  context: context,
                  builder: (context) => WillPopScope(
                    onWillPop: () async => true,
                    child: AlertDialog(
                      title: const Text(
                          "Are you sure to get back and lose your entary data?"),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(HomeScreen.id);
                              },
                              child: const Text("OK")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel",
                                  style: TextStyle(color: Colors.cyan)))
                        ],
                      ),
                    ),
                  ),
                ) ??
                false;
          }
        },
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
          )),
          child: imageXFile == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shop_two,
                          color: Colors.white, size: 200),
                      ElevatedButton(
                        onPressed: () => _takeImage(),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.amber),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)))),
                        child: const Text("Add New Menu"),
                      )
                    ],
                  ),
                )
              : ListView(
                  children: [
                    uploadingImage == true
                        ? const LinearProgress()
                        : const SizedBox(height: 16),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                            height: 230,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Center(
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: FileImage(
                                                    File(imageXFile!.path)),
                                                fit: BoxFit.cover))))))),
                    CustomTextField(
                        iconData: Icons.title,
                        hintText: "Menu Title",
                        controller: menuTitleContriller),
                    CustomTextField(
                        iconData: Icons.perm_device_info,
                        hintText: "Menu Info",
                        controller: menuInfoContriller),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 66),
                      child: CustomButton(
                          onPressed: uploadingImage
                              ? null
                              : () => _validateFormAndUpload(),
                          text: "Add Menu",
                          color: Colors.cyan),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
