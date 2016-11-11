platform :ios, "7.0"
xcodeproj 'Yitou.xcodeproj'

#忽略掉podSDK的警告
inhibit_all_warnings!

#所有的网络请求使用
pod 'AFNetworking'
#, '~>2.x'

#弹出提示
pod 'SVProgressHUD'

#上拉加载下拉刷新
pod 'MJRefresh'

#照片浏览
pod 'MWPhotoBrowser'

#友盟统计 (不含IDFA)
pod 'UMengAnalytics-NO-IDFA'

#给新手标里面的进度条用的
pod 'MDRadialProgress'

pod 'XHHTextField' ,:git => 'https://github.com/Xiaohui666/XHHTextField.git'

#pod 'UMengSocial', '~> 4.3'

#----------for shareSDK
# 主模块(必须)
pod 'ShareSDK3'
# Mob 公共库(必须) 如果同时集成SMSSDK iOS2.0:可看此注意事项：http://bbs.mob.com/thread-20051-1-1.html
pod 'MOBFoundation'

# UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
pod 'ShareSDK3/ShareSDKUI'

# 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
pod 'ShareSDK3/ShareSDKPlatforms/QQ'
#pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
pod 'ShareSDK3/ShareSDKPlatforms/WeChat'

pod 'IQKeyboardManager'

target :Yitou, :exclusive => true do

end