//
//  SetAndHelpCell.h
//  Yitou
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_KEY_ICON  @"PictureName"
#define CELL_KEY_NAME  @"TitleName"
#define CELL_KEY_VALUE @"Describle"

#define CELLHeight  45

@interface SetAndHelpCell : UITableViewCell

@property (nonatomic,copy)NSDictionary *dataSource;

@end
