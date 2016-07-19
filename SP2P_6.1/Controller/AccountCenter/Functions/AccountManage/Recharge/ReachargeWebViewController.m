//
//  ReachargeWebViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14/11/11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "ReachargeWebViewController.h"

@interface ReachargeWebViewController ()

@end

@implementation ReachargeWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    [self initData];
    // 初始化视图
    [self initView];
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
    self.title = @"充   值";
    
    UIWebView *adWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",Baseurl,@"/front/account/recharge?id=", AppDelegateInstance.userInfo.userId];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [adWebView loadRequest:request];
    adWebView.scalesPageToFit =YES;
    [adWebView setUserInteractionEnabled:YES];
    [self.view addSubview:adWebView];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                      initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [adWebView addSubview : activityIndicatorView] ;
}
@end
