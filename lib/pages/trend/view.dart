import 'package:dilidili/pages/trend/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrendPage extends StatefulWidget {
  const TrendPage({super.key});

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TrendController _rankController = Get.put(TrendController());

  @override
  void initState() {
    super.initState();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("排行榜"),
    );
  }
}
