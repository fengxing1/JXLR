//
//  JXLRFindPwdViewController.m
//  LX-UI模板
//
//  Created by eims1 on 16/2/19.
//  Copyright (c) 2016年 sky. All rights reserved.
//

#import "JXLRFindPwdViewController.h"
#import "JXLRLoginViewController.h"
#import "CustomTextField.h"
#import "JXLRNewPwdViewController.h"
#import "NSString+Shove.h"
#define WidthBtnVerify  105
#define HeightBtnVerify 35

@interface JXLRFindPwdViewController ()

@property (nonatomic, strong) CustomTextField *phoneWindow;
@property (nonatomic, strong) CustomTextField *verifyWindow;
@property (nonatomic, strong) UIButton  *verifyBtn;
@property (nonatomic, strong) NetWorkClient *requestClient;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *labClient;
@end

@implementation JXLRFindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    
    [self initData];

    [self initView];
}

- (void)initView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WidthScreen, HeightScreen)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = ColorBGGray;
    [self.view addSubview:_scrollView];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];
    
    // 请输入绑定的手机号
    _phoneWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(0, SpaceLogin, WidthScreen, HeightLoginInput)];
    for (UIView *view in _phoneWindow.subviews) {
        [view removeFromSuperview];
    }
    [_phoneWindow setLeftImage:@"Find_phone" rightImage:nil placeName:@"请输入绑定的手机号"];
    _phoneWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneWindow.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_phoneWindow];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_phoneWindow.frame)+SpaceLogin, WidthScreen, HeightLoginInput)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bgView];
    
//    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(SpaceMediumBig, 0, WidthScreen-SpaceMediumBig*2, HeightLoginInput)];
//    lbl1.textAlignment = NSTextAlignmentLeft;
//    lbl1.text = @"输入短信中的验证码:";
//    lbl1.font = FontTextContent;
//    lbl1.textColor=ColorTextContent;
//    [bgView addSubview:lbl1];
    
//    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(SpaceMediumBig-1, CGRectGetMaxY(lbl1.frame), WidthScreen-SpaceMediumBig*2, 2)];
//    lbl2.textAlignment = NSTextAlignmentCenter;
//    lbl2.textColor = ColorLine;
//    lbl2.text = @"----------------------------------------------------------------------";
//    lbl2.font = FontTextContent;
//    [bgView addSubview:lbl2];
    
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectMake(WidthScreen-SpaceMediumBig-WidthBtnVerify, (HeightLoginInput-HeightBtnVerify)/2, WidthBtnVerify, HeightBtnVerify);
    [_verifyBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [_verifyBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    _verifyBtn.layer.cornerRadius = CornerRadiusBtn;
    _verifyBtn.layer.masksToBounds=YES;
    _verifyBtn.titleLabel.font = FontButtonLogin;
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verifyBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_verifyBtn addTarget:self action:@selector(verifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_verifyBtn];
    
    // 请输入验证码
    _verifyWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, WidthScreen-WidthBtnVerify-SpaceMediumBig*2, HeightLoginInput)];
    for (UIView *view in _verifyWindow.subviews) {
        [view removeFromSuperview];
    }
    [_verifyWindow setLeftImage:@"Find_code" rightImage:nil placeName:@"请输入验证码"];
    _verifyWindow.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:_verifyWindow];

    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), WidthScreen, HeightButtonLogin)];
    lbl3.textAlignment = NSTextAlignmentCenter;
    lbl3.backgroundColor = [UIColor clearColor];
    lbl3.textColor = [UIColor grayColor];
    lbl3.text = @"点击下一步，验证成功后就可以重置密码!";
    lbl3.font = FontTextSmall;
    lbl3.adjustsFontSizeToFitWidth = YES;
    [_scrollView addSubview:lbl3];
    
    UIButton  *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(SpaceBtnToLeft, CGRectGetMaxY(lbl3.frame), WidthScreen-SpaceBtnToLeft*2, HeightButtonLogin);
    [nextBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    nextBtn.layer.cornerRadius = CornerRadiusBtn;
    nextBtn.layer.masksToBounds=YES;
    nextBtn.titleLabel.font = FontButtonLogin;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:nextBtn];
    
    _labClient = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nextBtn.frame), WidthScreen, HeightButtonLogin)];
    _labClient.textAlignment = NSTextAlignmentCenter;
    _labClient.backgroundColor = [UIColor clearColor];
    _labClient.textColor = [UIColor grayColor];
    _labClient.text = @"客服电话：400-915-1000";
    _labClient.font = FontLabClient;
    [_scrollView addSubview:_labClient];
    
    float heigthContent=CGRectGetMaxY(_labClient.frame)+SpaceBig;
    _scrollView.contentSize = CGSizeMake(WidthScreen, HeightScreen<heigthContent?heigthContent:HeightScreen);
}

- (void)initData
{
    [self registerForKeyboardNotifications];
}


#pragma mark - 验证按钮
- (void)verifyBtnClick
{
    if (_phoneWindow.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号为空！"];
        return;
    }
    
    if ([_phoneWindow.text isPhone]) {

        [self getVerification:nil];
        
    }else {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确！"];
    }
}

#pragma mark   获取验证码
-(void) getVerification:(UIButton *)sender
{
    [self.netWorkRM requestGetVerification:_phoneWindow.text];
}

#pragma mark  验证码获取成功
- (void)verifySuccess
{
    if ([_phoneWindow.text isPhone]) {
        //DLOG(@"phone is right");
        __block int timeout = 60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    
                    [_verifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    _verifyBtn.userInteractionEnabled = YES;
                    [_verifyBtn setAlpha:1];
                });
            }else{
                int seconds = timeout % 61;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    
                    [_verifyBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    _verifyBtn.userInteractionEnabled = NO;
                    _verifyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                    [_verifyBtn setAlpha:0.4];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }else {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确！"];
    }
}

- (void)requestData
{
    //校验验证码请求
    [self.netWorkRM requestVerificationIsTrue:_phoneWindow.text withVerification:_verifyWindow.text];
}
#pragma mark - 下一步
- (void)nextBtnClick
{
    if (_phoneWindow.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (_verifyWindow.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        return;
    }
    [self requestData];
}

#pragma mark - 点击空白处收回键盘
- (void)ControlAction
{
    if (_phoneWindow.isEditing || _verifyWindow.isEditing) {
        [_phoneWindow resignFirstResponder];
        [_verifyWindow resignFirstResponder];
    }
}

#pragma mark - 初始化导航条
- (void)initNavigationBar
{
    self.title = @"找回密码";
}

#pragma mark - 退出页面，释放网络请求
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([_phoneWindow isEditing]|| [_verifyWindow isEditing]) {
        [_phoneWindow resignFirstResponder];
        [_verifyWindow resignFirstResponder];
    }

    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}
#pragma mark 键盘和滚动内容
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    float heightContent=CGRectGetMaxY(_labClient.frame)+SpaceBig;
    float heightShowContent=HeightScreen-keyboardSize.height;
    _scrollView.contentSize = CGSizeMake(WidthScreen, heightShowContent<heightContent?heightContent:heightShowContent);
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    float heightContent=CGRectGetMaxY(_labClient.frame)+SpaceBig;
    float heightShowContent=HeightScreen-keyboardSize.height;
    _scrollView.contentSize = CGSizeMake(WidthScreen, heightShowContent<heightContent?heightContent:heightShowContent);
}
#pragma mark - 网络数据回调代理
-(void)startRequestVerificationIsTrue{
    [self showHudWitText:@"校验中..."];
}
-(void)responseSuccessVerificationIsTrue:(NSString *)userId withMessage:(NSString *)message{
    [self hidHud];
    if(userId){
        //校验验证码返回
        UserInfo *usermodel = [[UserInfo alloc] init];
        usermodel.userId = userId;
        
        AppDelegateInstance.userInfo = usermodel;
        
        JXLRNewPwdViewController *VC = [[JXLRNewPwdViewController alloc] init];
        VC.phone = _phoneWindow.text;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:message];
    }
}
-(void)startRequestGetVerification{
    
}
-(void)responseSuccessGetVerification:(BOOL)isVerification withMessage:(NSString *)message{
    if(isVerification){
        // 成功发送验证码
        [self verifySuccess];
    }else{
        [SVProgressHUD showErrorWithStatus:message];
    }
}
@end
