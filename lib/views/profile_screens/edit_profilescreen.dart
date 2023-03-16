import 'dart:io';

import 'package:ecomm_seller/const/const.dart';
import 'package:ecomm_seller/controllers/profile_controller.dart';
import 'package:ecomm_seller/views/widgets/custom_textfield.dart';
import 'package:ecomm_seller/views/widgets/loading_indicator.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../widgets/text_style.dart';

class EditProfileScreen extends StatefulWidget {
  final String? userName;
  const EditProfileScreen({super.key, this.userName});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.nameController.text = widget.userName!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isLoading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isLoading(true);

                      // if image is not selected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }

                      // if old pass matches database
                      if (controller.snapshotData['password'] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                            email: controller.snapshotData['email'],
                            password: controller.oldpassController.text,
                            newpassword: controller.newpassController.text);
                        await controller.updateProfile(
                          imgUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.newpassController.text,
                        );

                        // ignore: use_build_context_synchronously
                        VxToast.show(context, msg: "Profile Updated");
                      } else if (controller
                              .oldpassController.text.isEmptyOrNull &&
                          controller.newpassController.text.isEmptyOrNull) {
                        await controller.updateProfile(
                          imgUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.snapshotData['password'],
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        VxToast.show(context, msg: "some error occured");
                        controller.isLoading(false);
                      }
                    },
                    child: normalText(text: save)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              controller.snapshotData['imageUrl'] == '' &&
                      controller.profileImgPath.isEmpty
                  ? Image.asset(
                      imgProduct,
                      width: 100,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make()
                  // if data is not empty but controller path is empty
                  : controller.snapshotData['imageUrl'] != '' &&
                          controller.profileImgPath.isEmpty
                      ? Image.network(
                          controller.snapshotData['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      // if both are empty
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              // Image.asset(
              //   imgProduct,
              //   width: 150,
              // ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: white),
                onPressed: () {
                  controller.changeImage(context);
                },
                child: normalText(text: changeImage, color: fontGrey),
              ),
              10.heightBox,
              const Divider(
                color: white,
              ),
              10.heightBox,
              customTextfield(
                  label: name,
                  hint: "eg: Tushar",
                  controller: controller.nameController),
              30.heightBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: boldText(text: "Change your password")),
              10.heightBox,
              customTextfield(
                  label: password,
                  hint: passwordHint,
                  controller: controller.oldpassController),
              10.heightBox,
              customTextfield(
                  label: confirmPass,
                  hint: passwordHint,
                  controller: controller.newpassController),
            ],
          ),
        ),
      ),
    );
  }
}
