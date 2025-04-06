import 'package:dilidili/pages/user/user_page_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserPageViewModel _viewModel = UserPageViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchLoginCode();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: _getBodyUI(),
      ),
    );
  }

  //后续通过api获取二维码链接
  Widget _getBodyUI() {
    return Consumer<UserPageViewModel>(
      builder: (context, ref, child) {
        final qrCode = _viewModel.qrCode;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_viewModel.hasUser)
                    Text(_viewModel.ID!)
                  else if (qrCode?.url != null && qrCode!.url.isNotEmpty)
                    QrImageView(
                      data: qrCode.url,
                      version: QrVersions.auto,
                      size: 250.r,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
