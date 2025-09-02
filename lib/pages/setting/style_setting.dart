import 'package:dilidili/common/theme_type.dart';
import 'package:dilidili/pages/setting/controller.dart';
import 'package:dilidili/pages/setting/pages/color_select.dart';
import 'package:dilidili/pages/setting/widgets/slide_dialog.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class StyleSetting extends StatefulWidget {
  const StyleSetting({super.key});

  @override
  State<StyleSetting> createState() => _StyleSettingState();
}

class _StyleSettingState extends State<StyleSetting> {
  final SettingController settingController = Get.put(SettingController());
  final ColorSelectController colorSelectController =
      Get.put(ColorSelectController());
  Box setting = SPStorage.setting;
  late int picQuality;
  late ThemeType _tempThemeValue;
  late dynamic defaultCustomRows;
  @override
  void initState() {
    super.initState();
    picQuality = setting.get(SettingBoxKey.defaultPicQa, defaultValue: 10);
    _tempThemeValue = settingController.themeType.value;
    defaultCustomRows = setting.get(SettingBoxKey.customRows, defaultValue: 2);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!;
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          '外观设置',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            dense: false,
            onTap: () async {
              double? result = await showDialog(
                context: context,
                builder: (context) {
                  return SlideDialog<double>(
                    title: 'Toast不透明度',
                    value: settingController.toastOpacity.value,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                  );
                },
              );
              if (result != null) {
                settingController.toastOpacity.value = result;
                SmartDialog.showToast('设置成功');
                setting.put(SettingBoxKey.defaultToastOp, result);
              }
            },
            title: Text('Toast不透明度', style: titleStyle),
            subtitle: Text('自定义Toast不透明度', style: subTitleStyle),
          ),
          ListTile(
            dense: false,
            onTap: () => Get.toNamed('/colorSetting'),
            title: Text('应用主题', style: titleStyle),
            subtitle: Obx(() => Text(
                '当前主题：${colorSelectController.type.value == 0 ? '动态取色' : '指定颜色'}',
                style: subTitleStyle)),
          ),
        ],
      ),
    );
  }
}
