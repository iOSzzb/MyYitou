//
//  MineTopView.h
//  Yitou
//
//  Created by Xiaohui on 15/8/4.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTopView : UIView

typedef void(^TouchIndexBlock)(int index);

- (void)loadAllViewWithBlock:(TouchIndexBlock)blocks;

- (void)loadTopViewInfo;

- (void)loadUserHead:(NSString *)imgPath;

@property (assign)CGRect headFrame;

@end
