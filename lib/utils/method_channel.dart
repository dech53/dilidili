import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ClipboardUtils {
  static const _channel = MethodChannel('app.clipboard');
  static Future<void> copyImage(Uint8List imageData) async {
    try {
      await _channel.invokeMethod('copyImage', {'imageData': imageData});
      SmartDialog.showToast('图片已复制到剪贴板');
    } catch (e) {
      SmartDialog.showToast('复制图片失败: $e');
    }
  }
}

void onCopyImg(String imgUrl) async {
    try {
      SmartDialog.showLoading(msg: '复制中...');
      final response = await Dio()
          .get(imgUrl, options: Options(responseType: ResponseType.bytes));
      Uint8List bytes = Uint8List.fromList(response.data);
      await ClipboardUtils.copyImage(bytes);
      SmartDialog.dismiss();
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showNotify(msg: e.toString(), notifyType: NotifyType.error);
    }
  }