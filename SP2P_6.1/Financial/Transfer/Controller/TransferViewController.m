//
//  TransferViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  债权转让
//

#import "TransferViewController.h"
#import "BarButtonItem.h"
#import "ColorTools.h"
#import "CreditorTransfer.h"
#import "CreditorTransferTableViewCell.h"
#import "DetailsOfCreditorViewController.h"
#import "CacheUtil.h"

@interface TransferViewController ()<UITableViewDelegate,UITableViewDataSource,HTTPClientDelegate,CreditorTransferTableViewCellDelegate>
{
    NSMutableArray *_dataArrays;
    NSInteger _currPage;//页数
    BOOL isRefresh;
}
@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic, strong)  NSMutableArray *dataArr;
@property (nonatomic, copy)  NSString *transferFileName;
@end

@implementation TransferViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //通知检测对象
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"AuctionRefresh" object:nil];

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
    _dataArr = [[NSMutableArray alloc] init];
    _dataArrays =[[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, HeightTabBar+HeightCheckButton+HeightNavigationAndStateBar, 0)];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, HeightTabBar+HeightCheckButton+HeightNavigationAndStateBar, 0)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
}
/**
 初始化数据
 */
- (void)initView
{
    self.view.backgroundColor = ColorBGGray;
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    UIImage *image1 = [UIImage imageNamed:@"listview_pull_refresh01"];
    UIImage *image2 = [UIImage imageNamed:@"listview_pull_refresh02"];
    NSArray *refreshImages = [NSArray arrayWithObjects:image1,image2, nil];
    // Hide the time
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    // Hide the status
    gifHeader.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    [gifHeader setImages:refreshImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [gifHeader setImages:refreshImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [gifHeader setImages:refreshImages forState:MJRefreshStateRefreshing];
    _tableView.mj_header = gifHeader;
    
    // 自动刷新(一进入程序就下拉刷新)
    [_tableView.mj_header beginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    MJRefreshBackGifFooter *gifFooter = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    // Hide the status
    gifFooter.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    [gifFooter setImages:refreshImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [gifFooter setImages:refreshImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [gifFooter setImages:refreshImages forState:MJRefreshStateRefreshing];
    _tableView.mj_footer = gifFooter;
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    isRefresh=YES;
    _currPage=1;
    [self requestData];
}

-(void)requestData
{
    isRefresh=YES;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //获取债权转让列表信息，包含债权转让列表 (opt=30)
    [parameters setObject:@"30" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"debtAmount"]; //借款金额
    [parameters setObject:@"" forKey:@"loanType"];    //借款类型
    [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    
    _transferFileName = [CacheUtil creatCacheFileName:parameters];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

- (void)footerRereshing
{
    isRefresh=NO;
    _currPage++;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //获取债权转让列表信息，包含债权转让列表 (opt=30)
    [parameters setObject:@"30" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"debtAmount"]; //借款金额
    [parameters setObject:@"-1" forKey:@"loanType"];    //借款类型
    [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    //DLOG(@"债权转让加载更多的页数为 is %ld",(long)_currPage);
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
        if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{

}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    //DLOG(@"==债权转让返回成功=======%@",obj);
    [self processData:obj isCache:NO];
}

-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
{
    [self hiddenRefreshView];
    DLOG(@"%@",dataDics);
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if(!isCache){
            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cachePath = [path stringByAppendingPathComponent:_transferFileName];// 合成归档保存的完整路径
            [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
        }
        
        NSArray *dataArr = [dataDics objectForKey:@"list"];
        
        if (dataArr.count == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"无数据"];
        }else {
            NSArray *dataArr = [dataDics objectForKey:@"list"];
            if(isRefresh)
               [_dataArrays removeAllObjects];
            
            for (NSDictionary *item in dataArr) {
                
                CreditorTransfer *bean = [[CreditorTransfer alloc] init];
                bean.title = [item objectForKey:@"title"];
                bean.apr = [item objectForKey:@"apr"];
                bean.creditorImg=[item objectForKey:@"credit_image_filename"];
                
                if([item objectForKey:@"end_time"]  != nil && ![[item objectForKey:@"end_time"]  isEqual:[NSNull null]])
                {
                    //剩余时间
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"end_time"] objectForKey:@"time"] doubleValue]/1000];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
                    NSDate *senddate=[NSDate date];
                    //结束时间
                    NSDate *endDate = date;
                    //当前时间
                    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
                    //得到相差秒数
                    NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
                    int days = ((int)time)/(3600*24);
                    int hours = ((int)time)%(3600*24)/3600;
                    int minute = ((int)time)%(3600*24)%3600/60;
                    
                    //DLOG(@"相差时间 天:%i 时:%i 分:%i",days,hours,minute);
                    if (days > 0){
                        bean.time = [[NSString alloc] initWithFormat:@"%i",days];
                        bean.sortTime = (int)time;
                        bean.units =@"天";
                    }else  if (hours > 0){
                        
                        bean.time = [[NSString alloc] initWithFormat:@"%i",hours];
                        bean.sortTime = (int)time;
                        bean.units =@"时";
                        
                    }else if (minute > 0){
                        bean.time = [[NSString alloc] initWithFormat:@"%i",minute];
                        bean.sortTime = (int)time;
                        bean.units =@"分";
                    }
                    else if (minute <= 0)
                    {
                        bean.time = [[NSString alloc] initWithFormat:@"%i",0];
                        bean.sortTime = (int)time;
                        bean.units =@"分";
                    }
                    
                    bean.remainTime=time;
                }else{
                    bean.remainTime=0;
                }
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
                
                bean.creditorId = [[item objectForKey:@"id"] intValue];
                bean.content = [item objectForKey:@"transfer_reason"];
                bean.principal = [[item objectForKey:@"debt_amount"] floatValue];
                bean.minPrincipal = [[item objectForKey:@"transfer_price"] floatValue];
                bean.currentPrincipal = [[item objectForKey:@"max_price"] floatValue];
                bean.isQuality = [[item objectForKey:@"is_quality_debt"] boolValue];
                //bean.isQuality = YES;
                [_dataArrays addObject:bean];
            }
            if(isRefresh){
                [SVProgressHUD showSuccessWithStatus:@"已刷新"];
            }
        }
        
        [_tableView reloadData];
    }else {
        if (!isCache) {
            //DLOG(@"返回成功===========%@",[dataDics objectForKey:@"msg"]);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
            
        }
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self readCache];
    [self hiddenRefreshView];
}

// 无可用的网络
-(void) networkError
{
    [self readCache];
    [self hiddenRefreshView];
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!self.tableView.mj_header.hidden) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (!self.tableView.mj_footer.hidden) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)readCache
{
    
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:_transferFileName];// 合成归档保存的完整路径
    //DLOG(@"path is %@",cachePath);
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    [self processData:dics isCache:YES];// 读取上一次成功缓存的数据
    
}

-(void)onInvest:(CreditorTransfer *)createTransfer{
    DetailsOfCreditorViewController *DetailsOfCreditorView = [[DetailsOfCreditorViewController alloc] init];
    DetailsOfCreditorView.titleString = createTransfer.title;
    DetailsOfCreditorView.rulingPriceStr = [NSString stringWithFormat:@"¥%.1f",createTransfer.currentPrincipal];
    DetailsOfCreditorView.creditorId = [NSString stringWithFormat:@"%ld", (long)createTransfer.creditorId];
    //DetailsOfCreditorView.timeString = object.time;
    DetailsOfCreditorView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:DetailsOfCreditorView animated:YES];
}
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreditorTransferTableViewCell *cell = [CreditorTransferTableViewCell initWithTableView:tableView];
    CreditorTransfer *object = [_dataArrays objectAtIndex:indexPath.section];
    cell.delegate=self;
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
    return HeightViewTransferContent;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CreditorTransfer *object = [_dataArrays objectAtIndex:indexPath.section];
    DetailsOfCreditorViewController *DetailsOfCreditorView = [[DetailsOfCreditorViewController alloc] init];
    DetailsOfCreditorView.titleString = object.title;
    DetailsOfCreditorView.rulingPriceStr = [NSString stringWithFormat:@"¥%.1f",object.currentPrincipal];
    DetailsOfCreditorView.creditorId = [NSString stringWithFormat:@"%ld", (long)object.creditorId];
    //DetailsOfCreditorView.timeString = object.time;
    DetailsOfCreditorView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:DetailsOfCreditorView animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}
@end
