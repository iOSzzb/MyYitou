//
//  DiscoverTopToolView.h
//  Yitou
//
//  Created by Xiaohui on 15/8/13.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverTopToolView : UIView

- (void)loadToolView;

- (void)loadDataInformation:(NSDictionary *)dict;

@property (nonatomic,copy)NSDictionary *dataSource;

@end
