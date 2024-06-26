import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:zipapp/constants/tailwind_colors.dart';
import 'package:zipapp/constants/zip_design.dart';
import 'package:zipapp/ui/screens/payment_info_screen.dart';


class PaymentListItem {
  Widget build(
      {required BuildContext context,
      required String cardType,
      required String lastFourDigits,
      required String paymentMethodId,
      required bool togglePaymentInfo,
      refreshKey}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TailwindColors.gray300)),
      ),
      child: Row(children: <Widget>[
        // Expanded to ensure the button stretches to fill the row
        Expanded(
          child: TextButton(
            onPressed: () {
              if (!togglePaymentInfo) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentInfo(
                    paymentMethodId: paymentMethodId,
                    cardType: cardType,
                    lastFourDigits: lastFourDigits,
                    refreshKey: refreshKey,
                  )),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              textStyle: MaterialStateProperty.all(ZipDesign.labelText),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Space between items
              children: <Widget>[
                // Row for the credit card icon and the text
                Row(
                  children: <Widget>[
                    ( cardType == 'Apple Pay' ? const Image(image: AssetImage('assets/apple_pay_icon.png'), height: 18)
                    : cardType == 'Google Pay' ? const Image(image: AssetImage('assets/google_pay_icon.png'), height: 18)
                    : const Icon(LucideIcons.creditCard, size: 24, color: Colors.black)),
                    const SizedBox(width: 8), // Space between icon and text
                    Text('$cardType ${lastFourDigits != "" ? "••••$lastFourDigits" : ""}'),
                  ],
                ),
                // Chevron-right icon on the right side
                const Icon(LucideIcons.chevronRight,
                    size: 24, color: TailwindColors.gray500),
                ],
              ),
          ),
        ),
      ]),
    );
  }
}
