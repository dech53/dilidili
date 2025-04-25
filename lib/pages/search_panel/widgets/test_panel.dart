import 'package:dilidili/common/widgets/http_error.dart';
import 'package:flutter/material.dart';

class TestPanel extends StatelessWidget {
  const TestPanel({super.key, this.list});
  final List? list;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 36),
          child: list!.isNotEmpty
              ? CustomScrollView(
                  slivers: [
                    HttpError(
                      errMsg: '存在数据',
                      isShowBtn: false,
                      fn: () => {},
                    )
                  ],
                )
              : CustomScrollView(
                  slivers: [
                    HttpError(
                      errMsg: '没有数据',
                      isShowBtn: false,
                      fn: () => {},
                    )
                  ],
                ),
        )
      ],
    );
  }
}
