import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/api/Api.dart';
import 'package:we_chat/models/ChatModel.dart';
import 'package:we_chat/screens/screen/profile_screen.dart';
import 'package:we_chat/widget/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Api.getUserInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      print(message);
      if (Api.auth.currentUser != null) {
        if (message.toString().contains('resume')) Api.updateActiveStatus(true);
        if (message.toString().contains('pause')) Api.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  List<ChatModel> list = [];
  List<ChatModel> searchList = [];
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () async {
            if (isSearch) {
              setState(() {
                isSearch = !isSearch;
              });
            } else {
              return Future.value(true);
            }
            return Future.value(false);
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 2,
              title: isSearch
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name , Email .....'),
                      autofocus: true,
                      onChanged: (val) {
                        searchList.clear();
                        for (var i in list) {
                          if (i.name!
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email!
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            searchList.add(i);
                          }
                          setState(() {
                            searchList;
                          });
                        }
                      },
                    )
                  : const Text(
                      'We Chat',
                      style: TextStyle(color: Colors.white),
                    ),
              centerTitle: true,
              leading: const Icon(
                CupertinoIcons.home,
                color: Colors.white,
              ),
              backgroundColor: Colors.deepPurple,
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = !isSearch;
                      });
                    },
                    icon: Icon(
                      isSearch
                          ? CupertinoIcons.clear_circled_solid
                          : Icons.search,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(user: Api.me)));
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    )),
              ],
            ),
            body: StreamBuilder(
              stream: Api.getUsers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Assuming snapshot has Map<String, dynamic> and you're converting it to ChatModel
                final data = snapshot.data!.docs;
                list = data.map((e) => ChatModel.fromJson(e.data())).toList();

                if (list.isNotEmpty) {
                  return ListView.builder(
                    itemCount:
                        isSearch ? searchList.length : snapshot.data!.size,
                    itemBuilder: (context, index) {
                      return ChatUserCard(
                        user: isSearch ? searchList[index] : list[index],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No Connection Established',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
