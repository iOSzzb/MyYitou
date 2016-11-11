//
//  GuideCtrl.h
//  Yitou
//
//  Created by mac on 15/11/26.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GuideBlock)(NSInteger result);

@interface GuideCtrl : UIViewController

- (void)guideCompleteWithBlock:(GuideBlock)block;

@end
