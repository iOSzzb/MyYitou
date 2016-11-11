//
//  InvertInfoView.h
//  Yitou
//
//  Created by Xiaohui on 15/8/25.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tender.h"

@interface InvertInfoView : UIView

- (void)loadInfoWithData:(Tender *)tend andDataSource:(NSDictionary *)dict;

@property (assign)NSInteger contentSize;

@end
