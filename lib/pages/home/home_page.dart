import 'dart:math';

import 'package:dilidili/component/video_card_component.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dilidili/pages/video_detail/video_page.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:dilidili/utils/wbi_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<VideoItem> _videoList = [];
  int _currentPage = Random().nextInt(500);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMoreVideoList();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreVideoList();
    }
  }

  void _loadMoreVideoList() async {
    try {
      Response response = await DioInstance.instance().get(
        path: ApiString.baseUrl + ApiString.getRcmdVideo,
        param: await WbiUtils.getWbi({
          "fresh_idx": _currentPage,
        }),
      );
      RcmdVideo parsedData = Rootdata.fromJson(
        response.data,
        (dynamic data) => RcmdVideo.fromJson(data),
      ).data;
      setState(() {
        _videoList.addAll(parsedData.item);
      });
      _currentPage++;
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _getBodyUI(),
    );
  }

  Widget _getBodyUI() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            10.verticalSpace,
            SizedBox(
              height: ScreenUtil().screenHeight * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //问候语
                  Text(
                    "${StringUtils.getTimeGreeting()},dech53",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //头像
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://i1.hdslb.com/bfs/face/7cd9a2b4c9ce9a99443f8a22fe4e7cc3a0c10039.jpg@120w_120h_1c.avif",
                    ),
                  ),
                ],
              ),
            ),
            15.verticalSpace,
            //搜索
            SizedBox(
              height: ScreenUtil().screenHeight * 0.05,
              child: Row(
                children: [
                  //搜索框
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 12.w),
                      alignment: Alignment.centerLeft,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_outlined,
                            size: 25.r,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          5.horizontalSpace,
                          Text(
                            "搜索...",
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.w),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_outlined,
                        size: 25.r,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //视频列表
            15.verticalSpace,
            SizedBox(
              height: ScreenUtil().screenHeight * 0.75,
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(
                    const Duration(seconds: 1),
                  );
                  _currentPage = Random().nextInt(500);
                  _videoList.clear();
                  _loadMoreVideoList();
                },
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _videoList.length,
                  itemBuilder: (context, index) {
                    return VideoCardComponent(
                      video: _videoList[index],
                      itemTap: (video) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPage(
                              video: video,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
