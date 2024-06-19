import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1D716F),
      child: const Center(
        child: SpinKitCircle(
          color:Color.fromARGB(255, 232, 124, 112),
          size: 50,
        ),
      )
    );
  }
}