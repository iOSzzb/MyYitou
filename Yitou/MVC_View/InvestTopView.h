//
//  InvestTopView.h
//  Yitou
//
//  Created by Xiaohui on 15/8/10.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INVESTTOPHeight

@protocol InvestTopViewDelegate <NSObject>

@required

- (void)topViewDidClicked;

@end

@interface InvestTopView : UIView

@property (assign)NSInteger lastIndx;

@property (assign)NSInteger status;

@property (nonatomic,assign)id<InvestTopViewDelegate> delegate;

- (void)loadTopView;

@end
