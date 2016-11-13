//
//  HttpManager.h
//  Yitou
//
//  Created by Xiaohui on 15/7/28.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DescribleContents.h"

//#define SERVERURL_Yitou     @"http://116.205.5.38:8002/api/SzytouAPI/Api"
//#define SERVERURL_FILE      @"http://116.205.5.38:8002/api/SzytouApi.ashx"


//#if DEBUG
    //#define SERVERURL_Yitou     @"http://116.205.5.38:8002/api/SzytouAPI/Api"
    //#define SERVERURL_Yitou     @"http://apitest.haokoudai.com:9092/#"

    //#define SERVERURL_FILE      @"http://116.205.5.38:8002/api/SzytouApi.ashx"
//#else
    #define SERVERURL_Yitou     @"http://120.25.250.1:8001/api/SzytouAPI/Api"
    #define SERVERURL_FILE      @"http://120.25.250.1:8001/api/SzytouApi.ashx"
//#endif

typedef enum {
    rqSuccess   ,   //数据请求成功 解析成功  返回的reuslt_code为000
    rqError     ,   //数据请求成功 解析成功  但返回的reuslt_code不是000
    rqZero      ,   //用来判定网络是否请求成功的界限
    rqAnalyFail ,   //网络请求成功,数据解析失败(JSON转NSDictionary失败)
    rqFail          //数据请求失败
}RequestResult;

typedef void (^CommonDictBlock)(RequestResult rqCode,NSString *describle,NSDictionary *receiveData);

typedef void(^CommonStrBlock)(RequestResult rqCode,NSString *describle);

typedef void(^CommonCodeBlock)(RequestResult rqCode,NSString *describle,NSString *msgCode);

typedef void(^CommonArrayBlock)(RequestResult rqCode,NSArray *array,NSInteger sumCount,NSString *describle);//result结果 array数据 sumCount总条数

@interface HttpManager : NSObject

/**
 *  @author Zhuofutong, 16-03-25 16:03:28
 *
 *  MD5加密
 */
+ (NSString *) md5:(NSString *)str;


/**
 *   数据网络请求的出口 所有网络请求都调用这个方法
 *  @param para  请求参数
 */
+ (void)hmRequestWithPara:(NSDictionary *)para Block:(CommonDictBlock)block;


/**
 *  下载图片
 *
 *  @param urlStr 图片的URL
 */
+ (void)hmDownloadImageWithUrl:(NSString *)urlStr block :(CommonStrBlock)block;


/**
 *  活动签到接口
 */
+ (void)userMarkWithUsrID:(NSString *)userID Block:(CommonCodeBlock)block;


/**
 *  发送短信验证码
 */
+ (void)sendMsgcodeWithPhone:(NSString *)phoneNum Block:(CommonStrBlock)block;


/**
 *  检查用户名是否已经注册
 */
+ (void)checkUserName:(NSString *)userName Block:(CommonStrBlock)block;


/**
 *  检测手机号是否已被注册
 *
 *  @param phoneNum 手机号码
 */
+ (void)checkPhoneNum:(NSString *)phoneNum Block:(CommonStrBlock)block;


/**
 *  用户登录接口
 */
+ (void)loginWithUserName:(NSString *)userName password:(NSString*)pwd Block:(CommonStrBlock)block;


/**
 *  借款列表
 */
+ (void)getBorrowMoneyListWithPara:(NSDictionary *)para Block:(CommonArrayBlock)block;


/**
 *  获取账户资金变动明细
 *
 *  @param paraDict request里面的Data的内容
 */
+ (void)getMoneyRecordAtPage:(NSDictionary *)paraDict Block:(CommonArrayBlock)block;


/**
 *  获取用户的个人信息
 *
 *  @param userName 用户名
 *  @param pwd      密码
 */
+ (void)getUserInformationByUserName:(NSString *)userName pwd:(NSString *)pwd Block:(CommonDictBlock)block;


/**
 *  通过标的ID来获取标的详情
 *
 *  @param investID 标ID
 */
+ (void)getInvestDetailWithID:(NSString *)investID Block:(CommonDictBlock)block;


/**
 *  获取用户在汇付的账户信息
 *
 *  @param userName 用户名
 *  @param pwd      密码
 */
+ (void)getHFInformationWithUserName:(NSString *)userName pwd:(NSString *)pwd Block:(CommonDictBlock)block;


/**
 *  获取单个标的投标记录
 *
 *  @param page 页数
 *  @param block   用于得到结果后的回调
 */
+ (void)getInvestRecordListInPage:(NSInteger)page investID:(NSString *)investID Block:(CommonArrayBlock)block;

@end
