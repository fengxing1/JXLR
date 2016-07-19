//
//  PartnersWebViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14/12/30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  合作伙伴 Web

#import "PartnersWebViewController.h"

@interface PartnersWebViewController ()

@end

@implementation PartnersWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化视图
    [self initView];
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
    self.title = _titleName;
    [self.view setBackgroundColor:ColorBGGray];
    
    [self.navigationController.navigationBar setBarTintColor:ColorWhite];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      ColorNavTitle, NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:16.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
BarButtonItem *barButtonLeft=[BarButtonItem barItemWithTitle:@"返回" widthImage:[UIImage imageNamed:@"bar_left"] withIsImageLeft:YES target:self action:@selector(backClick)];
    [self.navigationItem setLeftBarButtonItem:barButtonLeft];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initContentView{
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = ColorBGGray;
    
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [webView loadRequest:request];
    webView.scalesPageToFit = YES;
    [webView setUserInteractionEnabled:YES];
    
    [self.view addSubview:webView];
}

@end
