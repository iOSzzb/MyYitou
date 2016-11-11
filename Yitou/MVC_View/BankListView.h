//
//  BankListView.h
//  Yitou
//
//  Created by Xiaohui on 15/8/20.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankBtn.h"

@protocol BankListDelegate <NSObject>

@optional

- (void)bankListChangedBank;

- (void)bankListChangeHeight;

@end

@interface BankListView : UIView

@property (assign)BOOL showFastCard;

@property (nonatomic,copy)BankBtn *bank;

@property (assign)float viewHeight;

@property (assign,nonatomic)id <BankListDelegate> delegate;

- (void)loadBankList;

@end
