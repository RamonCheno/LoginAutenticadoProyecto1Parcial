import 'package:flutter/material.dart';

class GetLoginSignupHeader extends StatelessWidget {
  final String headerName;
  const GetLoginSignupHeader(this.headerName, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30.0),
            Text(
              headerName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30.0),
            ),
            const SizedBox(height: 10.0),
            Image.asset(
              'assets/images/Logo.png',
              height: 150.0,
              width: 150.0,
            ),
      ],
    );
  }
}
