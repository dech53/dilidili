import 'package:dilidili/pages/webview/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final WebviewController _webviewController = Get.put(WebviewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          _webviewController.pageTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          const SizedBox(
            width: 4,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh_outlined,
                color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(
            () => AnimatedContainer(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 350),
              height: _webviewController.loadShow.value ? 4 : 0,
              child: LinearProgressIndicator(
                key: ValueKey(_webviewController.loadProgress),
                value: _webviewController.loadProgress / 100,
              ),
            ),
          ),
          Expanded(
            child: WebViewWidget(controller: _webviewController.controller),
          )
        ],
      ),
    );
  }
}
