//
//  AskQuestionViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-14.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AskQuestionViewController.h"
#import "ColorTools.h"
#import "TenderOnceViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface AskQuestionViewController ()<UITextViewDelegate,HTTPClientDelegate>

@property (nonatomic, strong) UITextView *questionView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AskQuestionViewController

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
    
    UILabel *titleLabel = [[UILabel alloc]  initWithFrame:CGRectMake(10, SpaceMediumSmall, 120, 30)];
    titleLabel.text = @"向借款人提问:";
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:titleLabel];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
    
    
    _questionView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+SpaceSmall, self.view.frame.size.width-20, 80)];
    _questionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _questionView.layer.borderWidth = 0.5f;
    _questionView.layer.cornerRadius = 3.0f;
    _questionView.layer.masksToBounds = YES;
    _questionView.delegate = self;
    _questionView.backgroundColor= [UIColor whiteColor];
    _questionView.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_questionView];

    
    UIButton *askBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    askBtn.frame = CGRectMake(SpaceBig, CGRectGetMaxY(_questionView.frame)+SpaceBig,WidthScreen-SpaceBig*2, 35);
    [askBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [askBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    [askBtn setTitle:@"提问" forState:UIControlStateNormal];
    [askBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    askBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
    [askBtn.layer setMasksToBounds:YES];
    [askBtn.layer setCornerRadius:3.0];
    [askBtn addTarget:self action:@selector(askBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:askBtn];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"提问";
}

#pragma 提问
- (void)askBtnClick
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //借款标提问(opt=14)
    [parameters setObject:@"14" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"borrowId"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_bidUserIdSign] forKey:@"bidUserIdSign"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
    [parameters setObject:_questionView.text forKey:@"questions"];

    
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
    
    //DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"askListUpdate" object:self];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    else{
        
        //DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
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
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    
    for (UITextView *textview in [self.view  subviews])
    {
        if ([textview isKindOfClass: [UITextView class]]) {
            
            [textview  resignFirstResponder];
        }
        
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        return NO;
    }else {
        if ([textView.text length] < 70) {//判断字符个数
            return YES;
        }
    }
    return NO;
}

#pragma 立即投标
- (void)tenderBtnClick
{
    if (AppDelegateInstance.userInfo == nil) {
        
      [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }
    else
    {
        TenderOnceViewController *TenderOnceView = [[TenderOnceViewController alloc] init];
        TenderOnceView.borrowId = _borrowId;
        [self.navigationController pushViewController:TenderOnceView animated:NO];
    }
}



-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end