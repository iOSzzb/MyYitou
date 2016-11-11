//
//  IPDetector.h
//  WhatIsMyIP
//
//  Created by ly on 14-2-24.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPDetector : NSObject

/**
 *  获取LAN网IP
 */
+ (void)getLANIPAddressWithCompletion:(void (^)(NSString *IPAddress))completion;

/**
 *  获取WAN网IP
 */
+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion;

@end
