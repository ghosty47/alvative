import 'dart:io';

import 'package:alvative_test/helpers/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaystackPayment {
  BuildContext ctx;
  int cost;
  String email;

  PaystackPayment({
    required this.ctx,
    required this.cost,
    required this.email,
  });

  bool isLoading = false;

  PaystackPlugin paystack = PaystackPlugin();

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Get Paystack payment Modal
  PaymentCard _getCardFromUI() {
    return PaymentCard(
      number: "",
      cvc: "",
      expiryMonth: 0,
      expiryYear: 0,
    );
  }

  //Initialize paystack plugin
  Future initializePlugin() async {
    await paystack.initialize(
      publicKey: ConstantKey.PAYSTACK_KEY,
    );
  }

  //Make Payment
  chargeCardAndMakePayment() async {
    initializePlugin().then((_) async {
      Charge charge = Charge()
        ..amount = cost * 100
        ..email = email
        ..reference = _getReference()
        ..card = _getCardFromUI();

      CheckoutResponse response = await paystack.checkout(
        ctx,
        charge: charge,
        method: CheckoutMethod.card,
        fullscreen: false,
        logo: const FlutterLogo(
          size: 24,
        ),
      );

      print("Response $response");

      if (response.status == true) {
        //Navigate to either successpage displaying the transaction details or homepage
        print("Transaction was successful");
      } else {
        print("Transaction failed");
      }
    });
  }
}
