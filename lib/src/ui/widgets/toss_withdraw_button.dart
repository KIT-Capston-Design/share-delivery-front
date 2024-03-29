import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// supertoss://send?amount=0&bank=대구은행&accountNo=77802467094&origin=qr
class TossWithdrawButton extends StatelessWidget {
  static const String tossPrefixUrl = "supertoss://send";

  int? amount;
  final String bank;
  final String account;

  TossWithdrawButton(
      {Key? key, required this.bank, required this.account, this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blueAccent.shade200,
        elevation: 0.0,
      ),
      onPressed: () async {
        String deepLink =
            "$tossPrefixUrl?amount=$amount&bank=$bank&accountNo=$account&origin=qr";
        final url = Uri.parse(deepLink);
        if (await canLaunchUrl(url)) {
          launchUrl(
            url,
            mode: LaunchMode.externalNonBrowserApplication,
          );
        }
      },
      child: Text(
        "토스 송금하기",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
