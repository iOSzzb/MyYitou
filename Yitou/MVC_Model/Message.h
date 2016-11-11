//
//  Message.h
//  Yitou
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

+ (Message *)createMessageWithData:(NSDictionary *)dataSource;

/**
 *  标记为已读
 */
- (void)markAsRead;

/**
 *  是否是已读的状态
 */
@property (assign)BOOL isRead;

/**
 *  消息标题
 */
@property (nonatomic,copy,readonly)NSString *msgTitle;

/**
 *  消息产生的时间
 */
@property (nonatomic,copy,readonly)NSString *msgTime;

/**
 *  消息详情
 */
@property (nonatomic,copy,readonly)NSString *msgContent;

@end
