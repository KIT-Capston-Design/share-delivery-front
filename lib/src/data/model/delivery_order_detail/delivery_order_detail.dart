import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_delivery/src/data/model/delivery_order_detail/order_menu_model.dart';
import 'package:share_delivery/src/data/model/delivery_room/delivery_room/delivery_room.dart';

part 'delivery_order_detail.freezed.dart';
part 'delivery_order_detail.g.dart';

@Freezed()
class DeliveryOrderDetailModel with _$DeliveryOrderDetailModel {
  const factory DeliveryOrderDetailModel({
    required String deliveryRoomId,
    required ReceivingLocation receivingLocation,
    required List<OrderMenuModel> orderList,
    required DateTime createDate,
    required int totalOrderMoney,
    required int deliveryTip,
    required String discountInfoList, // TODO: 수정
    required int totalPaymentMoney,
  }) = _DeliveryOrderDetailModel;

  factory DeliveryOrderDetailModel.fromJson(Map<String, Object?> json) =>
      _$DeliveryOrderDetailModelFromJson(json);
}
