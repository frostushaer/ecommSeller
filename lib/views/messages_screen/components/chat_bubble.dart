import 'package:ecomm_seller/const/const.dart';
import 'package:ecomm_seller/views/widgets/text_style.dart';

Widget chatBubble() {
  return Directionality(
    // textDirection: data['uid'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
    textDirection: TextDirection.ltr,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        // color: data['uid'] == currentUser!.uid ? redColor : darkFontGrey,
        color: purpleColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "${data['msg']}".text.size(16).white.make(),
          normalText(text: "your message here"),
          10.heightBox,
          // time.text.color(whiteColor.withOpacity(0.5)).make(),
          normalText(text: "10:45pm"),
        ],
      ),
    ),
  );
}
