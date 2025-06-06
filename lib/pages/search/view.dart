import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/pages/search/controller.dart';
import 'package:dilidili/pages/search/widgets/hot_keyword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

class _SearchPageState extends State<SearchPage> with RouteAware {
  final SSearchController _searchController = Get.put(SSearchController());
  late Future? _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _searchController.queryHotSearchList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SearchPage.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            // ignore: deprecated_member_use
            color: Theme.of(context).dividerColor.withOpacity(0.08),
            width: 1,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () => _searchController.submit(),
            icon: const Icon(CupertinoIcons.search, size: 22),
          ),
          const SizedBox(width: 10)
        ],
        title: Obx(
          () => TextField(
            autofocus: true,
            textAlignVertical: TextAlignVertical.center,
            focusNode: _searchController.searchFocusNode,
            controller: _searchController.controller.value,
            onChanged: (value) => _searchController.onChange(value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: _searchController.hintText,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 22,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onPressed: () => _searchController.onClear(),
              ),
            ),
            onSubmitted: (String value) => _searchController.submit(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _searchSuggest(),
            Visibility(
              visible: _searchController.enableHotKey,
              child: hotSearch(_searchController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchSuggest() {
    SSearchController ssCtr = _searchController;
    return Obx(
      () => ssCtr.searchSuggestList.isNotEmpty &&
              ssCtr.searchSuggestList.first.term != null &&
              ssCtr.controller.value.text != ''
          ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ssCtr.searchSuggestList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onTap: () => ssCtr
                      .onClickKeyword(ssCtr.searchSuggestList[index].term!),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 9, bottom: 9),
                    child: ssCtr.searchSuggestList[index].textRich,
                  ),
                );
              },
            )
          : const SizedBox(),
    );
  }

  Widget hotSearch(ctr) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 14, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '大家都在搜',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 34,
                  child: TextButton.icon(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(const EdgeInsets.only(
                          left: 10, top: 6, bottom: 6, right: 10)),
                    ),
                    onPressed: () => ctr.queryHotSearchList(),
                    icon: const Icon(Icons.refresh_outlined, size: 18),
                    label: const Text('刷新'),
                  ),
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, boxConstraints) {
              final double width = boxConstraints.maxWidth;
              return FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(
                        () => HotKeyword(
                          width: width,
                          // ignore: invalid_use_of_protected_member
                          hotSearchList: _searchController.hotSearchList.value,
                          onClick: (keyword) async {
                            _searchController.searchFocusNode.unfocus();
                            await Future.delayed(
                                const Duration(milliseconds: 150));
                            //跳转搜索
                            _searchController.onClickKeyword(keyword);
                          },
                        ),
                      );
                    } else {
                      return CustomScrollView(
                        slivers: [
                          HttpError(
                            errMsg: data['msg'],
                            fn: () => setState(() {}),
                          )
                        ],
                      );
                    }
                  } else {
                    if (_searchController.hotSearchList.isNotEmpty) {
                      return HotKeyword(
                        width: width,
                        hotSearchList: _searchController.hotSearchList,
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
