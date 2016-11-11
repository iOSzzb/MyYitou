//
//  LXHTextField.h
//  TeaMachine
//
//  Created by Xiaohui on 15/8/6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXHTextFieldDelegate <NSObject>

@optional

- (void)LXHTextFieldDidEndEdit:(NSInteger)tag;

@end

@interface LXHTextField : UIView<UITextFieldDelegate>

/**
 *  生成带图片和默认文字的UITextField   PS:主要用在注册&登录的框框
 *
 *  @param imgName icon图片的名称
 *  @param text    默认文字
 */
- (void)loadLXHTextFieldWithLeftImageName:(NSString *)imgName defaultText:(NSString *)text;

/**
 *  设置键盘的类型和textField的text长度
 *
 *  @param keyboardType 键盘类型
 *  @param length       长度  PS不限长度可设置大一些就可以了
 */
- (void)lxhTextFieldSetKeyboardType:(UIKeyboardType)keyboardType andLength:(NSInteger)length;

/**
 *  将键盘隐藏
 */
- (void)hideKeyboard;

/**
 *  隐藏输入的内容 输入密码的时候使用
 */
- (void)hideContent;


@property (nonatomic,copy,readwrite)NSString *text;

@property (assign,nonatomic)id <LXHTextFieldDelegate> delegate;

/**
 *  数据是否已经验证过了
 */
@property (assign,nonatomic)BOOL isValid;

@end