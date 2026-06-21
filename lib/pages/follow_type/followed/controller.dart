import 'package:dilidili/http/user.dart';
import 'package:dilidili/pages/follow_type/controller.dart';

class FollowedController extends FollowTypeController {
  @override
  Future<Map<String, dynamic>> customGetData() {
    return UserHttp.followedUp(mid: mid, pn: page);
  }
}
