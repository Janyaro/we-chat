import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/models/chatmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatUserCard extends StatefulWidget {
  final chatmodel user;
  const ChatUserCard({
    super.key,
    required this.user,
  });

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          // leading: const CircleAvatar(
          //   child: Icon(CupertinoIcons.person),
          // ),
          leading: ClipOval(
            child: CachedNetworkImage(
              imageUrl: widget.user.image.toString(),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          title: Text(widget.user.name.toString()),
          subtitle: Text(widget.user.about.toString()),
          trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.green.shade400),
          ),
        ),
      ),
    );
  }
}
