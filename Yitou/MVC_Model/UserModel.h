//
//  UserModel.h
//  Analysize
//
//  Created by Xiaohui on 15/7/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  登录的用户的Model
 */
@interface UserModel : NSObject

+ (UserModel *)shareUserManager;

/**
 *  将string转成ab**fg的形式 例如yuanyuan1 返回yu**n1
 */
+ (NSString *)mosaicString:(NSString *)orignString;

/**
 *  修改手机号后使用
 */
- (void)userDidChangeMobile:(NSString *)mobile;

/**
 *  登录成功后调用一次
 */
- (void)loginSuccessWithName:(NSString *)loginName pwd:(NSString *)pwd;

/**
 *  将用户资料导入UserModel
 */
- (void)getUserInfoWithResult:(NSDictionary *)userInfo;

/**
 *  将用户的汇付信息导入UserModel
 */
- (void)getHFUserInfoWithResult:(NSDictionary *)userInfo;

/**
 *  登出
 */
- (void)logout;

/**
 *  邀请好友的链接
 */
@property (nonatomic,copy)NSString *shareUrl;

/**
 *  是否已经登陆了
 */
@property (assign,readonly)BOOL isLogin;

/**
 *  绑定的手机号
 */
@property (nonatomic,copy,readonly)NSString *mobile;

/**
 *  在汇付的user_name
 */
@property (nonatomic,copy,readonly)NSString *hfUserName;

/**
 *  在汇付的登录账户 PS:ykn+username
 */
@property (nonatomic,copy,readonly)NSString *hfAccount;

/**
 *  在汇付实名认证的个人姓名
 */
@property (nonatomic,copy,readonly)NSString *hfRealName;

/**
 *  用户名
 */
@property (nonatomic,copy,readonly)NSString *userName;

/**
 *  登录密码
 */
@property (nonatomic,copy,readonly)NSString *password;

@property (nonatomic,copy)NSString *userID;

@property (nonatomic,copy)NSString *userEmail;

/**
 *  用户头像的URL
 */
@property (nonatomic,copy)NSString *userHead;

/**
 *  用户的余额
 */
@property (nonatomic,copy,readonly)NSString *balance;

/**
 *  当日收益 PS:不包含本金
 */
@property (nonatomic,copy,readonly)NSString *earnCountDay;

/**
 *  账户体验金 PS:体验金投资后只能得到体验金赚取的收益
 */
@property (nonatomic,copy,readonly)NSString *expMoney;

/**
 *  账户资产 由:余额+冻结+待收 组成
 */
@property (nonatomic,copy,readonly)NSString *sumMoney;

/**
 *  待收利息
 */
@property (nonatomic,copy,readonly)NSString *waitInterest;

/**
 *  待收本金
 */
@property (nonatomic,copy,readonly)NSString *waitPrin;

/**
 *  冻结的资金
 */
@property (nonatomic,copy,readonly)NSString *lockMoney;

/**
 *  已经收取的利息
 */
@property (nonatomic,copy,readonly)NSString *didEarn;

@end
