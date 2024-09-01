class PaymentReceiptData {
  final bool purchaseSuccess;
  final int payablePrice;
  final String purchaseStatus;

  PaymentReceiptData.fromJson(Map<String, dynamic> json)
      : payablePrice = json['payable_price'],
        purchaseStatus = json['purchase_status'],
        purchaseSuccess = json['purchase_success'];
}
