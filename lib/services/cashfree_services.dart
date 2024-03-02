import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../utils/constant.dart';

class CashFreePaymentIntegration {
  static const String _baseUrl = "https://sandbox.cashfree.com/pg/orders";
  static const String _appId = "3103776664403214388a3022d3773013";
  static const String _secretKey = "354450c46a4f1394a3a2397fdb23fa3f4ca1277f";

  static Future<Map<String, dynamic>> generateOrder(
      {required double orderAmount,
      required String orderId,
      required String currency,
      required Map<String,dynamic> plan,
      }) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "x-api-version": "2022-09-01",
      "x-client-id": _appId,
      "x-client-secret": _secretKey,
    };

    Map<String, dynamic> body = {
      "order_id": orderId,
      "order_amount": orderAmount,
      "order_currency": currency,
      "order_note": "MoneySaga Consultancy",
      "customer_details": {
        "customer_id": "12345",
        "customer_name": "MoneySaga Consultancy",
        "customer_email": "test@gmail.com",
        "customer_phone": "9999999999"
      }
    };

    var response = await http.post(
      Uri.parse(_baseUrl),
      headers: header,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
          users.setBoughtPack(plan, orderId);

      return jsonDecode(response.body);
    } else {
      log('$currency');
      log('$orderAmount');
      log('${response.body}');
      throw Exception("Error while generating order ${response.body}");
    }
  }
}
