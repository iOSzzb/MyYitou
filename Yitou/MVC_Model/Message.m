//
//  Message.m
//  Yitou
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "Message.h"

@implementation Message{
    NSString *msgID;
}

@synthesize msgTitle;
@synthesize msgContent;
@synthesize msgTime;
@synthesize isRead;

+ (Message *)createMessageWithData:(NSDictionary *)dataSource{
    Message *message = [Message new];
    [message loadMessageProperty:dataSource];
    return message;
}

- (void)loadMessageProperty:(NSDictionary *)dataSource{
    msgTime= [dataSource objectForKey:@"addtime"];
    msgTitle = [dataSource objectForKey:@"title"];
    msgContent = [dataSource objectForKey:@"des"];
    isRead = STRCMP(@"1", [dataSource objectForKey:@"new_state"]);
    msgID = [dataSource objectForKey:@"id"];
}

- (void)markAsRead{
    if (isRead)
        return;
    isRead = YES;
    UserModel *usrModel = [UserModel shareUserManager];
    NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password,@"id":msgID};
    para = @{@"cmdid":@"set_letter_state",@"data":para};
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

    }];
}

@end
