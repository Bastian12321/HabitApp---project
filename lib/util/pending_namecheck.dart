import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PendingNamecheck extends StatefulWidget {

  bool? loading = true;
  PendingNamecheck({super.key, this.loading});

  @override
  State<PendingNamecheck> createState() => _PendingNamecheckState();
}

class _PendingNamecheckState extends State<PendingNamecheck> {
  void toggleLoading() {
    setState(() => widget.loading = !widget.loading!);
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1D716F),
      content: Container(
        alignment: Alignment.center,
        height: 150,
        width: 300,
        child: widget.loading! ? const SpinKitCircle(
          color:Color.fromARGB(255, 232, 124, 112),
          size: 50,
        )
        : TextButton(
            child: const Text(
              'Name already taken',
              style: TextStyle(
                color: Color.fromARGB(255, 232, 124, 112),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ), 
            ),
            onPressed: () => (Navigator.of(context).pop()),
          ),
      ),
    );
  }
}