//
//  SetAndHelpCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/9/25.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//



#import "SetAndHelpCtrl.h"
#import "GuideCtrl.h"
#import "AboutUs.h"
#import "FeedbackCtrl.h"
#import "SetAndHelpCell.h"
#import "NercomerGuideCtrl.h"
#import "WebViewCtrl.h"

@interface SetAndHelpCtrl ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SetAndHelpCtrl{
    float orignY;
    NSInteger btnIndx;
    UIScrollView *scrollview;
    UITableView *tableview;
    NSMutableArray *dataSource;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self setTitle:@"问题与帮助"];
    [self loadDataSource];
    [self loadAllView];
}

- (void)loadAllView{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight) style:UITableViewStyleGrouped];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableview];
}

- (void)loadDataSource{
    dataSource = [NSMutableArray new];
    [dataSource addObject:@{CELL_KEY_ICON:@"icon_set_0",CELL_KEY_NAME:@"关于我们",CELL_KEY_VALUE:@""}];
    [dataSource addObject:@{CELL_KEY_ICON:@"icon_set_1",CELL_KEY_NAME:@"意见反馈",CELL_KEY_VALUE:@""}];
    [dataSource addObject:@{CELL_KEY_ICON:@"icon_set_2",CELL_KEY_NAME:@"常见问题",CELL_KEY_VALUE:@""}];
    [dataSource addObject:@{CELL_KEY_ICON:@"icon_set_3",CELL_KEY_NAME:@"新手指引",CELL_KEY_VALUE:@""}];

    [dataSource addObject:@{CELL_KEY_ICON:@"icon_set_4",CELL_KEY_NAME:@"益投网贷客服电话",CELL_KEY_VALUE:@"4008-650-760"}];
    [dataSource addObject:@{CELL_KEY_ICON:@"icon_set_5",CELL_KEY_NAME:@"官方微信",CELL_KEY_VALUE:@"yitouwangdai"}];
    [dataSource addObject:@{CELL_KEY_ICON:@"icon_set_6",CELL_KEY_NAME:@"公司地址(总部)",CELL_KEY_VALUE:@"深圳市深南东路东乐大厦1602室"}];
    [dataSource addObject:@{CELL_KEY_ICON:@"icon_set_7",CELL_KEY_NAME:@"坂田营业部",CELL_KEY_VALUE:@"深圳市龙岗区坂田街道布龙路512号"}];
}

- (void)clickMobile{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"客服电话" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"拨打:4008-650-760" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4008650760"]];
    }];
    UIAlertAction *cancenAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:callAction];
    [alert addAction:cancenAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clickCell:(NSInteger)indx{
    if (indx == 3){
        WebViewCtrl *webViewNercomerGuideCtrl = [[WebViewCtrl alloc] init];
        webViewNercomerGuideCtrl.url = @"http://www.szytou.com/wap/help/default_app.aspx?app=ios";
        webViewNercomerGuideCtrl.name = @"新手指引";
        [self.navigationController pushViewController:webViewNercomerGuideCtrl animated:YES];
        return;
    }

    if (indx == 2){
        WebViewCtrl *webViewQuestion = [[WebViewCtrl alloc] init];
        webViewQuestion.url = @"http://www.szytou.com/wap/faq/item_app.aspx?app=ios";//正式版的
        webViewQuestion.name = @"常见问题";
        [self.navigationController pushViewController:webViewQuestion animated:YES];
        return;
    }

    if (indx == 1){
        FeedbackCtrl *feedBack = [[FeedbackCtrl alloc] init];
        [self.navigationController pushViewController:feedBack animated:YES];
    }

    if (indx == 0){
        AboutUs *about = [[AboutUs alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"insvestssCell";
    SetAndHelpCell *cell = (SetAndHelpCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[SetAndHelpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setDataSource:dataSource[indexPath.section]];
    if (indexPath.section < 5){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0:
        case 1:
        case 2:
        case 3:[self clickCell:indexPath.section];break;
        case 4: [self clickMobile];
        default:break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

@end
