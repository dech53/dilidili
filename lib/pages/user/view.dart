import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/pages/user/widgets/history_card_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
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
                            () => _buildUserInfo(context),
                          );
                        } else {
                          return _buildUserInfo(context);
                        }
                      } else {
                        return _buildUserInfo(context);
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

  Widget _buildUserInfo(BuildContext context) {
    final String? vipLabelUrl = _userPageController
        .userInfo.value.vipLabel?['img_label_uri_hans_static']
        ?.toString();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _userPageController.onLogin(),
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
                    if (_userPageController.userLogin.value &&
                        vipLabelUrl?.isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Image.network(
                        vipLabelUrl!,
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
                        _userPageController.pushFans();
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
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              margin: const EdgeInsets.only(top: 6, bottom: 4),
              height: constraints.maxWidth / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _userPageController.list.map<Widget>((e) {
                  return InkWell(
                    onTap: () => e['onTap'](),
                    borderRadius: StyleString.mdRadius,
                    child: SizedBox(
                      width: (constraints.maxWidth - 24) / 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 4),
                          Icon(
                            e['icon'],
                            size: Get.width / 17,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            e['title'],
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        _buildHistory(),
      ],
    );
  }

  Widget _buildHistory() {
    return Obx(() {
      if (!_userPageController.userLogin.value ||
          _userPageController.historyLoadingState.value) {
        return const SizedBox.shrink();
      }

      final ThemeData theme = Theme.of(context);
      final Color secondary = theme.colorScheme.secondary;
      return Column(
        children: [
          Divider(
            height: 20,
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
          ListTile(
            onTap: () => Get.toNamed('/history'),
            dense: true,
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '观看记录  ',
                      style: TextStyle(
                        fontSize: theme.textTheme.titleMedium!.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    WidgetSpan(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            trailing: IconButton(
              tooltip: '刷新',
              onPressed: _userPageController.queryHistory,
              icon: const Icon(Icons.refresh, size: 20),
            ),
          ),
          _buildHistoryBody(theme, secondary),
        ],
      );
    });
  }

  Widget _buildHistoryBody(ThemeData theme, Color secondary) {
    final String? errMsg = _userPageController.historyError.value;
    if (errMsg != null) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Text(errMsg, textAlign: TextAlign.center),
        ),
      );
    }

    final List historyList = _userPageController.historyList;
    if (historyList.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 173,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
        itemCount: historyList.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == historyList.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 46),
              child: Center(
                child: IconButton(
                  tooltip: '查看更多',
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                    backgroundColor: WidgetStatePropertyAll(
                      theme.colorScheme.secondaryContainer.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  onPressed: () => Get.toNamed('/history'),
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: secondary,
                  ),
                ),
              ),
            );
          }
          return HistoryCardItem(item: historyList[index]);
        },
        separatorBuilder: (_, __) => const SizedBox(width: 14),
      ),
    );
  }
}
