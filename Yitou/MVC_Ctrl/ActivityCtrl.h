//
//  ActivityCtrl.h
//  Yitou
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCtrl : UIViewController

@property (nonatomic,copy)UIScrollView *scrollview;

@property (nonatomic,copy)UIImage *image;

@property (assign)float imgHeight;

- (void)clickLoginButton;

- (void)clickRegisterButton;

@end
