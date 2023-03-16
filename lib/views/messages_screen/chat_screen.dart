import 'package:ecomm_seller/const/const.dart';
import 'package:ecomm_seller/views/messages_screen/components/chat_bubble.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/route_manager.dart';

import '../widgets/text_style.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkGrey,
            )),
        title: boldText(text: chats, size: 16.0, color: fontGrey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: 20,
              itemBuilder: ((context, index) {
                return chatBubble();
              }),
            )),
            10.heightBox,
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: "Enter your message..",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: purpleColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: purpleColor),
                      ),
                    ),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        color: purpleColor,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
