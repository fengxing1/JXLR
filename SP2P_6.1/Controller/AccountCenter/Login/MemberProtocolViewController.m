//
//  MemberProtocolViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  会员服务协议

#import "MemberProtocolViewController.h"

#import "ColorTools.h"


#define kWidth self.view.frame.size.width
#define kHeigth self.view.frame.size.height

@interface MemberProtocolViewController ()<HTTPClientDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation MemberProtocolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
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
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"来融金服会员服务协议";
}

/**
 * 初始化内容详情
 */
- (void)initContentView
{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = ColorBGGray;
    
    [self.view addSubview:_webView];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:_opt forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
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
    NSDictionary *dics = obj;
    //DLOG(@"dics -> %@",dics);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        //DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        NSString *html = [obj objectForKey:@"content"];
        
        if (![html isEqual:[NSNull null]]) {
            
            [_webView loadHTMLString:html baseURL:nil];
            
        }
        
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
