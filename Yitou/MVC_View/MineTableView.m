//
//  MineTableView.m
//  Yitou
//
//  Created by Xiaohui on 15/8/4.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "MineTableView.h"

@implementation MineTableView{
    UITableView *tableview;
    TouchIndexBlock block;
    NSMutableArray *newTagsIndexArr;
}

- (void)loadAllViewWithBlock:(TouchIndexBlock)blocks{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(-40, 0, SCREENWidth+40, VIEWFSH(self))];
    [tableview setDataSource:self];
    [tableview setDelegate:self];
    [self addSubview:tableview];
    [tableview setScrollEnabled:NO];
    [tableview setSeparatorColor:COLORWithRGB(194, 194, 194, 0.4)];
    block = blocks;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"HelloHello";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {//每次都会进入这个条件，正确的做法是先注册cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;//去除选中的背景颜色

    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(50, _cellHeight/2-2, 4, 4)];
    [leftView setBackgroundColor:COLORWithRGB(194, 194, 194, 1)];
    [cell addSubview:leftView];

    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(50+6, (_cellHeight -14)/2, 120, 14)];
    leftLabel.text = [_tableData objectAtIndex:indexPath.row];
    [leftLabel setTextColor:COLORWithRGB(36, 36, 36, 1)];
    [leftLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:14]];
    [leftLabel sizeToFit];
    CGRect llbFrame = leftLabel.frame;
    llbFrame.origin.y = (_cellHeight - llbFrame.size.height)/2;
    leftLabel.frame = llbFrame;
    [cell addSubview:leftLabel];
    if (newTagsIndexArr != nil && newTagsIndexArr.count == _tableData.count) {
        NSString *istag = [newTagsIndexArr objectAtIndex:indexPath.row];
        if ([istag isEqualToString:@"1"]) {
            UILabel *newLabel = [[UILabel alloc] init];
            newLabel.text = @"NEW";
            newLabel.backgroundColor = [UIColor redColor];
            [newLabel setTextColor:[UIColor whiteColor]];
            [newLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:14]];
            [newLabel sizeToFit];
            CGRect lbFrame = newLabel.frame;;
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel.frame)+5, (_cellHeight - lbFrame.size.height-10)/2, lbFrame.size.width + 10, lbFrame.size.height + 10)];
            lbFrame.origin.x = (bgView.frame.size.width - lbFrame.size.width)/2;
            lbFrame.origin.y = (bgView.frame.size.height - lbFrame.size.height)/2;
            newLabel.frame = lbFrame;
            [bgView addSubview:newLabel];
            bgView.backgroundColor = [UIColor redColor];
            bgView.layer.cornerRadius = 2;
            bgView.clipsToBounds = YES;
            [cell addSubview:bgView];
        }
        else {
            
        }
    }

//    UIImageView *rightImgv = [[UIImageView alloc]initWithFrame:CGRectMake(VIEWFSW(tableview)-20, VIEWFOY(leftLabel), 7, 15)];
//    [rightImgv setImage:IMAGENAMED(@"towerRight")];
//    [cell addSubview:rightImgv];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    block((int)indexPath.row);
}

- (void)tagNewForCellAtIndexPath:(NSIndexPath *)indexPath {
    if (newTagsIndexArr == nil) {
        newTagsIndexArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < _tableData.count; i++) {
            [newTagsIndexArr addObject:@"0"];
        }
    }
    NSString *isTaged = [newTagsIndexArr objectAtIndex:indexPath.row];
    if ([isTaged isEqualToString:@"1"]) {
        return;
    }
    [newTagsIndexArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeTagForCellAtIndexPath:(NSIndexPath *)indexPath {
    if (newTagsIndexArr == nil) {
        return;
    }
    if (indexPath.row > newTagsIndexArr.count-1) {
        return;
    }
    NSString *isTaged = [newTagsIndexArr objectAtIndex:indexPath.row];
    if ([isTaged isEqualToString:@"0"]) {
        return;
    }
    [newTagsIndexArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
    [tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
