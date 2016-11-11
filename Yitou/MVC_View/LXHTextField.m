//
//  LXHTextField.m
//  TeaMachine
//
//  Created by Xiaohui on 15/8/6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "LXHTextField.h"
#import "LXHDefine.h"

@implementation LXHTextField{
    UITextField  *textFields;
    NSInteger textLength;
}

- (void)loadLXHTextFieldWithLeftImageName:(NSString *)imgName defaultText:(NSString *)text{
    _text = @"";
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(12, (VIEWFSH(self)-24)/2, 24, 24)];
    [imgv setImage:IMAGENAMED(imgName)];
    [self addSubview:imgv];

    textFields = [[UITextField alloc]initWithFrame:CGRectMake(46, 0, VIEWFSW(self)-26, VIEWFSH(self))];
    [textFields setBorderStyle:UITextBorderStyleNone];
    [textFields setFont:[UIFont systemFontOfSize:14]];
    [textFields setPlaceholder:text];
    [textFields setValue:COLORWithRGB(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    textLength = 999;
    [textFields setDelegate:self];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:textFields];
    [self.layer setBorderWidth:0.8];
    [self.layer setBorderColor:[COLORWithRGB(223, 223, 223, 1.0) CGColor]];
}

- (void)lxhTextFieldSetKeyboardType:(UIKeyboardType)keyboardType andLength:(NSInteger)length{
    [textFields setKeyboardType:keyboardType];
    textLength = length;
}

- (void)hideContent{
    [textFields setSecureTextEntry:YES];
}

- (void)setText:(NSString *)text{
    _text = text;
    textFields.text = text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textLength == [textFields.text length]&&[string length] > 0)
        return NO;
    [self performSelector:@selector(changeText) withObject:nil afterDelay:0.2];
    return YES;
}

- (void)changeText{
    _text = textFields.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _text = textField.text;
    if ([_delegate respondsToSelector:@selector(LXHTextFieldDidEndEdit:)]){
        [_delegate LXHTextFieldDidEndEdit:self.tag];
    }
}

- (void)hideKeyboard{
    [textFields resignFirstResponder];
}

@end
