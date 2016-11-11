//
//  XHTextField.m
//  XHTextFieldDemo
//
//  Created by Xiaohui on 16/1/9.
//  Copyright © 2016年 xiaohui. All rights reserved.
//

#import "XHHTextField.h"

#define ICON_ORIGN_Y  5

@implementation XHHTextField{
    NSString *checkedStr;//设置isCheck为YES时的text 
}

@synthesize textField;
@synthesize logoImageView;
@synthesize isCheck;
@synthesize text;
@synthesize maxLength;
@synthesize delegate;
@synthesize SecureTextEntry;
@synthesize filletHeight;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self){
        [self setBackgroundColor:[UIColor whiteColor]];
        textField = [[UITextField alloc] init];
        logoImageView = [[UIImageView alloc] init];
        [self addSubview:logoImageView];
        [self addSubview:textField];
        [textField setDelegate:self];
        isCheck = NO;
        delegate = nil;
        [self loadTextFieldWithIconImage:image];
    }
    return self;
}

- (BOOL)becomeFirstResponder{
   return [textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    return [textField resignFirstResponder];
}

- (void)loadTextFieldWithIconImage:(UIImage *)image{
    float orignX = self.frame.size.height/2 - 5;
    [logoImageView setImage:image];
    if (image.size.width == 0 || image.size.height == 0 || image == nil){
        [logoImageView setFrame:CGRectMake(0, 0, 0, 0)];
    }else{
        float imgWidth = image.size.width;
        float imgHeight = image.size.height;
        if (imgHeight > self.frame.size.height - ICON_ORIGN_Y*2){
            imgHeight = self.frame.size.height - ICON_ORIGN_Y*2;
            imgWidth = imgHeight*image.size.width/image.size.height;
        }
        [logoImageView setFrame:CGRectMake(orignX, ICON_ORIGN_Y, imgWidth, imgHeight)];
    }
    float tfOrignX = image == nil ? 5 : orignX + logoImageView.frame.size.width + 5;
    [textField setFrame:CGRectMake(tfOrignX, 0, self.frame.size.width - tfOrignX - orignX , self.frame.size.height)];
}

- (void)setSecureTextEntry:(BOOL)SecureTextEntrys{
    SecureTextEntry = SecureTextEntrys;
    [textField setSecureTextEntry:SecureTextEntrys];
}

- (BOOL)SecureTextEntry{
    return SecureTextEntry;
}

- (void)setIsCheck:(BOOL)isChecks{
    isCheck = isChecks;
    if (isChecks)
        checkedStr = textField.text;
    else
        checkedStr = nil;
}

- (BOOL)isCheck{
    return [checkedStr isEqualToString:textField.text];
}


- (void)setText:(NSString *)texts{
    textField.text = texts;
}

- (NSString *)text{
    if (maxLength > [textField.text length]||maxLength == 0)
        return textField.text;
    textField.text = [textField.text substringToIndex:maxLength];
    return textField.text;
}

- (void)setPlaceholder:(NSString *)placeholder{
    textField.placeholder = placeholder;
}

- (void)setBorderColor:(UIColor *)borderColor{
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:borderColor.CGColor];
    [self.layer setBorderWidth:1.0];
}

- (void)setFilletHeight:(float)filletHeights{
    [self.layer setMasksToBounds:YES];
    filletHeight = filletHeights < self.frame.size.height/2?filletHeights:self.frame.size.height/2;
    [self.layer setCornerRadius:filletHeight];
}

- (float)filletHeight{
    return filletHeight;
}

#pragma mark UITextField 的Delegate

- (BOOL)textFieldShouldClear:(UITextField *)textFields{
    if ([delegate respondsToSelector:@selector(xhhTextFieldShouldClear:)]){
        return [delegate xhhTextFieldShouldClear:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFields{
    if ([delegate respondsToSelector:@selector(xhhTextFieldShouldReturn:)]){
        if (maxLength == 0 || [textField.text length] < maxLength)
            return [delegate xhhTextFieldShouldReturn:self];
        
    }
    else if([text length] < maxLength|| maxLength == 0)
        return YES;
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textFields{
    if ([delegate respondsToSelector:@selector(xhhTextFieldDidEndEditing:)]){
        [delegate xhhTextFieldDidEndEditing:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textFields{
    if ([delegate respondsToSelector:@selector(xhhTextFieldDidBeginEditing:)]){
        [delegate xhhTextFieldDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textFields{
    if ([delegate respondsToSelector:@selector(xhhTextFieldShouldEndEditing:)]){
        return [delegate xhhTextFieldShouldEndEditing:self];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textFields{
    if ([delegate respondsToSelector:@selector(xhhTextFieldShouldBeginEditing:)]){
        return [delegate xhhTextFieldShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textFields shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (maxLength > 0 && [textField.text length] >= maxLength && [string length] != 0){
        return NO;
    }
    
    if ([delegate respondsToSelector:@selector(xhhTextField:shouldChangeCharactersInRange:replacementString:)]){
        return [delegate xhhTextField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

@end
