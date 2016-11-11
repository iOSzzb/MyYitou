//
//  UserModel.m
//  Analysize
//
//  Created by Xiaohui on 15/7/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "UserModel.h"
#import "LXHDefine.h"
#import <MobClick.h>
#import <UIImageView+AFNetworking.h>

#define KEY_UserName    @"UserName_"
#define KEY_IsLogin     @"isLogin"
#define KEY_Password    @"Password"
#define KEY_UserCustID  @"UserCustID"

@implementation UserModel{
    BOOL isDownload;
    UIImageView *imgv;
}

+ (UserModel *)shareUserManager{
    static UserModel *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[UserModel alloc]init];
        [userModel initLoginInformation];
    });
    return userModel;
}
    
- (void)getUserInfoWithResult:(NSDictionary *)userInfo{

    _balance = [userInfo objectForKey:@"balance"];
    _waitPrin = [userInfo objectForKey:@"sum_w_principal"];
    _waitInterest = [userInfo objectForKey:@"sum_w_interest"];
    _expMoney = [userInfo objectForKey:@"experience_money"];
    _didEarn = [userInfo objectForKey:@"sum_y_interest"];
    _earnCountDay = [userInfo objectForKey:@"now_income"];
    _userEmail = [userInfo objectForKey:@"email"];
    _mobile = [userInfo objectForKey:@"mobile"];
    _userName = [userInfo objectForKey:@"username"];
    _userHead = [userInfo objectForKey:@"head_img"];
    _sumMoney = [userInfo objectForKey:@"sum_money"];

    USERDefineSet(_userHead, KEY_USER_HEAD);

    if (STRCMP(_expMoney, @"")){
        _expMoney = @"0.00";
    }
    [self downloadUserHead];
}

- (void)getHFUserInfoWithResult:(NSDictionary *)userInfo{
    _hfAccount = [userInfo objectForKey:@"usr_account_name"];
    _hfRealName = [userInfo objectForKey:@"usr_name"];
    _hfUserName = [userInfo objectForKey:@"user_name"];
}

- (void)logout{
    _isLogin = NO;
    _balance = @"0.00";
    _waitPrin = @"0.00";
    _waitInterest = @"0.00";
    _expMoney = @"0.00";
    _didEarn = @"0.00";
    _earnCountDay = @"0.00";
    _userEmail = @"0.00";
    _mobile = @"";
    _userName = @"";
    _userHead = @"";
    USERDefineSet(@"0", KEY_USER_isLogin);
    NSLOG(@"\n\n\n\n注意  退出登陆了一次!!!\n\n\n");
}

- (void)downloadUserHead{
    if (isDownload||[_userHead length]<10||STRCMP(@"http://api.szytou.com", _userHead))
        return;
    NSString *imgPath = NSHomeDirectory();
    imgPath = [imgPath stringByAppendingPathComponent:@"Documents"];
    imgPath = [imgPath stringByAppendingPathComponent:[_userHead lastPathComponent]];
    if (CHECKFileExist(imgPath)){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didDownloadUserHead" object:imgPath];
        return;
    }
    isDownload = YES;
    NSLOG(@"开始下载");
    imgv = [[UIImageView alloc] init];
    NSURL *url = [NSURL URLWithString:_userHead];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [imgv setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

        [UIImagePNGRepresentation(image) writeToFile:imgPath atomically:YES];
        isDownload = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didDownloadUserHead" object:imgPath];
        NSLOG(@"下载头像完成");
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLOG(@"下载头像失败");
        [MobClick event:@"100" label:[UserModel shareUserManager].userHead];
        isDownload = NO;
    }];
}

- (void)loginSuccessWithName:(NSString *)loginName pwd:(NSString *)pwd{

    USERDefineSet(loginName, KEY_LOGIN_NAME);
    USERDefineSet(pwd, KEY_LOGIN_PWD);
    USERDefineSet(@"1", KEY_USER_isLogin);

    _isLogin = YES;
    _userName = loginName;
    _password = pwd;
}

- (void)initLoginInformation{
    isDownload = NO;
    _userName = USERDefineGet(KEY_LOGIN_NAME);
    _password = USERDefineGet(KEY_LOGIN_PWD);
    _isLogin = NO;
    _balance = @"0.00";
    _waitPrin = @"0.00";
    _waitInterest = @"0.00";
    _expMoney = @"0.00";
    _didEarn = @"0.00";
    _earnCountDay = @"0.00";
    _userEmail = @"0.00";
    _mobile = @"";
    if (_userName == nil)
        _userName = @"";
    _userHead = @"";
    if (_password == nil)
        _password = @"";
}

- (void)userDidChangeMobile:(NSString *)mobile{
    _mobile = mobile;
    if (CHECKMobile(_userName))
        _userName = mobile;
}

+ (NSString *)mosaicString:(NSString *)orignString{
    if ([orignString length] > 4){
        return [NSString stringWithFormat:@"%@**%@",[orignString substringToIndex:2],[orignString substringFromIndex:[orignString length] - 2]];
    }
    if ([orignString length]<3)
        return orignString;
    return [NSString stringWithFormat:@"%@***",[orignString substringToIndex:2]];
}

@end
