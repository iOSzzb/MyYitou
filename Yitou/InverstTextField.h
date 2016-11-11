//
//  InverstTextField.h
//  Yitou
//
//  Created by imac on 16/3/16.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InverstTextField : UIView

@property (nonatomic,strong) UITextField *textField;

- (void)loadTextFieldWithFPlaceholder:(NSString *)placeholder;

@end
