//
//  RecordView.h
//  Yitou
//
//  Created by imac on 16/3/15.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) NSArray *dataSource;

- (void)beginRefreshTableView;

@end
