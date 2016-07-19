//
//  MoreAboutUsDetailViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-16.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MoreAboutUsDetailViewController.h"

#import "MoreAboutUs.h"
#import "MoreAboutUsTableViewCell.h"

#import "ColorTools.h"

@interface MoreAboutUsDetailViewController ()<HTTPClientDelegate>
@property (nonatomic , strong) UIWebView *aboutUsWeb;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation MoreAboutUsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initWithName:(NSString *)name optId:(NSString *)optId
{
    self.title = name;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[NSString stringWithFormat:@"%@", optId] forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initContentView];
}

- (void)initContentView{
    _aboutUsWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightScreen-HeightNavigationAndStateBar)];
    _aboutUsWeb.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_aboutUsWeb];
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
            
            content = [content stringByReplacingOccurrencesOfString:@"src=\"/" withString:[NSString stringWithFormat:@"src=\"%@/", Baseurl]]; //替换相对路径
            
            [_aboutUsWeb loadHTMLString:content baseURL:[NSURL URLWithString:Baseurl]];
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
