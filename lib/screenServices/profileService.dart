import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/Utility/mysnakbar.dart';
import 'package:we_chat/api/Api.dart';

class profileService with ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  String? image;

  String? get getimage => image;
  // select the image from the gallery
  Future<void> galleryPicker(BuildContext context) async {
    final XFile? galleryimage =
        await picker.pickImage(source: ImageSource.gallery);
    if (galleryimage != null) {
      image = galleryimage.path;
      notifyListeners();
      Api.uploadProfilePic(File(image!));
      Navigator.pop(context);
      if (kDebugMode) {}
    } else {
      // ignore: use_build_context_synchronously
      Utility().mySnackbar(context, 'Image is not select from the gallery');
    }
  }

// select the image from the camera
  Future<void> cameraPicker(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? cameraimage =
        await picker.pickImage(source: ImageSource.camera);
    if (cameraimage != null) {
      image = cameraimage.path;
      notifyListeners();
      Api.uploadProfilePic(File(image!));
      Navigator.pop(context);
      if (kDebugMode) {
        print('image is selected from the camera');
      }
    } else {
      // ignore: use_build_context_synchronously
      Utility().mySnackbar(context, 'camera image is not selected');
    }
  }

  // bottomBar code
  void onBottomSheet(BuildContext context) {
    final media = MediaQuery.of(context).size;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: media.height * .03,
            bottom: media.height * .05,
          ),
          children: [
            const Text(
              textAlign: TextAlign.center,
              'Pick Profile Picture',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: media.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(media.width * .3, media.height * .15),
                  ),
                  onPressed: () async {
                    galleryPicker(context);
                    notifyListeners();
                  },
                  child: Image.asset('asset/chooseImage.png'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(media.width * .3, media.height * .15),
                  ),
                  onPressed: () async {
                    cameraPicker(context);
                    notifyListeners();
                  },
                  child: Image.asset('asset/camera.png'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
