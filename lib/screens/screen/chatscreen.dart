import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/api/Api.dart';
import 'package:we_chat/helper/date_time_utils.dart';
import 'package:we_chat/models/chatmodel.dart';
import 'package:we_chat/models/messageModel.dart';
import 'package:we_chat/widget/messageCart.dart';

class Chatscreen extends StatefulWidget {
  final chatmodel user;
  const Chatscreen({super.key, required this.user});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  List<messageModel> list = [];
  bool showEmoji = false, uploadImages = false;
  final _textController = TextEditingController();
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (showEmoji) {
              setState(() {
                showEmoji = !showEmoji;
              });
            } else {
              return Future.value(true);
            }
            return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: Colors.blue.shade50,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.deepPurple,
              flexibleSpace: _app(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: Api.getAllMessage(widget.user),
                    builder: (context, snapshot) {
                      // Check for data and handle all connection states
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());

                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasData && snapshot.data != null) {
                            final data = snapshot.data!.docs;
                            list = data
                                .map((e) => messageModel.fromJson(e.data()))
                                .toList();

                            if (list.isNotEmpty) {
                              return ListView.builder(
                                reverse: true,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return MessageCart(
                                    message: list[index],
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'Hey Hi',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                          } else {
                            return const Center(
                              child: Text('No messages found'),
                            );
                          }

                        default:
                          return const Center(
                            child: Text('Something went wrong'),
                          );
                      }
                    },
                  ),
                ),
                if (uploadImages)
                  const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 25, top: 10, bottom: 10),
                        child: CircularProgressIndicator(),
                      )),
                chatInput(),
                if (showEmoji)
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.4, // Adjust based on your needs
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        emojiViewConfig: EmojiViewConfig(
                          backgroundColor: Colors.grey,
                          columns: 7,
                          emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _app() {
    final media = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Api.getSpecficUserInfo(widget.user),
      builder: (context, snapshot) {
        // Check if the snapshot has data and is not null
        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.docs;
          final list =
              data?.map((e) => chatmodel.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: media.height * 0.03,
              ),
              ClipOval(
                child: CachedNetworkImage(
                  height: media.height * 0.05, // Set height for the circle
                  width: media.height * 0.05, // Set width for the circle
                  imageUrl: list.isNotEmpty
                      ? list[0].image.toString()
                      : widget.user.image.toString(),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              SizedBox(
                width: media.width * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.isNotEmpty
                        ? list[0].name.toString()
                        : widget.user.name.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    list.isNotEmpty
                        ? list[0].isonline!
                            ? 'online'
                            : list[0].lastActive.toString()
                        : widget.user.lastActive.toString(),
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Center(
              child:
                  CircularProgressIndicator()); // Show a loading indicator while waiting for data
        }
      },
    );
  }

  Widget chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // Expanded card takes more space
          Expanded(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                // Add padding inside the card for better layout
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showEmoji = !showEmoji;
                          if (showEmoji) {
                            FocusScope.of(context)
                                .unfocus(); // Hide the keyboard
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                        size: 26,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: () {
                          if (showEmoji) {
                            setState(() {
                              showEmoji = !showEmoji;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type .......',
                          hintStyle: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile> images =
                            await picker.pickMultiImage();
                        for (var i in images) {
                          setState(() {
                            uploadImages = true;
                          });
                          await Api.getCameraImage(widget.user, File(i.path));
                          setState(() {
                            uploadImages = false;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? cameraimage =
                            await picker.pickImage(source: ImageSource.camera);

                        if (cameraimage != null) {
                          setState(() {
                            uploadImages = true;
                          });
                          await Api.getCameraImage(
                              widget.user, File(cameraimage.path));
                          uploadImages = false;
                        }
                      },
                      icon: const Icon(
                        Icons.camera,
                        color: Colors.blueAccent,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // MaterialButton only takes required size
          MaterialButton(
            shape: const CircleBorder(),
            color: Colors.green,
            minWidth:
                0, // Set minimum width to zero so the button doesn't expand unnecessarily
            padding: const EdgeInsets.all(12), // Control the size of the button
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                Api.SendMessage(widget.user, _textController.text, Type.Text);
                _textController.text = '';
              }
            },
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
