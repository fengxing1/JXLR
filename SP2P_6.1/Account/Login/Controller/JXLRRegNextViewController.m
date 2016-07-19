//
//  JXLRRegNextViewController.m
//  LX-UI模板
//
//  Created by eims1 on 16/2/19.
//  Copyright (c) 2016年 sky. All rights reserved.
//  注册-->下一步

#import "JXLRRegNextViewController.h"
#import "JXLRLoginViewController.h"
#import "CustomTextField.h"
#import "NSString+Shove.h"
#import "MemberProtocolViewController.h"
#import "JXLROpenAccountViewController.h"
#import "ToolBlackView.h"
#import "CLLockVC.h"

#define NAME_tag 111
#define PHONE_tag 222
#define WidthBtnVerify  105
#define HeightBtnVerify 35
#define WidthBtnPro 180
#define WidthBtnSure 70

@interface JXLRRegNextViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) CustomTextField *verifyWindow;
@property (nonatomic, strong) CustomTextField *pwd1Window;
@property (nonatomic, strong) CustomTextField *pwd2Window;
@property (nonatomic, strong) CustomTextField *recWindow;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *verifyBtn;
@property (nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic, strong) UILabel *labClient;
@property (nonatomic, strong) CustomTextField *phoneWindow;
@property (nonatomic,strong)UIView *viewBlack;
@end

@implementation JXLRRegNextViewController
{
    BOOL isAgree;
    NSInteger _isInit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    
    [self initData];

    [self initView];
}

- (void)initData
{
    _isInit = 1;
    isAgree = YES;
    [self registerForKeyboardNotifications];
}

- (void)initView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WidthScreen, self.view.frame.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = ColorBGGray;
    [self.view addSubview:_scrollView];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];
    
    _phoneWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(SpaceSmall, SpaceMediumSmall, WidthScreen-SpaceSmall*2, HeightLoginInput)];
    for (UIView *view in _recWindow.subviews) {
        [view removeFromSuperview];
    }
    [_phoneWindow setLeftImage:@"iphone" rightImage:@"" placeName:@"请输入手机号"];
    _phoneWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneWindow.delegate = self;
    _phoneWindow.keyboardType = UIKeyboardTypePhonePad;
    [_scrollView addSubview:_phoneWindow];

    
    // 请输入验证码
    _verifyWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneWindow.frame), CGRectGetMaxY(_phoneWindow.frame)+SpaceLogin, CGRectGetWidth(_phoneWindow.frame)-WidthBtnVerify-SpaceMediumSmall, HeightBtnVerify)];
    for (UIView *view in _verifyWindow.subviews) {
        [view removeFromSuperview];
    }
    [_verifyWindow setLeftText:@"" rightImage:nil placeName:@"请输入验证码"];
    _verifyWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyWindow.delegate = self;
    _verifyWindow.keyboardType = UIKeyboardTypePhonePad;
    [_scrollView addSubview:_verifyWindow];
    
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectMake(CGRectGetMaxX(_verifyWindow.frame)+SpaceMediumSmall, CGRectGetMaxY(_phoneWindow.frame)+SpaceLogin, WidthBtnVerify, HeightBtnVerify);//
    [_verifyBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [_verifyBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    _verifyBtn.layer.cornerRadius = CornerRadiusBtn;
    _verifyBtn.layer.masksToBounds=YES;
    _verifyBtn.titleLabel.font = FontTextTitle;
    [_verifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    _verifyBtn.userInteractionEnabled = YES;
    [_verifyBtn setAlpha:1];
    [_verifyBtn addTarget:self action:@selector(verifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_verifyBtn];
    
    // 请设置登录密码不少于6位
    _pwd1Window = [[CustomTextField alloc] initWithFrame:CGRectMake(SpaceSmall, CGRectGetMaxY(_verifyBtn.frame)+SpaceLogin, WidthScreen-SpaceSmall*2, HeightLoginInput)];
    for (UIView *view in _pwd1Window.subviews) {
        [view removeFromSuperview];
    }
    [_pwd1Window setLeftImage:@"password" rightImage:nil placeName:@"请设置登录密码不少于6位"];
    _pwd1Window.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwd1Window.delegate = self;
    _pwd1Window.secureTextEntry = YES;
    _pwd1Window.keyboardType = UIKeyboardTypeDefault;
    [_scrollView addSubview:_pwd1Window];
    
    // 请再次输入密码
    _pwd2Window = [[CustomTextField alloc] initWithFrame:CGRectMake(SpaceSmall,CGRectGetMaxY(_pwd1Window.frame)+SpaceLogin, WidthScreen-SpaceSmall*2, HeightLoginInput)];
    for (UIView *view in _pwd2Window.subviews) {
        [view removeFromSuperview];
    }
    [_pwd2Window setLeftImage:@"password" rightImage:@"" placeName:@"请再次输入密码"];
    _pwd2Window.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwd2Window.delegate = self;
    _pwd2Window.secureTextEntry = YES;
    _pwd2Window.keyboardType = UIKeyboardTypeDefault;
    [_scrollView addSubview:_pwd2Window];
    
    // 请输入密码
    _recWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(SpaceSmall, CGRectGetMaxY(_pwd2Window.frame)+SpaceLogin, WidthScreen-SpaceSmall*2, HeightLoginInput)];
    for (UIView *view in _recWindow.subviews) {
        [view removeFromSuperview];
    }
    [_recWindow setLeftImage:@"adduser" rightImage:@"" placeName:@"请输入推荐经理人编号（选填）"];
    _recWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    _recWindow.delegate = self;
    _recWindow.keyboardType = UIKeyboardTypePhonePad;
    [_scrollView addSubview:_recWindow];
    
    //来融金服用户注册协议
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
    agreeBtn.frame =CGRectMake((WidthScreen-WidthBtnSure-WidthBtnPro)/2, CGRectGetMaxY(_recWindow.frame), WidthBtnSure, HeightBtnVerify);//button的frame
    agreeBtn.selected = YES;
    [agreeBtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];//给button添加image
    [agreeBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];//给button添加image
    [agreeBtn setTitle:@"我同意" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = FontTextContent;
    agreeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    agreeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:agreeBtn];
    
    UIButton  *proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proBtn.frame = CGRectMake(CGRectGetMaxX(agreeBtn.frame), CGRectGetMaxY(_recWindow.frame), WidthBtnPro, HeightBtnVerify);
    proBtn.backgroundColor = [UIColor clearColor];
    proBtn.titleLabel.font = FontTextContent;
    [proBtn setTitleColor:KBlueColor forState:UIControlStateNormal];
    [proBtn setTitle:@"《来融金服用户注册协议》" forState:UIControlStateNormal];
    [proBtn addTarget:self action:@selector(proBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:proBtn];
    
    UIButton  *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.frame = CGRectMake(SpaceBtnToLeft, CGRectGetMaxY(proBtn.frame)+SpaceLogin/2, WidthScreen-SpaceBtnToLeft*2, HeightButtonLogin);
    [regBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [regBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    regBtn.layer.cornerRadius = CornerRadiusBtn;
    regBtn.layer.masksToBounds=YES;
    regBtn.titleLabel.font = FontTextTitle;
    [regBtn setTitle:@"注册" forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(regBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:regBtn];
    
    _labClient = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(regBtn.frame), WidthScreen, HeightButtonLogin)];
    _labClient.textAlignment = NSTextAlignmentCenter;
    _labClient.textColor = [UIColor grayColor];
    _labClient.font = FontTextContent;
    _labClient.numberOfLines = 0;
    _labClient.text = @"客服电话：400-915-1000";
    [_scrollView addSubview:_labClient];
    
    float heightContent=CGRectGetMaxY(_labClient.frame)+SpaceBig+HeightNavigationAndStateBar;
    _scrollView.contentSize = CGSizeMake(WidthScreen, WidthScreen<heightContent?heightContent:WidthScreen);
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

#pragma mark   获取验证码
-(void) getVerification:(UIButton *)sender
{
    [self.netWorkRM requestGetVerification:_phoneWindow.text];
}

#pragma mark - 注册
- (void)regBtnClick
{
    if (_phoneWindow.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号！"];
        return;
    }else if (![_phoneWindow.text isPhone] ) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"PhoneFormatError", nil)];
        return;
    }
    
    if (_verifyWindow.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码！"];
        return;
    }
    if (_pwd1Window.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码！"];
        return;
    }
    if (_pwd2Window.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码！"];
        return;
    }
    if (!isAgree) {
        [SVProgressHUD showErrorWithStatus:@"请同意《来融金服用户注册协议》！"];
        return;
    }
    
    [self.netWorkRM requestRegisterMessage:_phoneWindow.text withPassword:_pwd1Window.text widthPhone:_phoneWindow.text withVerify:_verifyWindow.text withRefereeNum:_recWindow.text.length==0?@"":_recWindow.text];
}

-(void)onNotOpen{
    [_viewBlack removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)onOpen{
    [_viewBlack removeFromSuperview];
    JXLROpenAccountViewController *controller = [[JXLROpenAccountViewController alloc] init];
    controller.openAccountType=OpenAccountTypeRegister;
    [self presentViewOrPushController:controller animated:YES completion:nil];
}
#pragma mark - 同意协议
- (void)agreeBtnClick:(UIButton *)button
{
    if (button.selected == YES) {
        button.selected = NO;
        isAgree = NO;
    }else {
        button.selected = YES;
        isAgree = YES;
    }
}

#pragma mark - 协议内容
- (void)proBtnClick
{
    MemberProtocolViewController *protocolView = [[MemberProtocolViewController alloc] init];
    protocolView.opt = @"8";
    [self presentViewOrPushController:protocolView animated:YES completion:nil];
}

#pragma mark - textField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _pwd1Window && _pwd1Window.text.length != 0) {
        if (textField.text.length<6) {
            //判断密码长度
            [SVProgressHUD showErrorWithStatus:@"请设置新登录密码不少于6位"];
        }
    }
    
    if (textField == _pwd2Window && _pwd2Window.text.length != 0 && _pwd1Window.text.length != 0) {
        
        if (![_pwd1Window.text isEqualToString:_pwd2Window.text]) {
            [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致！"];

        }
    }
}

#pragma mark - 点击空白处收回键盘
- (void)ControlAction
{
    if (_verifyWindow.isEditing || _pwd1Window.isEditing || _pwd2Window.isEditing) {
        [_verifyWindow resignFirstResponder];
        [_pwd1Window resignFirstResponder];
        [_pwd2Window resignFirstResponder];

    }
}

#pragma mark - 初始化导航条
- (void)initNavigationBar
{
    self.title = @"注册";
}

#pragma mark - 退出页面，释放网络请求
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
#pragma mark
- (void)registrationLogin:(NSString *)name pwd:(NSString *)pwd {
    [self.netWorkRM requestLoginWithAccount:name withPassword:pwd withDeviceType:@"2"];
}

-(void) loginSuccess
{
    // 登录成功，记住密码. 保存账号密码到UserDefault
    [[AppDefaultUtil sharedInstance] setDefaultUserName:AppDelegateInstance.userInfo.userName];// 保存用户昵称
    [[AppDefaultUtil sharedInstance] setDefaultAccount:_phoneWindow.text];// 保存用户账号
    [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:_pwd1Window.text];// 保存用户密码（未加密）
    NSString *pwdStr = [NSString encrypt3DES:_pwd1Window.text key:DESkey];//用户密码3Des加密
    [[AppDefaultUtil sharedInstance] setDefaultUserPassword:pwdStr];// 保存用户密码（des加密）
    [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:AppDelegateInstance.userInfo.userImg];// 保存用户头像
    [[AppDefaultUtil sharedInstance] setdeviceType:AppDelegateInstance.userInfo.deviceType];// 保存设备型号
    
    //Jaqen-start:注册成功之后设置手势密码
    
    //_viewBlack=[ToolBlackView createRemindWithTitle:@"恭喜您！已注册成功！" withContent:@"开通资金托管账户，投资理财更安全！" withLeftText:@"暂不开通" withRightText:@"立即开通" withTarget:self withActionLeft:@selector(onNotOpen) withActionRight:@selector(onOpen)];
    
    [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        
        NSLog(@"密码设置成功");
        
        //设置启用手势密码
        [[AppDefaultUtil sharedInstance] setGesturesPasswordStatusWithFlag:YES];
        
        //隐藏所有模态视图控制器
        UIViewController *rootVC = self.presentingViewController;
        while (rootVC.presentingViewController) {
            rootVC = rootVC.presentingViewController;
        }
        [rootVC dismissViewControllerAnimated:YES completion:nil];
        
        //弹窗－开通汇付
        _viewBlack=[ToolBlackView createRemindWithTitle:@"恭喜您！已注册成功！" withContent:@"开通资金托管账户，投资理财更安全！" withLeftText:@"暂不开通" withRightText:@"立即开通" withTarget:self withActionLeft:@selector(onNotOpen) withActionRight:@selector(onOpen)];
    }];
    
    //Jaqen-end
}
#pragma mark - 网络数据回调代理
-(void)startRequestLogin{
    
}
-(void)responseSuccessLogin:(UserInfo *)userInfo withMessage:(NSString *)message{
    userInfo.isLogin = @"1";
    userInfo.deviceType = @"2";
    
    AppDelegateInstance.userInfo = userInfo;
    
    // 通知全局广播 LeftMenuController 修改UI操作
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"update" object:userInfo.userName];
    
    [self loginSuccess];// 登录成功
}
-(void)startRequestGetVerification{
    
}
-(void)responseSuccessGetVerification:(BOOL)isVerification withMessage:(NSString *)message{
    if(isVerification){
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功！"];
        // 成功发送验证码
        [self verifySuccess];
    }else{
        [SVProgressHUD showErrorWithStatus:message];
    }
}
-(void)startRequestRegisterMessage{
    [self showHudWitText:@"注册中..."];
}
-(void)responseSuccessRegisterMessageUserID:(NSString *)userId withMessage:(id)message{
    [self hidHud];
    if(userId!=nil){
        [[AppDefaultUtil sharedInstance] setDefaultUserName:_phoneWindow.text];// 保存用户账号
        [[AppDefaultUtil sharedInstance] setDefaultUserPassword:_pwd1Window.text];
        [[AppDefaultUtil sharedInstance] setDefaultUserCellPhone:_phoneWindow.text];// 保存手机号
        
        UserInfo *usermodel = [[UserInfo alloc] init];
        usermodel.userId = userId;
        AppDelegateInstance.userInfo = usermodel;
        [self registrationLogin:_phoneWindow.text pwd:_pwd1Window.text];
    }else{
        [SVProgressHUD showErrorWithStatus:message];
    }
}
@end
