import 'package:ecomm_seller/const/const.dart';
import 'package:ecomm_seller/controllers/orders_controller.dart';
import 'package:ecomm_seller/views/widgets/ourButton.dart';
import 'package:ecomm_seller/views/widgets/text_style.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart' as intl;
import 'components/order_place.dart';

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var controller = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();
    controller.getOrders(widget.data);
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: darkGrey,
              )),
          title: boldText(text: "Order details", color: fontGrey, size: 16.0),
        ),
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: SizedBox(
            height: 60,
            width: context.screenWidth,
            child: ourButton(
                color: green,
                onPress: () {
                  controller.confirmed(true);
                  controller.changeStatus(
                      title: 'order_confirmed',
                      status: true,
                      docID: widget.data.id);
                },
                title: "Confirm Order"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // print(data['order_placed']),
                // order selivery status section
                Visibility(
                  visible: controller.confirmed.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      boldText(
                          text: "Order Status", color: fontGrey, size: 16.0),
                      SwitchListTile(
                        activeColor: green,
                        value: true,
                        onChanged: (value) {},
                        title: boldText(text: "Placed", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.confirmed.value,
                        onChanged: (value) {
                          controller.confirmed.value = value;
                        },
                        title: boldText(text: "Confirmed", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.ondelivery.value,
                        onChanged: (value) {
                          controller.ondelivery.value = value;
                          controller.changeStatus(
                              title: 'order_on_delivery',
                              status: value,
                              docID: widget.data.id);
                        },
                        title: boldText(text: "On Delivery", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.delivered.value,
                        onChanged: (value) {
                          controller.delivered.value = value;
                          controller.changeStatus(
                              title: 'order_delivered',
                              status: value,
                              docID: widget.data.id);
                        },
                        title: boldText(text: "Delivered", color: fontGrey),
                      )
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.all(8))
                      .outerShadowMd
                      .white
                      .border(color: lightGrey)
                      .roundedSM
                      .make(),
                ),

                // order details section
                Column(
                  children: [
                    orderPlacedDetails(
                        d1: "${widget.data['order_code']}",
                        d2: "${widget.data['shipping_method']}",
                        title1: "Order code",
                        title2: "Shipping Method"),
                    orderPlacedDetails(
                        d1: intl.DateFormat()
                            .add_yMd()
                            .format((widget.data['order_date'].toDate())),
                        d2: "${widget.data['payment_method']}",
                        title1: "Order data",
                        title2: "Payment Method"),
                    orderPlacedDetails(
                        d1: "unpaid",
                        d2: "order Placed",
                        title1: "Payment Status",
                        title2: "Delivery Status"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // "Shipping Address".text.fontFamily(semibold).make(),
                              boldText(
                                  text: "Shipping Address", color: purpleColor),
                              "${widget.data['order_by_name']}".text.make(),
                              "${widget.data['order_by_email']}".text.make(),
                              "${widget.data['order_by_address']}".text.make(),
                              "${widget.data['order_by_city']}".text.make(),
                              "${widget.data['order_by_state']}".text.make(),
                              "${widget.data['order_by_phone']}".text.make(),
                              "${widget.data['order_by_postalcode']}"
                                  .text
                                  .make(),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boldText(
                                    text: "Total Amount", color: purpleColor),
                                boldText(
                                    text: "${widget.data['total_amount']}",
                                    color: red,
                                    size: 16.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    .box
                    .outerShadowMd
                    .white
                    .border(color: lightGrey)
                    .roundedSM
                    .make(),

                const Divider(),
                10.heightBox,
                boldText(text: "Ordered Products", color: fontGrey, size: 16.0),

                10.heightBox,
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(controller.orders.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderPlacedDetails(
                          title1: "${controller.orders[index]['title']}",
                          title2: "${controller.orders[index]['tprice']}",
                          d1: "${controller.orders[index]['qty']} x",
                          d2: "Refundable",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: 30,
                            height: 20,
                            color: Color(controller.orders[index]['color']),
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                )
                    .box
                    .outerShadowMd
                    .white
                    .margin(const EdgeInsets.only(bottom: 4))
                    .make(),
                10.heightBox,

                // Row(
                //   children: [
                //     "SUB TOTAL: "
                //         .text
                //         .size(16)
                //         .fontFamily(semibold)
                //         .color(darkFontGrey)
                //         .make(),
                //   ],
                // ),
                20.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
