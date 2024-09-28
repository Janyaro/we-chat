import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/api/Api.dart';
import 'package:we_chat/helper/date_time_utils.dart';
import 'package:we_chat/models/messageModel.dart';

class MessageCart extends StatefulWidget {
  final messageModel message;
  const MessageCart({super.key, required this.message});

  @override
  State<MessageCart> createState() => _MessageCartState();
}

class _MessageCartState extends State<MessageCart> {
  @override
  Widget build(BuildContext context) {
    return Api.user.uid == widget.message.fromId ? greenCart() : blueCart();
  }

  Widget blueCart() {
    if (widget.message.read!.isEmpty) {
      Api.updateRead(widget.message);
      print('message updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.Image ? 4 : 10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              border: Border.all(color: Colors.lightBlue),
            ),
            child: widget.message.type == Type.Text
                ? Text(
                    widget.message.msg.toString(),
                    style: const TextStyle(fontSize: 16),
                  )
                : ClipOval(
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.3,
                      imageUrl: widget.message.msg.toString(),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            DateTimeUtils.formatDateTime(
                context: context, time: widget.message.sent.toString()),
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget greenCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            if (widget.message.read!.isNotEmpty)
              const Icon(
                Icons.done_all_outlined,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(
              width: 4,
            ),
            Text(DateTimeUtils.formatDateTime(
                context: context, time: widget.message.sent.toString())),
          ],
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                border: Border.all(color: Colors.lightGreen)),
            child: widget.message.type == Type.Text
                ? Text(
                    widget.message.msg.toString(),
                    style: const TextStyle(fontSize: 16),
                  )
                : ClipOval(
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.3,
                      imageUrl: widget.message.msg.toString(),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
