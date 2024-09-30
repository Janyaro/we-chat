import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/Utility/mysnakbar.dart';
import 'package:we_chat/api/Api.dart';
import 'package:we_chat/models/ChatModel.dart';
import 'package:we_chat/screenServices/profileService.dart';
import 'package:we_chat/screens/auth/screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? image;
  final _formkey = GlobalKey<FormState>();
  profileService service = profileService();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text('Profile Screen'),
          centerTitle: true,
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: media.width,
                    height: media.height * 0.01,
                  ),
                  Stack(
                    children: [
                      service.getimage != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(media.height * .1),
                              child: ClipOval(
                                child: Image.file(
                                  File(service.getimage!),
                                  width: media.width * 0.5,
                                  height: media.height * 0.3,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(media.height * .1),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  width: media.width * 0.5,
                                  height: media.height * 0.3,
                                  fit: BoxFit.fill,
                                  imageUrl: widget.user.image.toString(),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    child: Icon(CupertinoIcons.person),
                                  ),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            service.onBottomSheet(context);
                          },
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: const Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: media.width,
                    height: media.height * 0.01,
                  ),
                  Text(
                    widget.user.email.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: media.width,
                    height: media.height * .03,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(media.height * 0.012),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: 'janyaro',
                        label: const Text('Name'),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onSaved: (value) => Api.me.name = value ?? '',
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: media.width,
                    height: media.height * .02,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(media.height * 0.012),
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        hintText: 'feeling happy',
                        label: const Text('about'),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onSaved: (value) => Api.me.about = value ?? '',
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: media.width,
                    height: media.height * .02,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const StadiumBorder(),
                        minimumSize:
                            Size(media.width * 0.4, media.height * 0.07)),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        Api.ChangeUserInfo().then((value) {
                          Utility().mySnackbar(
                              context, 'User info is successfully Changed');
                        }).onError((error, stackTrace) {
                          Utility().mySnackbar(context, error.toString());
                        });
                        if (kDebugMode) {
                          print('main ne pakar liya hai data ');
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Container(
          width: 120,
          height: 45,
          decoration: const BoxDecoration(),
          child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                await Api.updateActiveStatus(false);
                await Api.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    Navigator.pop(context);
                    Api.auth = FirebaseAuth.instance;
                    // Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  });
                });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: const Text(
                'LogOut',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }
}
