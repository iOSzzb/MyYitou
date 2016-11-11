//
//  InputMoneyText.h
//  Yitou
//
//  Created by Xiaohui on 15/8/21.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputTextDelegate <NSObject>

@optional

- (void)InputTextChange;

- (void)InputTextEndEdit;

- (void)InputTextStartEdit;

@end

@interface InputMoneyText : UIView<UITextFieldDelegate>

- (void)loadTextField;

- (void)forbidPoint;

- (void)shouldHideKeyBoard;

@property (nonatomic,copy)NSString *text;

@property (assign)float inputMax;

@property (assign,nonatomic)id <InputTextDelegate> delegate;



@end
