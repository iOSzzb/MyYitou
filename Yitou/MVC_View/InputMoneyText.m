//
//  InputMoneyText.m
//  Yitou
//
//  Created by Xiaohui on 15/8/21.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "InputMoneyText.h"

@implementation InputMoneyText{
    UITextField *textField_;
    BOOL hasPoint;
}

- (void)loadTextField{
    [self.layer setBorderColor:[COLORWithRGB(42, 138, 225, 1) CGColor]];
    [self.layer setBorderWidth:1.0];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:3.0];
    [self setBackgroundColor:COLORWithRGB(239, 248, 255, 1)];

    hasPoint = YES;
    _inputMax = -1;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(VIEWFSW(self)-20, 0, 20, VIEWFSH(self))];
    [label setTextColor:COLORWithRGB(42, 138, 225, 1)];
    [label setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [label setText:@"元"];
    [self addSubview:label];

    textField_ = [[UITextField alloc] initWithFrame:CGRectMake(3, 0, VIEWFSW(self)-23, VIEWFSH(self))];
    [textField_ setDelegate:self];
    [textField_ setFont:[UIFont fontWithName:SYSTEMFONTName size:14]];
    [textField_ setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self addSubview:textField_];
}

- (void)setText:(NSString *)text{
    textField_.text = text;
    _text = text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField_ resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _text = textField.text;
    if ([_delegate respondsToSelector:@selector(InputTextEndEdit)]){
        [_delegate InputTextEndEdit];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(InputTextStartEdit)]){
        [_delegate InputTextStartEdit];
    }
}

- (void)timeForSetText{
    _text = textField_.text;

    NSLOG(@"%@",_text);

    if ([_delegate respondsToSelector:@selector(InputTextChange)]){
        [_delegate InputTextChange];
    }
}

- (void)forbidPoint{
    hasPoint = NO;
    [textField_ setKeyboardType:UIKeyboardTypeNumberPad];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([string length] == 0){
        [self performSelector:@selector(timeForSetText) withObject:nil afterDelay:0.2];
        return YES;
    }
    if (STRCMP(@".", string)&&!hasPoint)
        return NO;
    if (!REGEXStr(@"[0-9.]", string))
        return NO;
    if ([_text length] == 0&&STRCMP(@"0", string)&&!hasPoint)
        return NO;
    NSArray *ary = [textField_.text componentsSeparatedByString:@"."];
    if ([_text length] == 0 && STRCMP(@".", string))
        return NO;
    if ([ary count] == 2 && STRCMP(@".", string))
        return NO;
    if ([ary count] == 2 && [[ary objectAtIndex:1] length] ==2 && [string length] > 0)
        return NO;
    if (STRCMP(@"0", _text)&&(!STRCMP(@".", string)&&[string length]==1))
        return NO;
    NSString *newStr = [textField.text stringByAppendingString:string];
    if ([newStr length] < 10 && ([newStr floatValue] <= _inputMax || _inputMax == -1)){
        [self performSelector:@selector(timeForSetText) withObject:nil afterDelay:0.07];
        [self performSelector:@selector(timeForSetText) withObject:nil afterDelay:0.2];
        [self timeForSetText];
        return YES;
    }
    return NO;
}

- (void)shouldHideKeyBoard{
    [textField_ resignFirstResponder];
}

@end
