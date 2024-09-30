import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/api/Api.dart';
import 'package:we_chat/helper/date_time_utils.dart';
import 'package:we_chat/models/ChatModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_chat/models/messageModel.dart';
import 'package:we_chat/screens/screen/chatscreen.dart';
import 'package:we_chat/widget/dialog/profile_dialog.dart';

class ChatUserCard extends StatefulWidget {
  final ChatModel user;
  const ChatUserCard({
    super.key,
    required this.user,
  });

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  messageModel? message;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Chatscreen(user: widget.user)));
          },
          child: StreamBuilder(
              stream: Api.getLastMessage(widget.user),
              builder: (context, snapshot) {
                // final data = snapshot.data!.docs;
                // final list =
                //     data.map((e) => messageModel.fromJson(e.data())).toList();
                // if (list.isNotEmpty) {
                //   message = list[0];
                // }
                if (snapshot.hasData && snapshot.data != null) {
                  final data = snapshot.data!.docs;
                  final list =
                      data.map((e) => messageModel.fromJson(e.data())).toList();
                  if (list.isNotEmpty) {
                    message = list[0];
                  }
                }

                return ListTile(
                  // leading: const CircleAvatar(
                  //   child: Icon(CupertinoIcons.person),
                  // ),
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(user: widget.user));
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        width: 60,
                        height: 60,
                        imageUrl: widget.user.image.toString(),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                  ),
                  title: Text(widget.user.name.toString()),
                  subtitle: Text(message != null
                      ? message!.type == Type.Image
                          ? 'image'
                          : message!.msg.toString()
                      : widget.user.about.toString()),
                  trailing: message == null
                      ? null
                      : (message!.read!.isEmpty &&
                              message!.fromId != Api.user.uid
                          ? Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.green.shade400),
                            )
                          : Text(DateTimeUtils.getLastMessageTime(
                              context: context,
                              time: message!.sent.toString()))),
                );
              })),
    );
  }
}
