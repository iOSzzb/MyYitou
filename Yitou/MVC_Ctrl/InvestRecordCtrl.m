//
//  InvestRecordCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/11/2.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "InvestRecordCtrl.h"
#import "InvestRecordCell.h"
#import <MJRefresh.h>
#import "LXHTimer.h"
#import "ShouldLoginView.h"
#import "LoginCtrl.h"
#import "RegistFirstStepCtrl.h"
#import "InvestPayCtrl.h"

@interface InvestRecordCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic)UITableView *tableview;
@property (nonatomic)NSArray *dataSource;
@property (assign)NSInteger page;
@property (assign)NSInteger countSum;

@end

@implementation InvestRecordCtrl{
    UIView *topView;
    UIButton *investBtn;
    NSTimer *timeRunloop;
    ShouldLoginView *unloginView;
}

@synthesize tableview,dataSource,page,countSum;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserModel shareUserManager].isLogin){
        [unloginView removeFromSuperview];
    }
    else
        [self.view addSubview:unloginView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投标记录";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    page = 1;
    [self loadAllView];
//    [self loadDataSource];
  

    if ([_tender.status integerValue] == 1){
        [self checkStartTime];
        [self checkExistTime];
    }
    unloginView = [[ShouldLoginView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    __weak typeof(self) weakSelf = self;
    [unloginView loadViewWithBlock:^(BOOL isLogin) {
        if (isLogin){
            LoginCtrl *loginCtrl = [[LoginCtrl alloc] init];
            [loginCtrl setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:loginCtrl animated:YES];
        }else{
            RegistFirstStepCtrl *regCtrl = [[RegistFirstStepCtrl alloc] init];
            [weakSelf.navigationController pushViewController:regCtrl animated:YES];
        }
    }];
}

- (void)checkExistTime{
    NSInteger a = [[LXHTimer shareTimerManager] companyTime:_tender.startTime];
    if (a < 3600&& a > 0){
        timeRunloop = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkStartTime) userInfo:nil repeats:YES];
    }
    else
        [timeRunloop invalidate];
}

- (void)checkStartTime{
    NSInteger a = [[LXHTimer shareTimerManager] companyTime:_tender.startTime];
    if (a>0){
        [investBtn setUserInteractionEnabled:NO];
        [investBtn setBackgroundColor:[UIColor grayColor]];
    }else{
        [investBtn setUserInteractionEnabled:YES];
        [investBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    }
    if (a>172800){
        [investBtn setTitle:@"2天以后开始投标" forState:UIControlStateNormal];
    }
    else if (a>86400){
        [investBtn setTitle:@"1天后开始投标" forState:UIControlStateNormal];
    }
    else if (a>7200){
        NSInteger exist = a/60/60;
        [investBtn setTitle:[NSString stringWithFormat:@"大约在:%tu小时后可投",exist] forState:UIControlStateNormal];
    }
    else if (a>0){
        NSInteger exist = a/60;
        [investBtn setTitle:[NSString stringWithFormat:@"大约在:%tu分钟后可投",exist] forState:UIControlStateNormal];
    }
}

//- (void)loadDataSource{
//    __weak typeof(self) weakSelf = self;
//    [HttpManager getInvestRecordListInPage:page investID:self.investID Block:^(RequestResult rqCode, NSArray *array, NSInteger sumCount, NSString *describle) {
//        [weakSelf.tableview.mj_header endRefreshing];
//        [weakSelf.tableview.mj_footer endRefreshing];
//        if (rqCode != rqSuccess){
//            [SVProgressHUD showErrorWithStatus:describle];
//            return ;
//        }
//        
//        if ((weakSelf.dataSource.count == sumCount&&weakSelf.page !=1)||(weakSelf.dataSource.count == sumCount&&weakSelf.page ==1)){
//            [weakSelf.tableview.mj_footer removeFromSuperview];
//            weakSelf.countSum = sumCount;
//            
//            if (weakSelf.page != 1)
//                [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
//            return;
//        }
//        
//        if (weakSelf.dataSource.count < sumCount) {
//            [weakSelf.tableview.mj_footer removeFromSuperview];
//            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
//        }
//        
//        if (array.count + dataSource.count < sumCount)
//            [weakSelf loadTableviewFooter];
//        if (weakSelf.page == 1){
//            weakSelf.countSum = sumCount;
//            weakSelf.dataSource = array;
//        }
//        else{
//            weakSelf.countSum = sumCount;
//            NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:dataSource];
//            [ary addObjectsFromArray:array];
//            weakSelf.dataSource = ary;
//        }
//        [weakSelf.tableview reloadData];
//        
//    }];
//}

- (void)loadDatasource{
        __weak typeof(self) weakSelf = self;
        [HttpManager getInvestRecordListInPage:page investID:self.investID Block:^(RequestResult rqCode, NSArray *array, NSInteger sumCount, NSString *describle) {
            [weakSelf.tableview.mj_header endRefreshing];
            [weakSelf.tableview.mj_footer endRefreshing];
            if (rqCode != rqSuccess){
                [SVProgressHUD showErrorWithStatus:describle];
                return ;
            }
    
            if (rqCode != rqSuccess) {
                NSLog(@"请求失败");
                [SVProgressHUD showErrorWithStatus:describle];
                return ;
            }
            
            //判断是否第一次加载
            if (page == 1) {
                dataSource = array;
                
                [weakSelf loadMJfresh];
            }else{
                NSMutableArray *tempAry = [[NSMutableArray alloc]initWithArray:dataSource];
                [tempAry addObjectsFromArray:array];
                dataSource = [[NSArray alloc] initWithArray:tempAry];
            }
            //显示数据
            [tableview reloadData];
            
            if (array.count < 20 || dataSource.count == sumCount) {
                [tableview.mj_footer removeFromSuperview];
                [SVProgressHUD showSuccessWithStatus:@"没有更多的数据了"];
            }
            [weakSelf.tableview reloadData];
            
        }];

}

- (void)clickInvestButton{
    UserModel *usrModel = [UserModel shareUserManager];
    if (!usrModel.isLogin){
        [SVProgressHUD showErrorWithStatus:@"请先登录!"];
        return;
    }
    InvestPayCtrl *invest = [[InvestPayCtrl alloc] init];
    invest.tender = _tender;
    invest.dataSource = _oriData;
    [self.navigationController pushViewController:invest animated:YES];
}

- (void)loadAllView{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(self.navigationController.navigationBar), SCREENWidth, 50)];
    [topView setBackgroundColor:[UIColor colorWithRed:0.45 green:0.74 blue:1 alpha:1]];
    [self loadTitle];
    [self loadTableView];
    [self.view addSubview:topView];

    [self loadButton];
}

- (void)loadButton{
    investBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREENHeight - 60, SCREENWidth - 40, 45)];
    [investBtn setBackgroundColor:COLORWithRGB(52, 148, 245, 1)];
    [investBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [investBtn addTarget:self action:@selector(clickInvestButton) forControlEvents:UIControlEventTouchUpInside];
    [investBtn setTitle:@"立即投标" forState:UIControlStateNormal];


    if ([[_oriData objectForKey:@"borrow_status"] integerValue] != 1){
        [investBtn setBackgroundColor:[UIColor grayColor]];
        [investBtn setUserInteractionEnabled:NO];
        [investBtn setTitle:_tender.statusDesc forState:UIControlStateNormal];
    }

    UIView *btnBg = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWFOY(investBtn)-10, SCREENWidth, 100)];
    [btnBg setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1]];
    [self.view addSubview:btnBg];
    [self.view addSubview:investBtn];
}

- (void)loadTableView{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(topView)+1-64, SCREENWidth, SCREENHeight - VIEWFH_Y(topView) - 60+64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableview];
    [tableview setDelegate:self];
    [tableview setDataSource:self];

//    __weak typeof(self) weakSelf = self;
//    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf.tableview.mj_footer endRefreshing];
//        weakSelf.page = 1;
//        weakSelf.dataSource = [NSMutableArray new];
//        [weakSelf loadDataSource];
//    }];
//    [tableview.mj_header setState:MJRefreshStateRefreshing];
    [self loadMJfresh];
    [tableview.mj_header beginRefreshing];
}

//刷新功能
-(void)loadMJfresh{
    [tableview.mj_header removeFromSuperview];
    [tableview.mj_footer removeFromSuperview];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableview.mj_header.automaticallyChangeAlpha = YES;
    
    __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableview.mj_footer endRefreshing];
        weakSelf.page = 1;
        [weakSelf loadDatasource];
    }];
    // 上拉刷新
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [tableview.mj_header endRefreshing];
        page ++;
        [weakSelf loadDatasource];
    }];
    
    
}
//
//- (void)loadTableviewFooter{
//    __weak typeof(self) weakSelf = self;
//    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf.tableview.mj_footer setAlpha:1.0];
//        weakSelf.page ++;
//        if (weakSelf.dataSource.count >= weakSelf.countSum){
//            [weakSelf.tableview.mj_footer endRefreshing];
//            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
//            return;
//        }
//        [weakSelf loadDataSource];
//    }];
//}

- (void)loadTitle{
    UILabel *lbUser = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(50, 0, SCREENWidth/5-20, VIEWFSH(topView)) TextColor:[UIColor whiteColor] fontSize:14];
    [lbUser setText:@"用户"];
    [topView addSubview:lbUser];

    UILabel *lbTime = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(SCREENWidth/5+30, 0, SCREENWidth/5-20, VIEWFSH(topView)) TextColor:[UIColor whiteColor] fontSize:14];
    [lbTime setText:@"时间"];
    [topView addSubview:lbTime];

    UILabel *lbLilv = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(SCREENWidth/5*2+10, 0, SCREENWidth/5-10, VIEWFSH(topView)) TextColor:[UIColor whiteColor] fontSize:14];
    [lbLilv setText:@"年利率"];
    [topView addSubview:lbLilv];

    UILabel *lbSum = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(SCREENWidth/5*3, 0, SCREENWidth/5, VIEWFSH(topView)) TextColor:[UIColor whiteColor] fontSize:14];
    [lbSum setText:@"金额"];
    [topView addSubview:lbSum];

    UILabel *lbEarn = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(SCREENWidth/5*4, 0, SCREENWidth/5, VIEWFSH(topView)) TextColor:[UIColor whiteColor] fontSize:14];
    [lbEarn setText:@"收益"];
    [topView addSubview:lbEarn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"insvestRecordCell";
    InvestRecordCell *cell = (InvestRecordCell*)[tableview dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[InvestRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews)
         [view removeFromSuperview];
    [cell setCell:[dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
