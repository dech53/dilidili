import 'package:dilidili/pages/about/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final AboutController _aboutController = Get.put(AboutController());
  @override
  Widget build(BuildContext context) {
    TextStyle subTitleStyle =
        TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline);
    return Scaffold(
      appBar: AppBar(
        title: Text('关于', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo/ios.png',
              width: 150,
            ),
            Text(
              'Dilidili',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Obx(
              () => Badge(
                isLabelVisible: _aboutController.isLoading.value
                    ? false
                    : _aboutController.isUpdate.value,
                label: const Text('New'),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: FilledButton.tonal(
                    onPressed: () {
                      _aboutController.githubUrl();
                    },
                    child: Text(
                      'V${_aboutController.currentVersion.value}',
                      style: subTitleStyle.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                _aboutController.githubUrl();
              },
              title: const Text('开源地址'),
              trailing: Text(
                'github.com/dech53/dilidili',
                style: subTitleStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
