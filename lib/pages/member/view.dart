import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/pages/member/controller.dart';
import 'package:dilidili/pages/member/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage>
    with SingleTickerProviderStateMixin {
  late MemberController _memberController;
  late Future _futureBuilderFuture;
  final ScrollController _extendNestCtr = ScrollController();
  late Future _futureBuilderFolder;
  late TabController _tabController;
  //filter,存在则显示
  List tabs = ['主页', '投稿', '动态', '收藏'];

  @override
  void initState() {
    super.initState();
    _memberController = Get.put(MemberController());
    _futureBuilderFuture = _memberController.getInfo();
    _futureBuilderFolder = _memberController.getUserFolder();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _memberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              SmartDialog.showToast("点击了搜索");
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              await Share.share(
                  "https://space.bilibili.com/${_memberController.mid}");
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _extendNestCtr,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 20,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 18, right: 18, bottom: 20),
                      child: FutureBuilder(
                        future: _futureBuilderFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map? data = snapshot.data;
                            if (data != null && data['status']) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfilePanel(ctr: _memberController),
                                  10.verticalSpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onLongPress: () async {
                                          await Clipboard.setData(ClipboardData(
                                              text: _memberController
                                                  .memberInfo.value.name!));
                                          SmartDialog.showToast('名称已复制');
                                        },
                                        child: Text(
                                          _memberController
                                              .memberInfo.value.name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: (_memberController
                                                                  .memberInfo
                                                                  .value
                                                                  .vip !=
                                                              null &&
                                                          _memberController
                                                                  .memberInfo
                                                                  .value
                                                                  .vip!
                                                                  .type !=
                                                              0)
                                                      ? Colors.pinkAccent
                                                      : null),
                                        ),
                                      ),
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
                                      ],
                                    ],
                                  ),
                                  if (_memberController
                                          .memberInfo.value.official!.title !=
                                      '') ...[
                                    const SizedBox(height: 6),
                                    Text.rich(
                                      maxLines: 2,
                                      TextSpan(
                                        text: _memberController.memberInfo.value
                                                    .official!.role ==
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
                                                .value.official!.title!,
                                          ),
                                        ],
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "mid:${_memberController.memberInfo.value.mid}",
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_memberController.memberInfo.value.sign !=
                                      '')
                                    SelectableText(
                                      _memberController.memberInfo.value.sign!,
                                    ),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            // 骨架屏
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                    //收藏、投稿、专栏、动态 tabbar
                    Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            controller: _tabController,
                            padding: EdgeInsets.zero,
                            labelStyle: const TextStyle(fontSize: 13),
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            dividerColor: Colors.transparent,
                            tabs: tabs
                                .map((e) => Tab(
                                      text: e,
                                    ))
                                .toList(),
                            onTap: (index) {},
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
