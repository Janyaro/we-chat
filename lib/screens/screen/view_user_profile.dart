
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/date_time_utils.dart';
import 'package:we_chat/models/ChatModel.dart';
// ignore: camel_case_types
class viewUserProfile extends StatefulWidget {
  final ChatModel user;
  const viewUserProfile({super.key, required this.user});

  @override
  State<viewUserProfile> createState() => _viewUserProfileState();
}

class _viewUserProfileState extends State<viewUserProfile> {
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: media.width,
                  height: media.height * 0.01,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(media.height * .1),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      width: media.width * 0.5,
                      height: media.height * 0.3,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.image.toString(),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'About :',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                    Text(
                      widget.user.about.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Text(
              'Join On :',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            Text(
              DateTimeUtils.getLastMessageTime(
                  context: context,
                  time: widget.user.createdAt.toString(),
                  year: true),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
