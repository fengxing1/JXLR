//
//  JXLRLoginViewController.m
//  LX-UI模板
//
//  Created by eims1 on 16/2/19.
//  Copyright (c) 2016年 sky. All rights reserved.
//

#import "JXLRLoginViewController.h"
#import "JXLRFindPwdViewController.h"
#import "JXLRRegNextViewController.h"
#import "CustomTextField.h"
#import "AJComboBox.h"
#import "CLLockVC.h"

#define NAME_tag 111
#define PWD_tag 222
#define WidthForgetPassword 90
#define HeightForgetPassword 30
#define WidthFindPassword 90
#define HeightFindPassword 30

@interface JXLRLoginViewController ()<UITextFieldDelegate,AJComboBoxDelegate>
{
    BOOL _isLoading;
    BOOL _isRemember;
}
@property (nonatomic, strong) CustomTextField *nameWindow;
@property (nonatomic, strong) CustomTextField *passWindow;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *signBtn;
@property (nonatomic, strong) UIView *reminderView;
@property (nonatomic, strong) UIButton *phoneView;
@property (nonatomic, assign) BOOL isLook;
@property (nonatomic, strong) NSArray *NameListArr;
@end

@implementation JXLRLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavigationBar];
    
    [self initData];
    
    [self initContentView];
}

- (void)initData
{
    _isRemember = YES;
    [self registerForKeyboardNotifications];
}

#pragma mark - 初始化视图
- (void)initContentView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WidthScreen, self.view.frame.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = ColorBGGray;
    [self.view addSubview:_scrollView];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];
    
    // 用户名 输入框
    _nameWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(0, SpaceLogin, WidthScreen, HeightLoginInput)];
    for (UIView *view in _nameWindow.subviews) {
        [view removeFromSuperview];
    }
    [_nameWindow setLeftImage:@"login_name" rightImage:nil placeName:@"请输入用户名或手机号"];
    _nameWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameWindow.delegate = self;
    _nameWindow.keyboardType = UIKeyboardTypeDefault;
    _NameListArr = [[AppDefaultUtil sharedInstance] getDefaultNameList];//待改
    _nameWindow.userLists= _NameListArr;
    [_scrollView addSubview:_nameWindow];
    
    // 密码 输入框
    _passWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameWindow.frame)+SpaceLogin, WidthScreen, HeightLoginInput)];
    for (UIView *view in _passWindow.subviews) {
        [view removeFromSuperview];
    }
    [_passWindow setLeftImage:@"login_pwd" rightImage:@"login_pwd_swicthOff" placeName:@"请输入密码"];
    _passWindow.tag = PWD_tag;//1002
    _passWindow.delegate = self;
    _passWindow.secureTextEntry = YES;
    _passWindow.returnKeyType = UIReturnKeyNext;
    __weak CustomTextField *weakPassField = _passWindow;
    [_passWindow setTapActionBlock:^{
        if (_isLook) {
            [weakPassField.rightBtn setImage:[UIImage imageNamed:@"login_pwd_swicthOff"]forState:UIControlStateNormal];
            weakPassField.secureTextEntry = YES;
        }else{
            [weakPassField.rightBtn setImage:[UIImage imageNamed:@"login_pwd_swicthOn"]forState:UIControlStateNormal];
            weakPassField.secureTextEntry = NO;
        }
        _isLook = !_isLook;
    }];
    
    [_scrollView addSubview:_passWindow];
    
    //记住密码
    UIButton *rememberPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];//
    rememberPwdBtn.frame =CGRectMake(SpaceBig, CGRectGetMaxY(_passWindow.frame)+SpaceLogin, WidthForgetPassword, HeightForgetPassword);//button的frame
    [rememberPwdBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateSelected];
    [rememberPwdBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    rememberPwdBtn.titleLabel.font = FontTextContent;
    rememberPwdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rememberPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rememberPwdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rememberPwdBtn addTarget:self action:@selector(rememberPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:rememberPwdBtn];
    
    //找回密码
    UIButton  *findPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findPwdBtn.frame = CGRectMake(WidthScreen-WidthFindPassword-SpaceBig, CGRectGetMinY(rememberPwdBtn.frame), WidthFindPassword, HeightFindPassword);
    findPwdBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    [findPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal]; 
    [findPwdBtn setTitle:@"找回密码?" forState:UIControlStateNormal];
    findPwdBtn.titleLabel.font = FontTextContent;
    [findPwdBtn addTarget:self action:@selector(findPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:findPwdBtn];
    
    _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signBtn.frame = CGRectMake(SpaceBtnToLeft, CGRectGetMaxY(rememberPwdBtn.frame)+SpaceLogin, WidthScreen-SpaceBtnToLeft*2, 45);
    [_signBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [_signBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    _signBtn.layer.cornerRadius = CornerRadiusBtn;
    _signBtn.layer.masksToBounds=YES;
    _signBtn.titleLabel.font=FontButtonLogin;
    [_signBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [_signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_signBtn];
    
    float heigthContent=CGRectGetMaxY(_signBtn.frame)+SpaceBig;
    _scrollView.contentSize = CGSizeMake(WidthScreen, HeightScreen<heigthContent?heigthContent:HeightScreen);
}

-(void) loginSuccess
{ 
    // 保存账号密码到UserDefault
    [[AppDefaultUtil sharedInstance] setDefaultUserName:AppDelegateInstance.userInfo.userName];// 保存用户昵称
    [[AppDefaultUtil sharedInstance] setDefaultAccount:_nameWindow.text];// 保存用户账号
    [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:_passWindow.text];// 保存用户密码（未加密）
    NSString *pwdStr = [NSString encrypt3DES:_passWindow.text key:DESkey];//用户密码3Des加密
    [[AppDefaultUtil sharedInstance] setDefaultUserPassword:pwdStr];// 保存用户密码（des加密）
    [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:AppDelegateInstance.userInfo.userImg];// 保存用户头像
    [[AppDefaultUtil sharedInstance] setdeviceType:AppDelegateInstance.userInfo.deviceType];// 保存设备型号
    
    //Jaqen-start:登陆成功设置手势密码
    
    //[self back];
    
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
        
        //[lockVC dismiss:0.5f];
    }];
    
    //Jaqen-end
    
    
    
}

#pragma mark - AJComboBoxDelegate
- (void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    //DLOG(@"selectedIndex = %ld",(long)selectedIndex);
         //DLOG(@"selectedIndex = %@",_NameListArr[selectedIndex]);
}

#pragma mark - 记住密码
- (void)rememberPwdBtnClick:(UIButton *)button
{
    if (button.selected == YES) {
        _isRemember = NO;
        button.selected = NO;
    }else
    {
        _isRemember = YES;
        button.selected = YES;
    }
}

#pragma mark  找回密码?
- (void)findPwdBtnClick
{
    JXLRFindPwdViewController *VC = [[JXLRFindPwdViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark  注册
- (void)regItemClick
{
    JXLRRegNextViewController *VC = [[JXLRRegNextViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 点击登录
- (void)signBtnClick
{
    if ([_nameWindow isEditing]|| [_passWindow isEditing]) {
        [_nameWindow resignFirstResponder];
        [_passWindow resignFirstResponder];
    }

    if (_nameWindow.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
        return;
    }
    if (_passWindow.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }

    [self ControlAction];// 关闭键盘
    
    // 加载数据
    [self requestData];
}

#pragma mark - 请求数据
- (void)requestData
{
    //暂时先用登录接口，后面要新增判断账号是否存在接口
    [self.netWorkRM requestLoginWithAccount:_nameWindow.text withPassword:_passWindow.text withDeviceType:@"2"];
}

#pragma mark - 点击空白处收回键盘
- (void)ControlAction
{
    if (_nameWindow.isEditing || _passWindow.isEditing) {
        [_nameWindow resignFirstResponder];
        [_passWindow resignFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark - return键处理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 退出页面，释放网络请求
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([_nameWindow isEditing]|| [_passWindow isEditing]) {
        [_nameWindow resignFirstResponder];
        [_passWindow resignFirstResponder];
    }
}

#pragma mark - 初始化导航条
- (void)initNavigationBar
{
    self.title = @"登录";
    // 注册按钮
    BarButtonItem *barButtonRight=[BarButtonItem barItemWithTitle:@"注册" widthImage:[UIImage imageNamed:@"bar_right"] selectedImage:[UIImage imageNamed:@"bar_right_press"] withIsImageLeft:NO target:self action:@selector(regItemClick)];
    [self.navigationItem setRightBarButtonItem:barButtonRight];
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
    
    float heightContent=CGRectGetMaxY(_signBtn.frame)+SpaceBig;
    float heightShowContent=HeightScreen-keyboardSize.height;
    _scrollView.contentSize = CGSizeMake(WidthScreen, heightShowContent<heightContent?heightContent:heightShowContent);
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    float heightContent=CGRectGetMaxY(_signBtn.frame)+SpaceBig;
    float heightShowContent=HeightScreen-keyboardSize.height;
    _scrollView.contentSize = CGSizeMake(WidthScreen, heightShowContent<heightContent?heightContent:heightShowContent);
}
#pragma mark  HTTPClientDelegate 网络数据回调代理
-(void)startRequestLogin{
    _isLoading = YES;
    [self showHudWitText:@"登录中..."];
}
-(void)responseSuccessLogin:(UserInfo *)userInfo withMessage:(NSString *)message{
    [self hidHud];
    if(userInfo!=nil){
        AppDelegateInstance.userInfo = userInfo;
        
        // 通知全局广播 LeftMenuController 修改UI操作
        [[NSNotificationCenter defaultCenter]  postNotificationName:Update object:userInfo.userName];
        [self loginSuccess];// 登录成功
    }else{
        [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:@""];// 清除用户密码
        [SVProgressHUD showErrorWithStatus:message];
    }
}
-(void)responseFailure:(NSError *)error{
    [super responseFailure:error];
    _isLoading  = NO;
}
-(void)networkError{
    [super networkError];
    _isLoading  = NO;
}
@end


