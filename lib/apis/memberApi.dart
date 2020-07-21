import 'package:follow/entity/apis/entityMemberApi.dart';
import 'package:follow/utils/requestUtils.dart';

class MemberApi {
  //gender

  Future<bool> userRegister(String account, String pwd, String avatar, String nickName, int gender) {
    return RequestHelper.request("/api/Member/register", RequestMethod.POST,
            data: {"account": account, "pwd": pwd, "avatar": avatar, "nickName": nickName, "gender": gender}, tips: true, showLoading: true)
        .then((value) {
      return value.data.success;
    });
  }

  /// 用户登录
  Future<EntityMemberInfo> userLogin(String account, String pwd) {
    return RequestHelper.request("/api/Member/login", RequestMethod.GET, data: {"account": account, "pwd": pwd}, errorTips: true, showLoading: true).then((value) {
      if (value.data.success) {
        return EntityMemberInfo.fromJson(value.data.data);
      } else {
        return null;
      }
    });
  }

  Future<bool> settingNickName(String nickName) {
    return RequestHelper.request("/api/Member/nickname", RequestMethod.PUT, data: {"nickName": nickName}, errorTips: true, showLoading: true).then((value) {
      return value.data.success;
    });
  }

  // 修改微信号
  Future<bool> settingFoolowId(String followId) {
    return RequestHelper.request(
      "/api/Member/follow/id",
      RequestMethod.PUT,
      data: {"followId": followId},
      errorTips: true,
      showLoading: true,
    ).then((value) {
      return value.data.success;
    });
  }

  Future<bool> settingGender(int gender) {
    return RequestHelper.request("/api/Member/gender", RequestMethod.PUT, data: {"gender": gender}, errorTips: true, showLoading: true).then((value) {
      return value.data.success;
    });
  }

  Future<bool> settingSignature(String signature) {
    return RequestHelper.request("/api/Member/signature", RequestMethod.PUT, data: {"signature": signature}, errorTips: true, showLoading: true).then((value) {
      return value.data.success;
    });
  }

  /// 设置头像
  Future<bool> settingAvatar(String avatar) {
    return RequestHelper.request("/api/Member/avatar", RequestMethod.PUT, data: {"avatar": avatar}, errorTips: true).then((value) {
      return value.data.success;
    });
  }

  /// 设置封面
  Future<bool> settingCover(String cover) {
    return RequestHelper.request("/api/Member/cover", RequestMethod.PUT, data: {"cover": cover}, errorTips: true).then((value) {
      return value.data.success;
    });
  }

  /// 获取用户信息
  Future<EntityMemberInfo> getMemberInfo() {
    return RequestHelper.request("/api/Member/info", RequestMethod.GET, errorTips: true, showLoading: true).then((value) {
      if (value.data.success) {
        return EntityMemberInfo.fromJson(value.data.data);
      } else {
        return null;
      }
    });
  }

  /// 上传头像
  Future<String> uploadImageByBase64(String base64, double width, double height) {
    return RequestHelper.request("/api/Member/base64", RequestMethod.POST,
            data: {
              "base64": base64,
              "width": width,
              "height": height,
            },
            errorTips: true,
            showLoading: true)
        .then((value) {
      if (value.data.success) {
        return value.data.data;
      } else {
        return null;
      }
    });
  }
}
