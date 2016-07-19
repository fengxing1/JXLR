//
//  InvestmentViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  我要投资
//

#import "InvestmentViewController.h"
#import "BarButtonItem.h"
#import "InvestmentTableViewCell.h"
#import "Investment.h"
#import "BorrowingDetailsViewController.h"
#import "InterestcalculatorViewController.h"
#import "AppDelegate.h"
#import "CacheUtil.h"
extern NSString *headertitle;

@interface InvestmentViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,HTTPClientDelegate,InvestmentTableViewCellDelegate>
{
    NSMutableArray *_dataArrays;
    BorrowingDetailsViewController *BorrowingDetailsView;
    NSInteger _currPage;//页数
    BOOL _isRefresh;
    BOOL _isScreen;
}

@property (strong, nonatomic)  UITableView *tableView;
@property(nonatomic ,strong) NetWorkClient *requestClient1;
@property(nonatomic ,copy)  NSString *investFileName;
@property(nonatomic,strong) NSMutableArray *screenArr;
@end

@implementation InvestmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(investScreen:) name:@"screen1" object:nil];
    //通知检测对象
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"investRefresh" object:nil];
    // 初始化数据
    [self initData];
    // 初始化视图
    [self initView];
}

- (void)readData
{
    
}

/**
 初始化数据
 */
- (void)initData
{
    _screenArr = [[NSMutableArray alloc] init];
    _dataArrays =[[NSMutableArray alloc] init];
    _isScreen=NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, HeightTabBar+HeightCheckButton+HeightNavigationAndStateBar, 0)];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, HeightTabBar+HeightCheckButton+HeightNavigationAndStateBar, 0)];
    _tableView.contentSize=CGSizeMake(WidthScreen, CGRectGetHeight(self.view.frame));
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

/**
 初始化数据
 */
- (void)initView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestData];
}

-(void)requestData
{
    _isRefresh=YES;
    _isScreen=NO;
    _currPage = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"10" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"amount"]; //借款金额
    [parameters setObject:@"0" forKey:@"loanSchedule"]; //投标进度
    [parameters setObject:@"" forKey:@"startDate"]; //开始日期
    [parameters setObject:@"" forKey:@"endDate"]; //结束日期
    [parameters setObject:@"-1" forKey:@"loanType"]; //借款类型
    [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
    [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
    [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    
    _investFileName = [CacheUtil creatCacheFileName:parameters];
    
    if (_requestClient1 == nil) {
        _requestClient1 = [[NetWorkClient alloc] init];
        _requestClient1.delegate = self;
    }
    [_requestClient1 requestGet:@"app/services" withParameters:parameters];
}

- (void)footerRereshing
{
    _isRefresh=NO;
    _currPage++;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"10" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"amount"]; //借款金额
    [parameters setObject:@"0" forKey:@"loanSchedule"]; //投标进度
    [parameters setObject:@"" forKey:@"startDate"]; //开始日期
    [parameters setObject:@"" forKey:@"endDate"]; //结束日期
    [parameters setObject:@"-1" forKey:@"loanType"]; //借款类型
    [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
    [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
    [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    
    if (_isScreen){
        [parameters setObject:[_screenArr objectAtIndex:0] forKey:@"apr"]; //年利率  0 全部
        [parameters setObject:[_screenArr objectAtIndex:1] forKey:@"amount"]; //借款金额
        [parameters setObject:[_screenArr objectAtIndex:2] forKey:@"loanSchedule"]; //投标进度
    }

    if (_requestClient1 == nil) {
        _requestClient1 = [[NetWorkClient alloc] init];
        _requestClient1.delegate = self;
    }
    [_requestClient1 requestGet:@"app/services" withParameters:parameters];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}

#pragma ViewContentDelegate
-(void)onInvest:(Investment *)investment{
    BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    BorrowingDetailsView.titleString = investment.title;
    BorrowingDetailsView.borrowID = investment.borrowId;
    BorrowingDetailsView.progressnum = (investment.progress)*0.01;
    BorrowingDetailsView.rate = investment.rate;
    BorrowingDetailsView.timeString = investment.time;
    BorrowingDetailsView.stateNum = 0;
    BorrowingDetailsView.HidesBottomBarWhenPushed = YES;
    [self presentViewOrPushController:BorrowingDetailsView animated:YES completion:nil withNewNavgation:YES];
}
#pragma mark
-(void) readCache
{
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:_investFileName];// 合成归档保存的完整路径
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    [self processData:dics isCache:YES];// 读取上一次成功缓存的数据
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self processData:obj isCache:NO];// 读取当前请求到的数据
}

-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
{
    [self hiddenRefreshView];
    
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if(!isCache){
            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cachePath = [path stringByAppendingPathComponent:_investFileName];// 合成归档保存的完整路径
            [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
        }
        
        if ([[dataDics objectForKey:@"list"] count] == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"无数据"];
        }else {
            NSArray *dataArr = [dataDics objectForKey:@"list"];
            
            if(_isRefresh)
                [_dataArrays removeAllObjects];
            [SVProgressHUD showSuccessWithStatus:@"已刷新"];
            
            for (NSDictionary *item in dataArr) {
                Investment *bean = [[Investment alloc] init];
                if ([item objectForKey:@"title"] != nil && ![[item objectForKey:@"title"] isEqual:[NSNull null]]) {
                    
                    bean.title = [item objectForKey:@"title"];
                }
                if ([item objectForKey:@"bid_image_filename"] != nil && ![[item objectForKey:@"bid_image_filename"] isEqual:[NSNull null]]) {
                    
                    bean.imgurl = [item objectForKey:@"bid_image_filename"];
                }
                
                if ([item objectForKey:@"creditLevel"]  != nil && ![[item objectForKey:@"creditLevel"]  isEqual:[NSNull null]]) {
                    
                    bean.levelStr = [[item objectForKey:@"creditLevel"] objectForKey:@"image_filename"];
                    
                }else{
                    bean.levelStr  = @"";
                }
                
                bean.progress = [[item objectForKey:@"loan_schedule"] floatValue];
                bean.amount = [[item objectForKey:@"amount"] floatValue];
                bean.rate = [[item objectForKey:@"apr"] floatValue];
                bean.time = [NSString stringWithFormat:@"%@", [item objectForKey:@"period"]];
                
                bean.deadperiodUnit = [[item objectForKey:@"period_unit"] intValue]; // 期限类型
                bean.repayType = [[item objectForKey:@"repayment_type_id"] intValue];    // 还款方式
                bean.deadType = [[item objectForKey:@"bonus_type"] intValue];     // 投标奖励类型
                bean.bonus = [[item objectForKey:@"bonus"] intValue];
                bean.awardScale = [[item objectForKey:@"award_scale"] intValue];
                bean.status=[[item objectForKey:@"status"] intValue];
                
                //还款时间
                if ([item objectForKey:@"repayment_time"]  != nil && ![[item objectForKey:@"repayment_time"]  isEqual:[NSNull null]]) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"repayment_time"] objectForKey:@"time"] doubleValue]/1000];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
                    NSDate *senddate=[NSDate date];
                    //结束时间
                    NSDate *endDate =  [dateFormat dateFromString:[dateFormat stringFromDate:date]];
                    //当前时间
                    NSDate *senderDate = [dateFormat dateFromString:[dateFormat stringFromDate:senddate]];
                    //得到相差秒数
                    bean.repaytime = (int)[endDate timeIntervalSinceDate:senderDate];
                }else{
                    bean.repaytime = 0;
                }
                
                //优质债权
                bean.isQuality = [[item objectForKey:@"is_hot"] boolValue];
                bean.unitstr = [NSString stringWithFormat:@"%@",[item objectForKey:@"period_unit"]];
                bean.borrowId = [item objectForKey:@"id"]; //借款标ID
                [_dataArrays addObject:bean];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.tableView reloadData];
                
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self hiddenRefreshView];
            });
        }
    }else {
        [self hiddenRefreshView];
        
        if(!isCache)
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
        }
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hiddenRefreshView];
    // 服务器返回数据异常
   [SVProgressHUD showErrorWithStatus:@"网络异常"];
   [self readCache];
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    [self readCache];
}
#pragma mark 借款标筛选方法
- (void)investScreen:(NSNotification *)notification
{
    _screenArr = (NSMutableArray *)[notification object];
    _isRefresh=YES;
    if(_screenArr.count>0){
        _isScreen=YES;
        DLOG(@"筛选条件数组为=======%@",_screenArr);
        _currPage = 1;
        //2.1获取投资列表信息，包含投资列表。[OK]
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //2.1获取投资列表信息，包含投资列表。[OK]
        [parameters setObject:@"10" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:[_screenArr objectAtIndex:0] forKey:@"apr"]; //年利率  0 全部
        [parameters setObject:[_screenArr objectAtIndex:1] forKey:@"amount"]; //借款金额
        [parameters setObject:[_screenArr objectAtIndex:2] forKey:@"loanSchedule"]; //投标进度
        [parameters setObject:@"" forKey:@"startDate"]; //开始日期
        [parameters setObject:@"" forKey:@"endDate"]; //结束日期
        [parameters setObject:@"-1" forKey:@"loanType"]; //借款类型
        [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
        [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
        [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
        [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
        
        if (_requestClient1 == nil) {
            _requestClient1 = [[NetWorkClient alloc] init];
            _requestClient1.delegate = self;
        }
        [_requestClient1 requestGet:@"app/services" withParameters:parameters];
    
        //回到顶部
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [self requestData];
    }
}
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvestmentTableViewCell *cell = [InvestmentTableViewCell initWithTableView:tableView];
    cell.delegate=self;
    Investment *object = [_dataArrays objectAtIndex:indexPath.section];
    [cell fillCellWithObject:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [_dataArrays count]-2) {
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightViewInvestContent;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//返回时取消选中状态
    
    Investment *object = [_dataArrays objectAtIndex:indexPath.section];
    BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    BorrowingDetailsView.titleString = object.title;
    BorrowingDetailsView.borrowID = object.borrowId;
    BorrowingDetailsView.progressnum = (object.progress)*0.01;
    BorrowingDetailsView.rate = object.rate;
    BorrowingDetailsView.timeString = object.time;
    BorrowingDetailsView.stateNum = 0;
    BorrowingDetailsView.HidesBottomBarWhenPushed = YES;
    [self presentViewOrPushController:BorrowingDetailsView animated:YES completion:nil withNewNavgation:YES];
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    if (!self.tableView.isFooterHidden) {
        [self.tableView footerEndRefreshing];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_requestClient1 != nil) {
        [_requestClient1 cancel];
    }
}
@end
