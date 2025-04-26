import 'package:dilidili/common/widgets/html_widget.dart';
import 'package:dilidili/model/read/opus.dart';
import 'package:dilidili/model/read/read.dart';
import 'package:dilidili/pages/read/controller.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  final ReadPageController controller = Get.put(ReadPageController());
  late Future _futureBuilder;
  @override
  void initState() {
    super.initState();
    _futureBuilder = controller.fetchCvData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            _buildFutureContent(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        shape: const CircleBorder(),
        child: StreamBuilder(
          stream: controller.appbarStream.stream.distinct(),
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Icon(
              snapshot.data ? Icons.arrow_upward : Icons.message,
              color: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: StreamBuilder(
        stream: controller.appbarStream.stream.distinct(),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return AnimatedOpacity(
            opacity: snapshot.data ? 1 : 0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
            child: Obx(
              () => Text(
                controller.title.value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            controller.onJumpWebview();
          },
          icon: const Icon(Icons.open_in_browser),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Obx(
        () => Text(
          controller.title.value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFutureContent() {
    return FutureBuilder(
      future: _futureBuilder,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const SizedBox();
          }
          if (snapshot.data['status']) {
            return _buildContent(snapshot.data['data']);
          } else {
            return _buildError(snapshot.data['message']);
          }
        } else {
          return _buildLoading();
        }
      },
    );
  }

  Widget _buildError(String message) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(message),
      ),
    );
  }

  Widget _buildContent(ReadDataModel cvData) {
    final List<String> picList = _extractPicList(cvData);
    final List<String> imgList = extractDataSrc(cvData.readInfo!.content!);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, MediaQuery.of(context).padding.bottom + 40),
      child: _buildNonOpusContent(cvData, imgList),
    );
  }

  List<String> _extractPicList(ReadDataModel cvData) {
    final List<String> picList = [];
    if (cvData.readInfo!.opus != null) {
      final List<ModuleParagraph> paragraphs =
          cvData.readInfo!.opus!.content!.paragraphs!;
      for (var paragraph in paragraphs) {
        if (paragraph.paraType == 2) {
          for (var pic in paragraph.pic!.pics!) {
            picList.add(pic.url!);
          }
        }
      }
    }
    return picList;
  }

  List<String> extractDataSrc(String input) {
    final regex = RegExp(r'data-src="([^"]*)"');
    final matches = regex.allMatches(input);
    return matches.map((match) {
      final dataSrc = match.group(1)!;
      return dataSrc.startsWith('//') ? 'https:$dataSrc' : dataSrc;
    }).toList();
  }

  Widget _buildNonOpusContent(ReadDataModel cvData, List<String> imgList) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildStatsWidget(cvData),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildAuthorWidget(cvData),
        ),
        SelectionArea(
          child: HtmlWidget(
            htmlContent: cvData.readInfo!.content!,
            imgList: imgList,
          ),
        )
      ],
    );
  }

  Widget _buildStatsWidget(ReadDataModel cvData) {
    return Row(
      children: [
        StyledText(NumUtils.CustomStamp_str(
          timestamp: cvData.readInfo!.publishTime!,
          date: 'YY-MM-DD hh:mm',
          toInt: false,
        )),
        const SizedBox(width: 10),
        StyledText('${NumUtils.int2Num(cvData.readInfo!.stats!['view'])}浏览'),
        const StyledText(' · '),
        StyledText('${cvData.readInfo!.stats!['like']}点赞'),
      ],
    );
  }

  Widget _buildAuthorWidget(ReadDataModel cvData) {
    final Author author = cvData.readInfo!.author!;
    return Row(
      children: [
        InkWell(
          onTap: () {
            Get.toNamed('/member?mid=${author.mid}');
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(author.face!),
            radius: 20,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  author.name!,
                  style: TextStyle(
                    color: author.vip!.nicknameColor != null
                        ? Color(author.vip!.nicknameColor!)
                        : null,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Image.asset(
                  'assets/images/lv/lv${author.level}.png',
                  height: 11,
                ),
              ],
            ),
            Row(
              children: [
                StyledText('粉丝: ${NumUtils.int2Num(author.fans!)}'),
                const SizedBox(width: 10),
                StyledText(
                    '文章: ${NumUtils.int2Num(cvData.readInfo!.totalArtNum!)}'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: 100,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class StyledText extends StatelessWidget {
  final String text;

  const StyledText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
