//
//  LXHAdView.h
//  Yitou
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AdClickBlock)(NSInteger indx);

@interface LXHAdView : UIView<UIScrollViewDelegate>

/**
 *   显示默认缩略图 defult NO  在showThum&&adModel.thum != nil的时候会显示缩略图
 */
@property (nonatomic,assign)BOOL showThum;

/**
 *  源数据  数据是由AdModel组成的Array
 */
@property (nonatomic,copy) NSArray *dataSource;

@property (nonatomic,copy)UIImage *defaultImage;

- (void)loadAdView:(AdClickBlock)block;

@end
