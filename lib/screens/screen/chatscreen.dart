import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/api/Api.dart';
import 'package:we_chat/models/chatmodel.dart';

class Chatscreen extends StatefulWidget {
  final chatmodel user;
  const Chatscreen({super.key, required this.user});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: _app(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Api.getAllMessage(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    // return const Center(
                    //   child: CircularProgressIndicator(),
                    // );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data!.docs;
                      print('data : ${jsonEncode(data![0].data())}');
                      // list = data
                      //     .map((e) => chatmodel.fromJson(e.data()))
                      //     .toList();
                      final list = [];
                      if (list.isNotEmpty) {
                        return ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Text(list[index]);
                            });
                      } else {
                        return const Center(
                          child: Text(
                            'Hey Hi ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            chatInput()
          ],
        ),
      ),
    );
  }

  Widget _app() {
    final media = MediaQuery.of(context).size;
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        SizedBox(
          height: media.height * 0.03,
        ),
        ClipOval(
          child: CachedNetworkImage(
            height: media.height * 0.06,
            imageUrl: widget.user.image.toString(),
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
              widget.user.name.toString(),
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            const Text(
              'last seen not available',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        )
      ],
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
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                        size: 26,
                      ),
                    ),
                    const Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type .......',
                          hintStyle: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
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
            onPressed: () {},
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
