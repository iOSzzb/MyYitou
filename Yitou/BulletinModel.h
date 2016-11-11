//
//  BulletinModel.h
//  Yitou
//
//  Created by imac on 16/1/30.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BulletinModel : NSObject

/**
 *  id
 */
@property (nonatomic,copy) NSString *idStr;

/**
 *  是否已读
 */
@property (nonatomic,copy) NSString *isState;

/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;

/**
 *  日期
 */
@property (nonatomic,copy) NSString *timeStr;

/**
 *  内容
 */
@property (nonatomic,copy) NSString *content;

@end
