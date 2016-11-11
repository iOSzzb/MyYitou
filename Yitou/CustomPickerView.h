//
//  CustomPickerView.h
//  ZJYG
//
//  Created by imac on 15/12/29.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockCancel)(void);
typedef void(^BlockDone)(NSString *time,NSString *time_str);

@interface CustomPickerView : UIView

//@property (nonatomic,copy) BlockCancel cancel;
//@property (nonatomic,copy) BlockDone done;

- (void)CustomPickerViewCancelBlock:(BlockCancel)block;
- (void)CustomPickerViewDoneBlock:(BlockDone)block;

@end
