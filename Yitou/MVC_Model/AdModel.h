//
//  AdModel.h
//  Yitou
//
//  Created by Xiaohui on 15/8/3.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject

- (void)setModel:(NSDictionary *)adDict;

/**
 *  点击广告跳转到的URL
 */
@property (nonatomic,copy)NSString *adUrl;

/**
 *  广告在本地的URL
 */
@property (nonatomic,copy)NSString *adImgPath;

/**
 *  广告标题
 */
@property (nonatomic,copy)NSString *adTitle;

/**
 *  广告图片在服务器的URL
 */
@property (nonatomic,copy)NSString *adImgUrl;

/**
 *  图片状态 0:未知 1:未下载 2:正在下载 3:已下载
 */
@property (assign)NSInteger imgStatus;

/**
 *  缩略图
 */
@property(nonatomic,copy)UIImage *thum;

@end
