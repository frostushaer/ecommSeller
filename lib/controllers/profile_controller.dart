import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../const/const.dart';

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;
  var profileImgPath = ''.obs;
  var profileImageLink = '';
  var isLoading = false.obs;
  // textfields
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  //shop controller
  var shopNameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopWebsiteController = TextEditingController();
  var shopDescController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set({
      'vendor_name': name,
      'password': password,
      'imageUrl': imgUrl,
    }, SetOptions(merge: true));
    isLoading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      // print(error.toString());
    });
  }

  updateShop({shopName, shopAddress, shopMobile, shopWebsite, shopDesc}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set({
      'shop_name': shopName,
      'shop_address': shopAddress,
      'shop_mobile': shopMobile,
      'shop_website': shopWebsite,
      'shop_desc': shopDesc
    }, SetOptions(merge: true));
    isLoading(false);
  }
}
