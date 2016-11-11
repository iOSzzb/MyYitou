//
//  XHTextField.h
//  XHTextFieldDemo
//
//  Created by Xiaohui on 16/1/9.
//  Copyright © 2016年 xiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHHTextFieldDelegate <NSObject>

@optional

- (BOOL)xhhTextFieldShouldBeginEditing:(id)textField;
- (void)xhhTextFieldDidBeginEditing:(id)textField;
- (BOOL)xhhTextFieldShouldEndEditing:(id)textField;
- (void)xhhTextFieldDidEndEditing:(id)textField;

- (BOOL)xhhTextField:(id)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)xhhTextFieldShouldClear:(id)textField;
- (BOOL)xhhTextFieldShouldReturn:(id)textField;

@end

/**
 这是一个UIImageView+UITextField  
 */
@interface XHHTextField : UIView<UITextFieldDelegate>


/**
 *  唯一的初始化方法
 *  the only way to init XHHTextField
 *
 */
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

/**
 *  加载左边的小Logo 可以在初始化的时候设置 也可以在任意的时间设置它
 *  load icon on left
 *
 *  @param image icon
 */
- (void)loadTextFieldWithIconImage:(UIImage *)image;


/**
 *  设置圆角   最大为XHTextField高度的1/2
 * set rect max == XHTextField.height/2
 */
@property (assign)float filletHeight;

/**
 *  是否以显示密码方式显示输入的内容(*******)
 *  textField show textField.text as ***
 */
@property (nonatomic,assign)BOOL SecureTextEntry;


/**
 *  边框颜色,宽度为1.0
 *   borderline Color line width == 1.0
 */
@property(nonatomic,copy)UIColor *borderColor;


/**
 *  最多可输入的文本长度
 *  the max length can input default unlimited
 */
@property(assign)NSInteger maxLength;


/**
 *  是否已经验证过  需要时使用 这个属性设置为YES后如果text值发生变化则会变成NO
 *  check if text has changed ,if set YES,then it will be NO while the textField.text had changed
 */
@property (assign)BOOL isCheck;


/**
 *  TextField中的imageView 要改动它的Frame时直接设置logoImageView.frame
 *  the left imageview in the textField, you can use it to change the image's frame
 */
@property (nonatomic,copy)UIImageView *logoImageView;


/**
 *  输入框,可以用来设置XHHTextField未直接实现的属性  如textField.textColor等属性
 *  the textField, you can use it to set the UITextField's frame
 */
@property (nonatomic,strong)UITextField *textField;


/**
 *  UITextField的协议,这里在前缀加了xhh其他的不变,需要使用UITextFieldDelegate时建议使用这个
 */
@property(nonatomic,weak)id<XHHTextFieldDelegate> delegate;


/**
 *  用户输入的文字
 *  just == UITextField.text
 */
@property(nonatomic,copy)NSString *text;


/**
 *  期望用户输入的值  (当你使用到获取验证码是在本地验证时,只需要在获取到验证码后设置这个值) 
 */
@property(nonatomic,copy)NSString *expectText;

/**
 *  textField.placeholder
 */
@property(nonatomic,copy)NSString *placeholder;

@end
