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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: '二维码登录',
            onPressed: () {
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
                        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () {
                                  return Text(
                                    '有效期:${_userPageController.validSeconds.value}s',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    });
                  });
            },
            icon: const Icon(Icons.qr_code, size: 20),
          ),
        ],
      ),
      body: _getBodyUI(),
    );
  }

  //后续通过api获取二维码链接
  Widget _getBodyUI() {
    return SizedBox();
  }
}
