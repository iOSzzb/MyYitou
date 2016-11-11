//
//  AppDelegate.m
//  Yitou
//
//  Created by Xiaohui on 15/7/28.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "AppDelegate.h"
#import "LXHDefine.h"
#import "HomePage.h"
#import "InvestmentCtrl.h"
#import "UserCenterCtrl.h"
#import "DiscoverCtrl.h"
#import "LXHTimer.h"
#import "CLLockVC.h"
#import "JPUSHService.h"

#import <MobClick.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WXApi.h>

#define UMENG_APPKEY_COUNT  @"569478b1e0f55a30b0002d2b"
#define JPUSH_APPKEY        @"968793c0c445639e1f029e9f"
#define SHARESDK_APPKEY     @"f4d6e2bc6115"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    UITabBarController *tabbarCtrl;
    NSDate *bgDate;
}

- (UITabBarController *)loadNormalApplication{
    HomePage *homePage = [[HomePage alloc] initWithNibName:@"HomePage" bundle:nil];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homePage];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[IMAGENAMED(@"homePage") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:101 ];
    [homeNav.tabBarItem setSelectedImage:[IMAGENAMED(@"homePage_highlight") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    homeNav.tabBarController.tabBar.tintColor = [UIColor redColor];

    InvestmentCtrl *invest = [[InvestmentCtrl alloc]initWithNibName:@"InvestmentCtrl" bundle:nil];
    UINavigationController *investNav = [[UINavigationController alloc] initWithRootViewController:invest];
    investNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"投资" image:[IMAGENAMED(@"investment") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:102];
    [investNav.tabBarItem setSelectedImage:[IMAGENAMED(@"investment_highlight") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    DiscoverCtrl *discover = [[DiscoverCtrl alloc] initWithNibName:@"DiscoverCtrl" bundle:nil];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discover];
    discoverNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"发现" image:[IMAGENAMED(@"discover") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:103];
    [discoverNav.tabBarItem setSelectedImage:[IMAGENAMED(@"discover_highlight") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    UserCenterCtrl *usrCenter = [[UserCenterCtrl alloc] initWithNibName:@"UserCenterCtrl" bundle:nil];

    UINavigationController *usrNav = [[UINavigationController alloc] initWithRootViewController:usrCenter];
    usrNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[IMAGENAMED(@"myCenter") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:104];
    [usrNav.tabBarItem setSelectedImage:[IMAGENAMED(@"myCenter_highlight") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORWithRGB(14, 176, 240, 1)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORWithRGB(14, 176, 240, 1)} forState:UIControlStateSelected];

    tabbarCtrl = [[UITabBarController alloc]init];
    tabbarCtrl.viewControllers = @[homeNav,investNav,discoverNav,usrNav];
    return tabbarCtrl;
}

- (void)initSDK{

    [MobClick startWithAppkey:UMENG_APPKEY_COUNT reportPolicy:BATCH channelId:@"iOS"];
    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [SVProgressHUD setBackgroundColor:COLORWithRGB(1, 1, 1, 0.78)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];

    [ShareSDK registerApp:SHARESDK_APPKEY activePlatforms:@[@(SSDKPlatformTypeQQ),@(SSDKPlatformSubTypeWechatSession),
                                                            @(SSDKPlatformSubTypeWechatTimeline)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType){
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            default:
                break;
        }

    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType){
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx75464407ca80094e"
                                      appSecret:@"f24025b6679938f8e0a3c6c08897b1a4"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1104921185"
                                     appKey:@"bkZrtGBbX0xTTzzT"
                                   authType:SSDKAuthTypeBoth];
                break;
            default: break;
        }
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return YES;
}

- (void)checkFileComplete{
    if (!CHECKFileExist(IMAGE_FOLDER)){
        [[NSFileManager defaultManager] createDirectoryAtPath:IMAGE_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [application setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.window.rootViewController = [self loadNormalApplication];
    [self initSDK];
    [self checkFileComplete];
    [self registureNotification];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY
                          channel:@"iOS" apsForProduction:FOR_PRODUCT];
    [JPUSHService setLogOFF];

    [[LXHTimer shareTimerManager] reGetTimeWithBlock:^(NSInteger checkedResult) {
        NSLOG(@"获取服务器时间-->>%li",checkedResult);
    }];
    return YES;
}

- (void)registureNotification{
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {

}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
    [JPUSHService setTags:[NSSet setWithObjects:@"iOS", nil] aliasInbackground:@"iOS"];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLOG(@"%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"推送消息" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [tabbarCtrl presentViewController:alert animated:YES completion:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    bgDate = [NSDate date];
    [[LXHTimer shareTimerManager] applicationWillEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[LXHTimer shareTimerManager] applicationWillEnterForeground];
    NSInteger bgSecond = [[NSDate date] timeIntervalSinceDate:bgDate];
    if ([CLLockVC hasPwd]&&[UserModel shareUserManager].isLogin&&bgSecond > 30) {
        [CLLockVC showVerifyLockVCInVC:tabbarCtrl forgetPwdBlock:nil successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:0];
            if ([pwd length]==3){
                [[UserModel shareUserManager] logout];

            }
        }];
    }else if ([UserModel shareUserManager].isLogin&&bgSecond > 30){
        [[UserModel shareUserManager] logout];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
