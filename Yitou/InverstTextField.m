//
//  InverstTextField.m
//  Yitou
//
//  Created by imac on 16/3/16.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "InverstTextField.h"

@implementation InverstTextField

- (void)loadTextFieldWithFPlaceholder:(NSString *)placeholder{
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [[UIColor colorWithRed:0.26 green:0.6 blue:0.91 alpha:1]CGColor];
    [self addSubview:backView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, VIEWFSW(backView)-10, VIEWFSH(backView))];
    [_textField setBorderStyle:UITextBorderStyleNone];
    [_textField setFont:FONT_14];
    [_textField setPlaceholder:placeholder];
    [_textField setBackgroundColor:[UIColor whiteColor]];
    _textField.keyboardType=UIKeyboardTypeDefault;
    _textField.returnKeyType=UIReturnKeyDefault;
    [backView addSubview:_textField];
}

@end
