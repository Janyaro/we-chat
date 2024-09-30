import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/models/ChatModel.dart';
import 'package:we_chat/screens/screen/view_user_profile.dart';

class ProfileDialog extends StatelessWidget {
  final ChatModel user;
  const ProfileDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: media.height * 0.45,
        width: media.height * 0.4,
        child: Stack(
          children: [
            Positioned(
              left: media.width * 0.001,
              top: media.height * 0.002,
              width: media.width * 0.55,
              child: Text(
                user.name.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: media.height * 0.07,
              left: media.width * 0.03,
              child: ClipOval(
                child: CachedNetworkImage(
                  width: media.width * 0.6,
                  fit: BoxFit.fill,
                  imageUrl: user.image.toString(),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            Positioned(
                right: media.width * 0.001,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  viewUserProfile(user: user)));
                    },
                    icon: const Icon(
                      Icons.info,
                      size: 25,
                      color: Colors.blue,
                    )))
          ],
        ),
      ),
    );
  }
}
