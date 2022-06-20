

import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SettingSize on num {
  double getHeight() {
    return ScreenUtil().setHeight(this);
  }

  double getWidth() {
    return ScreenUtil().setWidth(this);
  }

  double getFontSize() {
    return ScreenUtil().setSp(this);
  }
}