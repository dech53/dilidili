import 'dart:async';

import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/member_tab_type.dart';
import 'package:dilidili/pages/member/SliverHeaderDelegate.dart';
import 'package:dilidili/pages/member/controller.dart';
import 'package:dilidili/pages/member/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage>
    with SingleTickerProviderStateMixin {
  late MemberController _memberController;
  late Future _futureBuilderFuture;
  late TabController _tabController;
  final ScrollController _extendNestCtr = ScrollController();
  final StreamController<bool> appbarStream =
      StreamController<bool>.broadcast();
  @override
  void initState() {
    super.initState();
    _memberController = Get.put(MemberController());
    _futureBuilderFuture = _memberController.getInfo();
    _tabController = TabController(
      length: memberTabs.length,
      vsync: this,
      initialIndex: 1,
    );
    _extendNestCtr.addListener(
      () {
        final double offset = _extendNestCtr.position.pixels;
        if (offset > 100) {
          appbarStream.add(true);
        } else {
          appbarStream.add(false);
        }
      },
    );
  }

  @override
  void dispose() {
    _extendNestCtr.removeListener(() {});
    appbarStream.close();
    _memberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: Column(
        children: [
          AppBar(
            title: StreamBuilder(
              stream: appbarStream.stream.distinct(),
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return AnimatedOpacity(
                  opacity: snapshot.data ? 1 : 0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => NetworkImgLayer(
                              width: 35,
                              height: 35,
                              type: 'avatar',
                              src: _memberController.face.value,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(
                            () => Text(
                              _memberController.memberInfo.value.name ?? '',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                onPressed: () => Get.toNamed(
                    '/memberSearch?mid=${_memberController.mid}&uname=${_memberController.memberInfo.value.name!}'),
                icon: const Icon(Icons.search_outlined),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  if (_memberController.ownerMid != _memberController.mid) ...[
                    PopupMenuItem(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.block, size: 19),
                          const SizedBox(width: 10),
                          Text(_memberController.attribute.value != 128
                              ? '加入黑名单'
                              : '移除黑名单'),
                        ],
                      ),
                    )
                  ],
                  PopupMenuItem(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.share_outlined, size: 19),
                        const SizedBox(width: 10),
                        Text(_memberController.ownerMid != _memberController.mid
                            ? '分享UP主'
                            : '分享我的主页'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),
          SingleChildScrollView(
            controller: _extendNestCtr,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18, right: 18, bottom: 10),
                  child: FutureBuilder(
                    future: _futureBuilderFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map? data = snapshot.data;
                        if (data != null && data['status']) {
                          return Obx(
                            () => Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProfilePanel(ctr: _memberController),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Flexible(
                                            child: Text(
                                          _memberController
                                              .memberInfo.value.name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _memberController
                                                        .memberInfo
                                                        .value
                                                        .vip!
                                                        .nicknameColor !=
                                                    ''
                                                ? Color(int.parse(
                                                    "0xFF${_memberController.memberInfo.value.vip!.nicknameColor!.replaceAll('#', '')}"))
                                                : Colors.black,
                                          ),
                                        )),
                                        const SizedBox(width: 2),
                                        if (_memberController
                                                .memberInfo.value.sex ==
                                            '女')
                                          const Icon(
                                            FontAwesomeIcons.venus,
                                            size: 14,
                                            color: Colors.pink,
                                          ),
                                        if (_memberController
                                                .memberInfo.value.sex ==
                                            '男')
                                          const Icon(
                                            FontAwesomeIcons.mars,
                                            size: 14,
                                            color: Colors.blue,
                                          ),
                                        const SizedBox(width: 4),
                                        Image.asset(
                                          'assets/images/lv/lv${_memberController.memberInfo.value.level}.png',
                                          height: 11,
                                        ),
                                        const SizedBox(width: 6),
                                        if (_memberController.memberInfo.value
                                                    .vip!.status ==
                                                1 &&
                                            _memberController
                                                    .memberInfo
                                                    .value
                                                    .vip!
                                                    .label!
                                                    .imgLabelUriHans !=
                                                '') ...[
                                          Image.network(
                                            _memberController.memberInfo.value
                                                .vip!.label!.imgLabelUriHans!,
                                            height: 20,
                                          ),
                                        ] else if (_memberController.memberInfo
                                                    .value.vip!.status ==
                                                1 &&
                                            _memberController
                                                    .memberInfo
                                                    .value
                                                    .vip!
                                                    .label!
                                                    .imgLabelUriHansStatic !=
                                                '') ...[
                                          Image.network(
                                            _memberController
                                                .memberInfo
                                                .value
                                                .vip!
                                                .label!
                                                .imgLabelUriHansStatic!,
                                            height: 20,
                                          ),
                                        ]
                                      ],
                                    ),
                                    if (_memberController
                                            .memberInfo.value.official!.title !=
                                        '') ...[
                                      const SizedBox(height: 6),
                                      Text.rich(
                                        maxLines: 2,
                                        TextSpan(
                                          text: _memberController.memberInfo
                                                      .value.official!.role ==
                                                  1
                                              ? '个人认证：'
                                              : '企业认证：',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: _memberController.memberInfo
                                                  .value.official!.title,
                                            ),
                                          ],
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                    const SizedBox(height: 6),
                                    if (_memberController
                                            .memberInfo.value.sign !=
                                        '')
                                      SelectableText(
                                        _memberController
                                            .memberInfo.value.sign!,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        // 骨架屏
                        return ProfilePanel(
                            ctr: _memberController, loadingStatus: true);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            padding: EdgeInsets.zero,
            labelStyle: const TextStyle(fontSize: 13),
            labelPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            dividerColor: Colors.transparent,
            tabs: _memberController.tabs
                .map((e) => Tab(
                      text: e['label'],
                    ))
                .toList(),
            onTap: (index) {},
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _memberController.tabsPageList,
            ),
          ),
        ],
      ),
    );
  }
}
