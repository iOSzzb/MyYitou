//
//  MyInvestView.h
//  Yitou
//
//  Created by Xiaohui on 15/11/18.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^InvestBlock)(NSInteger indx);

@interface MyInvestView : UIView


/**
 *  加载View 包含回收中的投资和已回收的投资 和tableview的提示栏
 *
 *  @param block  indx==0:点击了回收中的投资 indx==1:点击了已回收的投资
 */
- (void)loadMyInvestViewWithBlock:(InvestBlock)block;

@property (assign)float height;

@end
