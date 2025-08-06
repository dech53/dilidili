import 'package:flutter/material.dart';

class MemberMomentPage extends StatefulWidget {
  const MemberMomentPage({super.key});

  @override
  State<MemberMomentPage> createState() => _MemberMomentPageState();
}

class _MemberMomentPageState extends State<MemberMomentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
          child: Center(
        child: Text("主页"),
      )),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
