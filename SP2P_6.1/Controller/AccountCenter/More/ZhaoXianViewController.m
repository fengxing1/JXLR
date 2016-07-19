//
//  ZhaoXianViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  招贤纳士

#import "ZhaoXianViewController.h"

#import "MoreAboutUs.h"
#import "ColorTools.h"


@interface ZhaoXianViewController ()<HTTPClientDelegate>

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic , strong)  UIWebView *hiringWebView;

@property (nonatomic,copy) NSString *_urlHtml;

@end

@implementation ZhaoXianViewController

// 加载页面之前 加载数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"125" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
     [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"招贤纳士";
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initContentView];
}
- (void)initContentView{
    _hiringWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightScreen-HeightNavigationAndStateBar)];
    _hiringWebView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_hiringWebView];
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{

}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSString *content = nil;
        
        id object = [obj objectForKey:@"content"];
        
        if ([object isKindOfClass:[NSArray class]]) {
            
            if ([object count] != 0) {
                
                content = object[0];
            }
        }else{
            
            content = object;
        }
        
        if (![object isEqual:[NSNull null]] && content != nil) {
            
            [_hiringWebView loadHTMLString:content baseURL:[NSURL URLWithString:Baseurl]];
        }
        
    }else {
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
