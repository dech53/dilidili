import 'package:flutter/material.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({super.key, required this.rid});
  final int rid;
  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("分区"),
    );
  }
}
