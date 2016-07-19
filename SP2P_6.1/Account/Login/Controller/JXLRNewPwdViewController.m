//
//  JXLRNewPwdViewController.m
//  LX-UI模板
//
//  Created by eims1 on 16/2/19.
//  Copyright (c) 2016年 sky. All rights reserved.
//

#import "JXLRNewPwdViewController.h"
#import "JXLRLoginViewController.h"
#import "CustomTextField.h"
#import "JXLRPopTipView.h"

@interface JXLRNewPwdViewController ()

@property (nonatomic, strong) CustomTextField *oldWindow;
@property (nonatomic, strong) CustomTextField *pwd2;
@property (nonatomic, assign) BOOL isLook;
@property (nonatomic, strong) NetWorkClient *requestClient;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *labMessage;
@property (nonatomic, strong) JXLRPopTipView *tipView;
@end

@implementation JXLRNewPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initData];
    
    [self initView];
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
    
    
    // 请设置新登录密码不少于6位
    _oldWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(0, SpaceLogin, WidthScreen,HeightLoginInput)];
    for (UIView *view in _oldWindow.subviews) {
        [view removeFromSuperview];
    }
    [_oldWindow setLeftText:@"重置密码:" rightImage:@"login_pwd_swicthOff" placeName:@"请设置新登录密码"];
    _oldWindow.secureTextEntry = YES;
    _oldWindow.keyboardType = UIKeyboardTypeDefault;
    __weak CustomTextField *weakPassField = _oldWindow;
    [_oldWindow setTapActionBlock:^{
        
        if (_isLook) {
            [weakPassField.rightBtn setImage:[UIImage imageNamed:@"login_pwd_swicthOff"]forState:UIControlStateNormal];
            weakPassField.secureTextEntry = YES;
        }else{
            
            [weakPassField.rightBtn setImage:[UIImage imageNamed:@"login_pwd_swicthOn"]forState:UIControlStateNormal];
            weakPassField.secureTextEntry = NO;
        }
        _isLook = !_isLook;
    }];
    [_scrollView addSubview:_oldWindow];
    
    
    // 请再次输入新密码
    _pwd2 = [[CustomTextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_oldWindow.frame)+SpaceLogin, WidthScreen, HeightLoginInput)];
    for (UIView *view in _pwd2.subviews) {
        [view removeFromSuperview];
    }
    [_pwd2 setLeftText:@"确认密码:" rightImage:nil placeName:@"请再次输入新密码"];
    _pwd2.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwd2.secureTextEntry = YES;
    _pwd2.keyboardType = UIKeyboardTypeDefault;
    [_pwd2.rightBtn addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_pwd2];
    
    UIButton  *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(SpaceBtnToLeft, CGRectGetMaxY(_pwd2.frame)+SpaceLogin, WidthScreen-SpaceBtnToLeft*2, HeightButtonLogin);
    [submitBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = CornerRadiusBtn;
    submitBtn.layer.masksToBounds=YES;
    submitBtn.titleLabel.font = FontButtonLogin;
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
    
    _labMessage = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBig, CGRectGetMaxY(submitBtn.frame), WidthScreen-SpaceBig*2, 60)];
    _labMessage.textAlignment = NSTextAlignmentLeft;
    _labMessage.textColor = ColorTextVice;
    _labMessage.numberOfLines = 0;
    _labMessage.text = @"1、为了您的账户安全，新旧密码必须不同;\n2、密码为6-16位字符（数字、字母、符号）;\n3、不能只使用一个字符，区分大小写。";
    _labMessage.font = FontTextSmall;
    _labMessage.adjustsFontSizeToFitWidth = YES;
    [_scrollView addSubview:_labMessage];
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_labMessage.frame)-10,CGRectGetMaxY(submitBtn.frame)+10 , 10, 10)];
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.textColor = ColorRedMain;
    lbl2.text = @"*";
    lbl2.font = FontTextContent;
    [_scrollView addSubview:lbl2];
    
    float heightContent=CGRectGetMaxY(_labMessage.frame)+SpaceBig;
    _scrollView.contentSize = CGSizeMake(WidthScreen, WidthScreen<heightContent?heightContent:WidthScreen);
}

- (void)initData
{
    [self registerForKeyboardNotifications];
}

#pragma mark - 切换
- (void)swicth:(UIButton *)button
{
    if (button.selected == NO) {
        _oldWindow.secureTextEntry = YES;
        button.selected = YES;
    }else {
        _oldWindow.secureTextEntry = NO;
        button.selected = NO;
    }
}

- (void)clearText
{
    if (_pwd2.text.length != 0) {
        _pwd2.text = @"";
    }
}
#pragma mark - 重新登录
-(void)sureBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 提交
- (void)submitBtnClick
{
    //密码不能为空，请重新输入
    if (_oldWindow.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    //确认密码不能为空，请重新输入
    if (_oldWindow.text.length != 0 && _pwd2.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"确认密码不能为空"];
        return;
    }
    
    //输入密码长度不够
    if (_oldWindow.text.length < 6 || _pwd2.text.length <6) {
        [SVProgressHUD showErrorWithStatus:@"请设置新登录密码不少于6位"];
        return;
    }
    
    //两次输入密码不一致，请重新输入
    if (_oldWindow.text.length != 0 && _pwd2.text.length != 0 && ![_oldWindow.text isEqualToString:_pwd2.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    
    [self requestData];
}

#pragma mark - 请求数据
-(void) requestData
{
    // 账号：1  密码：1
    [self.netWorkRM requestChangePassword:_pwd2.text withPhone:self.phone];
}
#pragma mark - 点击空白处收回键盘
- (void)ControlAction
{
    if (_oldWindow.isEditing || _pwd2.isEditing) {
        [_oldWindow resignFirstResponder];
        [_pwd2 resignFirstResponder];
    }
}

#pragma mark - 初始化导航条
- (void)initNavigationBar
{
    self.title = @"输入新密码";
}


#pragma mark - 退出页面，释放网络请求
-(void) viewWillDisappear:(BOOL)animated
{
        [super viewWillDisappear:animated];
    
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
    
    float heightContent=CGRectGetMaxY(_labMessage.frame)+SpaceBig;
    float heightShowContent=HeightScreen-keyboardSize.height;
    _scrollView.contentSize = CGSizeMake(WidthScreen, heightShowContent<heightContent?heightContent:heightShowContent);
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    float heightContent=CGRectGetMaxY(_labMessage.frame)+SpaceBig;
    float heightShowContent=HeightScreen-keyboardSize.height;
    _scrollView.contentSize = CGSizeMake(WidthScreen, heightShowContent<heightContent?heightContent:heightShowContent);
}
#pragma mark  HTTPClientDelegate 网络数据回调代理
-(void)startRequestChangePassword{
    [self showHudWitText:@"重置中..."];
}
-(void)responseSuccessChangePassword:(BOOL)isSuccess withMessage:(NSString *)message{
    [self hidHud];
    if (isSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"重置密码成功"];
        
        [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:_pwd2.text];// 保存用户密码（未加密）
        NSString *pwdStr = [NSString encrypt3DES:_pwd2.text key:DESkey];//用户密码3Des加密
        [[AppDefaultUtil sharedInstance] setDefaultUserPassword:pwdStr];// 保存用户
        
        _tipView=[[JXLRPopTipView alloc] init];
        [_tipView setTipViewWithTopImage:@"great" withTitle:@"恭喜您！重置密码成功！" withContent:@"登录密码已重置成功，\n请牢记更改后的新密码！" withButtonTitle:@"返回登录"];
        [_tipView.bottomBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_tipView];
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:message];
    }
}
@end
