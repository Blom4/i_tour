import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TransportCabs extends StatefulWidget {
  const TransportCabs({super.key});

  @override
  State<TransportCabs> createState() => _TransportCabsState();
}

class _TransportCabsState extends State<TransportCabs> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("transportCabs"));
  }
}