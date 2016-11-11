//
//  HttpManager.m
//  Yitou
//
//  Created by Xiaohui on 15/7/28.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "HttpManager.h"

#import "Tender.h"
#import "MoneyRecord.h"
#import "UserModel.h"
#import <AFNetworking.h>
#import <MobClick.h>
#import "CLLockVC.h"

#import <CommonCrypto/CommonDigest.h>

#define CHECKSuccess(dict) STRCMP([dict objectForKey:@"result_code"], @"000")

@implementation HttpManager

+ (NSString *) md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    int strSize = (int)strlen(cStr);
    CC_MD5( cStr, strSize, result ); // This is the md5 call
    NSString *md5Code =  [NSString stringWithFormat:
                          @"%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]
                          ];
    md5Code = [md5Code substringToIndex:24];
    md5Code = [md5Code substringFromIndex:8];
    return md5Code;
}

+ (void)hmRequestWithPara:(NSDictionary *)para Block:(CommonDictBlock)block{

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    __block AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"SERVERURL_Yitou = %@",SERVERURL_Yitou);
    [manager POST:SERVERURL_Yitou parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLOG(@"");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (error ||dict == nil){
            block(rqAnalyFail,RQ_ANALYFAIL_DESC,dict);
            NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            NSLOG(@"analysize json fail with error \n\n %@",error);
            [MobClick event:@"102" label:str];
            manager = nil;
            return ;
        }//网络请求失败

        if (!CHECKSuccess(dict)){
            block(rqError,[dict objectForKey:@"result_desc"],dict);
            NSLOG(@"request with Exception ,\n\n-->para:%@ \n\n-->result:%@",para,dict);
            NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            [MobClick event:@"101" label:str];
            manager = nil;
            return;
        }//返回的result_code不是000
        block(rqSuccess,[dict objectForKey:@"result_desc"],dict);
        manager = nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLOG(@"Error request with para:%@",para);
        manager = nil;
        block(rqFail,RQ_FAIL_DESC,nil);
    }];
}

+ (void)hmDownloadImageWithUrl:(NSString *)urlStr block:(CommonStrBlock)block{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        return [NSURL fileURLWithPath:[IMAGE_FOLDER stringByAppendingPathComponent:[urlStr lastPathComponent]]];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLOG(@"image download");
        if (!error)
            block(rqSuccess,urlStr);
        else
            block(rqFail,urlStr);
    }];
    [downloadTask resume];
}

+ (void)checkUserName:(NSString *)userName Block:(CommonStrBlock)block{

    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"isaccount" forKey:@"cmdid"];
    [paraDict setObject:@{@"user_name":userName,@"client_id":KEY_CLIENTID} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        block(rqCode,describle);
    }];
}

+ (void)checkPhoneNum:(NSString *)phoneNum Block:(CommonStrBlock)block{
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"ismoble" forKey:@"cmdid"];
    [paraDict setObject:@{@"mobile":phoneNum,@"client_id":KEY_CLIENTID} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        block(rqCode,describle);
    }];
}

+ (void)sendMsgcodeWithPhone:(NSString *)phoneNum Block:(CommonStrBlock)block{
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"register_code" forKey:@"cmdid"];
    [paraDict setObject:@{@"mobile":phoneNum,@"client_id":KEY_CLIENTID} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        NSLOG(@"短信验证码%@",[receiveData objectForKey:@"sms_code"]);
        if (rqCode == rqSuccess)
            block(rqCode,[receiveData objectForKey:@"sms_code"]);
        else
            block(rqCode,describle);
    }];
}

+ (void)loginWithUserName:(NSString *)userName password:(NSString *)pwd Block:(CommonStrBlock)block{
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"login" forKey:@"cmdid"];
    [paraDict setObject:@{@"user_name":userName,@"password":pwd,@"client_id":KEY_CLIENTID} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        UserModel *userModel = [UserModel shareUserManager];
        if (rqCode != rqSuccess){
            NSLOG(@"登录失败  --> %@",describle);
            block(rqCode,describle);
            return ;
        }
        NSString *oldName = USERDefineGet(KEY_USER_NAME);
        if (STRCMP(oldName, userName))
            [CLLockVC cleanPwd];
        userModel.userID = [receiveData objectForKey:@"userid"];
        [userModel loginSuccessWithName:userName pwd:pwd];
        USERDefineSet(@"1", KEY_USER_isLogin);
        if (userModel.hfUserName == nil){
            [HttpManager getHFInformationWithUserName:userModel.userName pwd:userModel.password Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

            }];
            [HttpManager getUserInformationByUserName:userModel.userName pwd:userModel.password Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

            }];
        }
        block(rqCode,describle);
    }];
}

+ (void)getBorrowMoneyListWithPara:(NSDictionary *)para Block:(CommonArrayBlock)block{
    NSMutableDictionary *paras = [[NSMutableDictionary alloc] initWithDictionary:para];
    [paras setObject:KEY_CLIENTID forKey:@"client_id"];
    NSDictionary *dict  = @{@"cmdid":@"borrowinglist",@"data":paras};
    [HttpManager hmRequestWithPara:dict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess){
            block(rqCode,nil,0,describle);
            return ;
        }
        block(rqSuccess,[HttpManager analysizeBorrowListWithDict:receiveData],[[receiveData objectForKey:@"rowcounts"] integerValue],describle);
    }];
}

+ (NSArray *)analysizeBorrowListWithDict:(NSDictionary *)dict{
    NSArray *ary = [dict objectForKey:@"data"];
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *tenDict in ary){
        Tender *tender = [[Tender alloc] init];
        [tender createTenderModel:tenDict];
        [array addObject:tender];
    }
    return array;
}

+ (void)getMoneyRecordAtPage:(NSDictionary *)paraDict Block:(CommonArrayBlock)block{
    NSMutableDictionary *paraDict_ = [NSMutableDictionary new];
    [paraDict_ setObject:@"usertradingrecords" forKey:@"cmdid"];
    [paraDict_ setObject:paraDict forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict_ Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess){
            block(rqCode,nil,0,describle);
            return ;
        }
        NSLOG(@"%@",receiveData);
        block(0,[HttpManager analysizeMoneyRecordWithDict:receiveData],[[receiveData objectForKey:@"rowcounts"] integerValue],describle);
    }];
}

+ (NSArray *)analysizeMoneyRecordWithDict:(NSDictionary *)dict{
    NSMutableArray *ary = [NSMutableArray new];
    for (NSDictionary *obj in [dict objectForKey:@"data"]){
        MoneyRecord *record = [MoneyRecord new];
        record.money = [obj objectForKey:@"change"];
        record.date = [obj objectForKey:@"recordtime"];
        record.desc = [obj objectForKey:@"borrow_title"];
        record.orignData = obj;
        record.unit = [obj objectForKey:@"type_unit"];
        record.types = [obj objectForKey:@"type_cn"];
        record.balance = [obj objectForKey:@"balance"];
        [ary addObject:record];
    }
    return ary;
}

+ (void)getUserInformationByUserName:(NSString *)userName pwd:(NSString *)pwd Block:(CommonDictBlock)block{
    NSMutableDictionary *paraDict_ = [NSMutableDictionary new];
    [paraDict_ setObject:@"useraccountinfo" forKey:@"cmdid"];
    [paraDict_ setObject:@{@"client_id":KEY_CLIENTID,@"user_name":userName,@"password":pwd} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict_ Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess){
            block(2,describle,0);
            return ;
        }
        UserModel *usrModel = [UserModel shareUserManager];
        [usrModel getUserInfoWithResult:[receiveData objectForKey:@"data"]];
        block(0,describle,[receiveData objectForKey:@"data"]);
    }];
}

+(void)getInvestDetailWithID:(NSString *)investID Block:(CommonDictBlock)block{
    NSMutableDictionary *paraDict_ = [NSMutableDictionary new];
    [paraDict_ setObject:@"productinfo" forKey:@"cmdid"];
    [paraDict_ setObject:@{@"client_id":KEY_CLIENTID,@"borrow_id":investID} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict_ Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess){
            block(2,describle,receiveData);
            return ;
        }
        block(rqCode,describle,[receiveData objectForKey:@"data"]);
    }];
}

+ (void)userMarkWithUsrID:(NSString *)userID Block:(CommonCodeBlock)block{
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"signin_prize" forKey:@"cmdid"];
    [paraDict setObject:@{@"user_id":userID,@"client_id":KEY_CLIENTID} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess){
            block(rqCode,describle,nil);
            return ;
        }
        block(0,describle,[receiveData objectForKey:@"msg"]);
    }];
}

+ (void)getInvestRecordListInPage:(NSInteger)page investID:(NSString *)investID Block:(CommonArrayBlock)block {
    NSString *pageStr = [NSString stringWithFormat:@"%tu",page];
    NSDictionary *dictTemp = @{@"pageindex":pageStr,@"pagesize":@"20",@"borrow_id":investID,@"client_id":KEY_CLIENTID};
    NSDictionary *para = @{@"cmdid":@"userprobidlist",@"data":dictTemp};
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        NSLog(@"receiveData = %@",receiveData);
        if (rqCode != rqSuccess) {
            block(rqCode,nil,0,describle);
            return ;
        }
        block(rqCode,[receiveData objectForKey:@"data"],[[receiveData objectForKey:@"rowcounts"] integerValue],describle);
    }];
}

+ (void)getHFInformationWithUserName:(NSString *)userName pwd:(NSString *)pwd Block:(CommonDictBlock)block{
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"chinapnr_account" forKey:@"cmdid"];
    [paraDict setObject:@{@"user_name":userName,@"password":pwd,@"client_id":KEY_CLIENTID} forKey:@"data"];
    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        [[UserModel shareUserManager] getHFUserInfoWithResult:[receiveData objectForKey:@"data"]];
        block(rqCode,describle,receiveData);
    }];
}

@end
