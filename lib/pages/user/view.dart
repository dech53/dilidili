import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'controller.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserPageController _userPageController = Get.put(UserPageController());
  late Future _futureBuilderFuture;
  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _userPageController.queryUserInfo();
    _userPageController.userLogin.listen(
      (status) {
        if (mounted) {
          setState(
            () {
              _futureBuilderFuture = _userPageController.queryUserInfo();
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/search'),
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/setting', preventDuplicates: false),
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: constraint.maxHeight,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: _futureBuilderFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data == null) {
                          return const SizedBox();
                        }
                        if (snapshot.data['status']) {
                          return Obx(
                            () => userInfoBuild(_userPageController, context),
                          );
                        } else {
                          return userInfoBuild(_userPageController, context);
                        }
                      } else {
                        return userInfoBuild(_userPageController, context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget userInfoBuild(_userPageController, context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (!_userPageController.userLogin.value) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, StateSetter setState) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  const Text('扫码登录'),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ],
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 0, 0, 4),
                              content: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  width: 200,
                                  padding: const EdgeInsets.all(12),
                                  child: FutureBuilder(
                                    future: _userPageController.getWebQrcode(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.data == null) {
                                          return const SizedBox();
                                        }
                                        Map data = snapshot.data as Map;
                                        return QrImageView(
                                          data: data['data']['url'],
                                          backgroundColor: Colors.white,
                                        );
                                      } else {
                                        return const Center(
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(
                                      () {
                                        return Text(
                                          '有效期:${_userPageController.validSeconds.value}s',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }
                },
                child: ClipOval(
                  child: Container(
                    width: 85,
                    height: 85,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    child: _userPageController.userInfo.value.face != null
                        ? NetworkImgLayer(
                            src: _userPageController.userInfo.value.face,
                            width: 85,
                            height: 85)
                        : Image.asset('assets/images/noface.jpeg'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _userPageController.userInfo.value.uname ?? '点击头像登录',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 6),
                        Image.asset(
                          'assets/images/lv/lv${_userPageController.userInfo.value.levelInfo != null ? _userPageController.userInfo.value.levelInfo!.currentLevel : '0'}.png',
                          height: 12,
                        ),
                      ],
                    ),
                    if (_userPageController.userLogin.value) ...[
                      const SizedBox(height: 2),
                      Image.network(
                        _userPageController.userInfo.value
                            .vipLabel['img_label_uri_hans_static'],
                        height: 20,
                      ),
                    ],
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '硬币: ',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline),
                              ),
                              TextSpan(
                                text:
                                    (_userPageController.userInfo.value.money ??
                                            '0.0')
                                        .toString(),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.keyboard_arrow_right,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              TextStyle style = TextStyle(
                  fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold);
              return SizedBox(
                height: constraints.maxWidth / 3 * 0.6,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(0),
                  crossAxisCount: 3,
                  childAspectRatio: 1.67,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        // _userPageController.pushDynamic();
                      },
                      borderRadius: StyleString.mdRadius,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            child: Text(
                                (_userPageController
                                            .userStat.value.dynamicCount ??
                                        '-')
                                    .toString(),
                                key: ValueKey<String>(_userPageController
                                    .userStat.value.dynamicCount
                                    .toString()),
                                style: style),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '动态',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _userPageController.pushFollow();
                      },
                      borderRadius: StyleString.mdRadius,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            child: Text(
                                (_userPageController.userStat.value.following ??
                                        '-')
                                    .toString(),
                                key: ValueKey<String>(_userPageController
                                    .userStat.value.following
                                    .toString()),
                                style: style),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '关注',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // _userPageController.pushFans();
                      },
                      borderRadius: StyleString.mdRadius,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            child: Text(
                                (_userPageController.userStat.value.follower ??
                                        '-')
                                    .toString(),
                                key: ValueKey<String>(_userPageController
                                    .userStat.value.follower
                                    .toString()),
                                style: style),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '粉丝',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
