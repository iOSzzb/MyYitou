//
//  InvestTypeView.h
//  Yitou
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define KEY_INVEST_SHOWNAME  @"showName"
//#define KEY_INVEST_TYPECODE  @"TypeCode"

typedef void(^ClickBlock)(NSInteger indx , NSDictionary *dataSource);

@interface InvestTypeView : UIView<UITableViewDelegate,UITableViewDataSource>

- (void)loadTypeWithBlock:(ClickBlock)block;

@property (nonatomic,copy,readonly)NSString *typeCode;

@end
