//
//  LoanViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  我要借款
//

#import "LoanViewController.h"

#import "BarButtonItem.h"
#import "ColorTools.h"
#import "LoanType.h"
#import "LoanTypeTableViewCell.h"
#import "UIFolderTableView.h"
#import "ApplicationRequirementsViewController.h"
#import "CreditBorrowingScaleViewController.h"
#import "CacheUtil.h"


#define IS_IOS7 (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)

@interface LoanViewController ()<UITableViewDelegate,UITableViewDataSource,HTTPClientDelegate>
{
    NSMutableArray *_collectionArrays;
}
@property (nonatomic, strong) UIFolderTableView *tableView;
@property (nonatomic, strong) ApplicationRequirementsViewController *ApplicationRequirementsView;
@property (nonatomic,strong)NSIndexPath *indexPathnum;
@property (nonatomic,copy)NSString *loanFileName;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@end

@implementation LoanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化视图
    [self initView];

    // 初始化数据
    [self initData];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navgationState=NavgationStateWhiteNotBack;
    [super viewWillAppear:animated];
}
/**
 初始化数据
 */
- (void)initData
{
    _collectionArrays =[[NSMutableArray alloc] init];
}
/**
 初始化数据
 */
- (void)initView
{
    self.title = NSLocalizedString(@"Tab_Loan", nil);
    
    _tableView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ColorBGGray;
    [self.view addSubview:_tableView];
    
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
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestData];
}

-(void)requestData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //3.1客户端借款标产品列表接口
    [parameters setObject:@"18" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
     _loanFileName = [CacheUtil creatCacheFileName:parameters];
    
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
   [self processData:obj isCache:NO];// 读取当前请求到的数据
}

-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
{
    [self hiddenRefreshView];
    //DLOG(@"dataDics is %@",dataDics);
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if(!isCache){
            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cachePath = [path stringByAppendingPathComponent:_loanFileName];// 合成归档保存的完整路径
            [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
        }
        
        NSArray *collections = [dataDics objectForKey:@"list"];
        if ([collections count]==0) {
            
            [SVProgressHUD showErrorWithStatus:@"无数据"];
        }
        else{
            [_collectionArrays removeAllObjects];
            //DLOG(@"collections count is %lu",(unsigned long)[collections count]);
            for (NSDictionary *item in collections) {
                LoanType *bean = [[LoanType alloc] init];
                bean.name = [item objectForKey:@"name"];
                bean.ID  = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                bean.des =  [item objectForKey:@"fitCrowd"];  //适合人群
                bean.minAmount = [NSString stringWithFormat:@"%@",[item objectForKey:@"minAmount"]];
                bean.maxAmount = [NSString stringWithFormat:@"%@",[item objectForKey:@"maxAmount"]];
                if ([item objectForKey:@"smallImageFilename"]!= nil && ![[item objectForKey:@"smallImageFilename"]isEqual:[NSNull null]])
                {
                    if ([[item objectForKey:@"smallImageFilename"] hasPrefix:@"http"]) {
                        
                        bean.imageurl =  [item objectForKey:@"smallImageFilename"];
                    }else{
                        
                        bean.imageurl =  [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"smallImageFilename"]];
                    }
                }
               
                bean.applicantCondition = [item objectForKey:@"applicantCondition"];
                [_collectionArrays addObject:bean];
            }
        
            // 刷新表格
            [self.tableView reloadData];
                
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_tableView.mj_header beginRefreshing];
            
        }
    }
    else{
        [self hiddenRefreshView];
       if (!isCache) {
        //DLOG(@"返回失败===========%@",[dataDics objectForKey:@"msg"]);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
       }
    }
}
// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hiddenRefreshView];
    // 服务器返回数据异常
     [self readCache];
}

// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    [self hiddenRefreshView];
    [self readCache];
}

- (void)readCache
{
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:_loanFileName];// 合成归档保存的完整路径
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    [self processData:dics isCache:YES];// 读取上一次成功缓存的数据
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _collectionArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SpaceSmall;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SpaceSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoanTypeTableViewCell *cell = [LoanTypeTableViewCell initWithTable:tableView];
    LoanType *object = [_collectionArrays objectAtIndex:indexPath.section];
    [cell fillCellWithObject:object];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightCellLoan;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LoanType *loanModel = [_collectionArrays objectAtIndex:indexPath.section];
    CreditBorrowingScaleViewController *creditBorrowingScaleView = [[CreditBorrowingScaleViewController alloc] init];
    creditBorrowingScaleView.productId = loanModel.ID;
    creditBorrowingScaleView.titleStr = loanModel.name;
    creditBorrowingScaleView.hidesBottomBarWhenPushed = YES;
    //[self presentViewOrPushController:creditBorrowingScaleView animated:YES completion:nil withNewNavgation:YES];
    
    [self.navigationController pushViewController:creditBorrowingScaleView animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
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

@end
