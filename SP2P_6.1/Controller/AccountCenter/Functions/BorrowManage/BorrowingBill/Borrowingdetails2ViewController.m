//
//  BorrowingdetailsViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "Borrowingdetails2ViewController.h"
#import "ColorTools.h"

@interface Borrowingdetails2ViewController ()<HTTPClientDelegate>

@property (nonatomic, strong) UILabel *borrowTitle;  // 借款标标题
@property (nonatomic, strong) UILabel *borrowAmount;  // 借款总额
@property (nonatomic, strong) UILabel *interestSum;  // 本息合计
@property (nonatomic, strong) UILabel *borrowNum;  // 借款期数
@property (nonatomic, strong) UILabel *annualRate;  // 年利率
@property (nonatomic, strong) UILabel *eachPayment;  // 每期还款
@property (nonatomic, strong) UILabel *paidPeriods;  // 已还期数
@property (nonatomic, strong) UILabel *remainPeriods;  // 剩余期数

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation Borrowingdetails2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    [self requestData];
}

/**
 * 初始化数据
 */
- (void)initData
{

}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = ColorBGGray;
    
    _borrowTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 220, 30)];
    _borrowTitle.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowTitle.textColor = [UIColor grayColor];
    _borrowTitle.text = @"借款标标题:";
    [self.view addSubview:_borrowTitle];
    
    _borrowAmount = [[UILabel alloc] initWithFrame:CGRectMake(15, 105, 220, 30)];
    _borrowAmount.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowAmount.textColor = [UIColor grayColor];
    _borrowAmount.text = @"借款总额:";
    [self.view addSubview:_borrowAmount];
    
    _interestSum = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, 220, 30)];
    _interestSum.font = [UIFont boldSystemFontOfSize:14.0f];
    _interestSum.textColor = [UIColor grayColor];
    _interestSum.text = @"本息合计:";
    [self.view addSubview:_interestSum];
    
    _borrowNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 220, 30)];
    _borrowNum.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowNum.textColor = [UIColor grayColor];
    _borrowNum.text = @"借款期数:";
    [self.view addSubview:_borrowNum];
    
    _annualRate = [[UILabel alloc] initWithFrame:CGRectMake(15, 210, 220, 30)];
    _annualRate.font = [UIFont boldSystemFontOfSize:14.0f];
    _annualRate.textColor = [UIColor grayColor];
    _annualRate.text = @"年利率:";
    [self.view addSubview:_annualRate];
    
    _eachPayment = [[UILabel alloc] initWithFrame:CGRectMake(15, 245, 220, 30)];
    _eachPayment.font = [UIFont boldSystemFontOfSize:14.0f];
    _eachPayment.textColor = [UIColor grayColor];
    _eachPayment.text = @"每期还款:";
    [self.view addSubview:_eachPayment];
    
    _paidPeriods = [[UILabel alloc] initWithFrame:CGRectMake(15, 280, 220, 30)];
    _paidPeriods.font = [UIFont boldSystemFontOfSize:14.0f];
    _paidPeriods.textColor = [UIColor grayColor];
    _paidPeriods.text = @"已还期数:";
    [self.view addSubview:_paidPeriods];
    
    _remainPeriods = [[UILabel alloc] initWithFrame:CGRectMake(15, 315, 220, 30)];
    _remainPeriods.font = [UIFont boldSystemFontOfSize:14.0f];
    _remainPeriods.textColor = [UIColor grayColor];
    _remainPeriods.text = @"剩余期限:";
    [self.view addSubview:_remainPeriods];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"借款标详细情况";
    [self.navigationController.navigationBar setBarTintColor:ColorWhite];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      ColorNavTitle, NSForegroundColorAttributeName,
                                                                      FontNavTitle, NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    BarButtonItem *barButtonLeft=[BarButtonItem barItemWithTitle:@"返回" widthImage:[UIImage imageNamed:@"bar_left"] withIsImageLeft:YES target:self action:@selector(backClick)];
    [self.navigationItem setLeftBarButtonItem:barButtonLeft];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"38" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_kId forKey:@"id"];
        [parameters setObject:_billId forKey:@"billId"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        //DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        _borrowTitle.text = [NSString stringWithFormat: @"借款标标题:%@", [obj objectForKey:@"borrowTitle"]];
        _borrowAmount.text = [NSString stringWithFormat: @"借款总额:%@", [obj objectForKey:@"borrowAmount"]];
        _interestSum.text = [NSString stringWithFormat: @"本息合计:%@", [obj objectForKey:@"interestSum"]];
        _borrowNum.text = [NSString stringWithFormat: @"借款期数:%@", [obj objectForKey:@"borrowNum"]];
        _annualRate.text = [NSString stringWithFormat: @"年利率:%@", [obj objectForKey:@"annualRate"]];
        _eachPayment.text = [NSString stringWithFormat: @"每期还款:%@", [obj objectForKey:@"eachPayment"]];
        _paidPeriods.text = [NSString stringWithFormat: @"已还期数:%@", [obj objectForKey:@"paidPeriods"]];
        _remainPeriods.text = [NSString stringWithFormat: @"剩余期限:%@", [obj objectForKey:@"remainPeriods"]];
        
    }else {
        //DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
     [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
