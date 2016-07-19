//
//  AdWebViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-9-29.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AdWebViewController.h"
#include "ColorTools.h"


@interface AdWebViewController ()


@end

@implementation AdWebViewController

-(id)init{
    self=[super init];
    if(self){
        _isFromeRemote=NO;
        self.title = @"公告";
    }
    return self;
}
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *adWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-HeightNavigationAndStateBar)];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr]];
    [adWebView loadRequest:request];
    adWebView.scalesPageToFit =YES;
    [adWebView setUserInteractionEnabled:YES];
    [self.view addSubview:adWebView];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [adWebView addSubview : activityIndicatorView];
}
-(void)back{
    if(_isFromeRemote){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [super back];
    }
}
@end
