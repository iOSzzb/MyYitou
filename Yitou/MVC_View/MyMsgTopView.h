//
//  MyMsgTopView.h
//  Yitou
//
//  Created by mac on 16/1/28.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EventBlock)(NSInteger indx);

@interface MyMsgTopView : UIView


- (instancetype)initWithFrame:(CGRect)frame block:(EventBlock)callBack;

@end
