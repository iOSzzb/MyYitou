//
//  MineTableView.h
//  Yitou
//
//  Created by Xiaohui on 15/8/4.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchIndexBlock)(int index);

@interface MineTableView : UIView<UITableViewDataSource,UITableViewDelegate>

- (void)loadAllViewWithBlock:(TouchIndexBlock)blocks;

@property (nonatomic,copy)NSArray *tableData;

@property (assign)float cellHeight;

/**
 增加NEW标识

 @param indexPath 哪一行
 */
- (void)tagNewForCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 删除NEW标识

 @param indexPath 在哪一行
 */
- (void)removeTagForCellAtIndexPath:(NSIndexPath *)indexPath;
@end
