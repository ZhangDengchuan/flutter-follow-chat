import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow/bottomNavigationBar.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/helper/memberHelper.dart';
import 'package:follow/helper/noticeHelper.dart';
import 'package:follow/utils/messageUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/utils/sqlLiteUtil.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrate/vibrate.dart';

class CommonUtil {
  static OneContext get oneContext => _getContext();

  /// 获取context
  static OneContext _getContext() {
    return OneContext();
  }

  /// 震动
  static vibrate() async {
    if (await Vibrate.canVibrate) Vibrate.vibrateWithPauses([Duration(milliseconds: 500)]);
  }

  /// 初始化数据
  /// 每次进APP的时候在入口处调用
  Future<bool> initSystem(BuildContext context) async {
    MemberHelper memberHelper = new MemberHelper();
    return memberHelper.getMemberInfoFromLocal().then((value) async {
      if (value != null) {
        memberHelper.cacheMemberInfoToRedux(value);
        await SqlLiteHelper().initSqlLite();
        // 初始化通知
        NoticeHelper().refreshNotice();
        FriendHelper().cacheToRedux();
        // 初始化好友通知
        FriendHelper().getFriendList();
        MessageUtil.cacheToRedux();
        RouterUtil.replace(context, BottomNavigationBarPage());

        FriendHelper().cacheBriefMemberInfoListToRedux();
      }
      return value == null ? false : true;
    });
  }

  /// 等待组件渲染完成回调
  static whenRenderEnd(Function(Duration duration) func) {
    WidgetsBinding.instance.addPostFrameCallback(func);
  }

  static closeKeyBord(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// 获取持久化储存对象
  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  /// 处理消息
  static noticeTempleHandle(EntityNoticeTemple temple) async {
    switch (temple.type) {
      case 0:
        // 添加好友
        ModalUtil().ackFriendRequest(temple);
        break;
      case 1:
        // 发送消息过来了
        MessageUtil.handleSocketMsg(temple);
        break;
      case 2:
        // 自己发送的消息 然后后端确认已经发送
        MessageUtil.handleSocketMsgAck(temple);
        break;
      case 3:
        MessageUtil().handleFriendRequestAck(temple);
        break;
      //  被挤下线
      case 4:
        ModalUtil.isSignOut();
        break;
      default:
        break;
    }
  }

  static String randomString([length = 32]) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    int strlenght = length;

    /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < strlenght; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }
}
