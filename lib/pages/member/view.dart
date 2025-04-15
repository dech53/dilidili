import 'package:dilidili/pages/member/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  late MemberController _memberController;

  @override
  void initState() {
    super.initState();
    _memberController = Get.put(MemberController());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text("${_memberController.mid}"),
      ),
    );
  }
}
