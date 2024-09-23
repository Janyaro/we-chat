import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/api/Api.dart';
import 'package:we_chat/models/chatmodel.dart';
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
  }

  List<chatmodel> list = [];
  List<chatmodel> searchList = [];
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
                              i.eMail!
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
                  : const Text('We Chat'),
              centerTitle: true,
              leading: const Icon(CupertinoIcons.home),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = !isSearch;
                      });
                    },
                    icon: Icon(isSearch
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(user: Api.me)));
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
            body: StreamBuilder(
                stream: Api.getUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data!.docs;
                      list = data
                          .map((e) => chatmodel.fromJson(e.data()))
                          .toList();
                      if (list.isNotEmpty) {
                        return ListView.builder(
                            itemCount: isSearch
                                ? searchList.length
                                : snapshot.data!.size,
                            itemBuilder: (context, index) {
                              return ChatUserCard(
                                user:
                                    isSearch ? searchList[index] : list[index],
                              );
                            });
                      } else {
                        return const Center(
                          child: Text(
                            'No Connection Established',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                  }
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (kDebugMode) {
                  print('sing out successfull');
                }
              },
              child: const Icon(CupertinoIcons.add),
            ),
          ),
        ),
      ),
    );
  }
}
