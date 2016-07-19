//
//  JXLROpenAccountViewController.m
//  LX-UI模板
//
//  Created by eims1 on 16/2/19.
//  Copyright (c) 2016年 sky. All rights reserved.
//

#import "JXLROpenAccountViewController.h"
#import "JXLRLoginViewController.h"
#import "CustomTextField.h"
#import "MyWebViewController.h"
#import "JXLRPopTipView.h"

#define NAME_tag 111
#define ID_tag 222
typedef NS_ENUM(NSInteger,RequestType){
    RequestTypeOpenAccount=0,
    RequestTypeGetUserMessage=1
};
@interface JXLROpenAccountViewController ()<UITextFieldDelegate,HTTPClientDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CustomTextField *nameWindow;
@property (nonatomic, strong) CustomTextField *idWindow;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic,assign)RequestType requestType;
@property(nonatomic,copy)NSString *phone;//电话号码
@end

@implementation JXLROpenAccountViewController
{
    JXLRPopTipView *tipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserMessage];
}
- (void)initView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WidthScreen, self.view.frame.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(WidthScreen, self.view.frame.size.height+10);
    _scrollView.backgroundColor = ColorBGGray;
    [self.view addSubview:_scrollView];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];
    
    
    //绿色图片提示
    UIButton  *greenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    greenBtn.frame = CGRectMake(WidthScreen/2-20, 25, 40, 40);
    //    openBtn.backgroundColor = ColorRedMain;
    [greenBtn setBackgroundImage:[UIImage imageNamed:@"loan_pass"] forState:UIControlStateNormal];
    [_scrollView addSubview:greenBtn];
    
    UILabel *lbl0 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(greenBtn.frame)+5, WidthScreen, 40)];
    lbl0.textAlignment = NSTextAlignmentCenter;
    lbl0.font = [UIFont boldSystemFontOfSize:14];
    lbl0.text = @"请进行实名认证！";
    [_scrollView addSubview:lbl0];
    
    // 请输入真实姓名
    _nameWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lbl0.frame)+5, WidthScreen-10, 60)];
    for (UIView *view in _nameWindow.subviews) {
        [view removeFromSuperview];
    }
    [_nameWindow setLeftImage:@"login_name" rightImage:@"Right_error" placeName:@"请输入真实姓名"];
    _nameWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameWindow.delegate = self;
    _nameWindow.rightBtn.tag = NAME_tag;
    [_nameWindow.rightBtn addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_nameWindow];
    
    // 请输入身份证号
    _idWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_nameWindow.frame)+15, WidthScreen-10, 60)];
    for (UIView *view in _idWindow.subviews) {
        [view removeFromSuperview];
    }
    [_idWindow setLeftImage:@"Open_id" rightImage:@"Right_error" placeName:@"请输入身份证号"];
    _idWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    _idWindow.delegate = self;
    _idWindow.rightBtn.tag = ID_tag;
    _idWindow.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [_idWindow.rightBtn addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_idWindow];

    
    UIButton  *accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accountBtn.frame = CGRectMake(10, CGRectGetMaxY(_idWindow.frame)+15, WidthScreen-20, 45);
    accountBtn.backgroundColor = ColorRedMain;
    accountBtn.layer.cornerRadius = 3.0;
    accountBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [accountBtn setTitle:@"开通资金托管账户" forState:UIControlStateNormal];
    [accountBtn addTarget:self action:@selector(accountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:accountBtn];
    
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(accountBtn.frame), WidthScreen-40, 40)];
    lbl3.textAlignment = NSTextAlignmentLeft;
    lbl3.textColor = [UIColor grayColor];
    lbl3.font = FontTextSmall;
    lbl3.numberOfLines = 0;
    lbl3.text = @"来融金服采用汇付天下平台技术，通过第三方资金托管保障用户账户资金安全。";
    [_scrollView addSubview:lbl3];
    
    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbl3.frame)-10,CGRectGetMaxY(accountBtn.frame)+10 , 10, 10)];
    lbl4.textAlignment = NSTextAlignmentCenter;
    lbl4.textColor = ColorRedMain;
    lbl4.text = @"*";
    lbl4.font = [UIFont systemFontOfSize:17];
    [_scrollView addSubview:lbl4];
    
}

//获取用户电话、身份证等信息
-(void)getUserMessage{
    _requestType=RequestTypeGetUserMessage;
    
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"172" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}
#pragma mark - 开通资金托管账户
- (void)accountBtnClick
{
    if (_nameWindow.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名！"];
        return;
    }
    
    if (_idWindow.text.length != 18 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号！"];
        return;
    }
    
    _requestType=RequestTypeOpenAccount;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"171" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:_nameWindow.text forKey:@"realName"];
    [parameters setObject:_idWindow.text forKey:@"idNo"];
    [parameters setObject:_phone forKey:@"cellPhone1"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

//判断是否有中文
-(BOOL)IsAllChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a < 0x4e00 || a > 0x9fff)
        {
            return NO;
        }
        
    }
    return YES;
    
}
#pragma mark -  网络数据回调代理
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"])
    {
        if(_requestType==RequestTypeOpenAccount){
            if (![[obj objectForKey:@"htmlParam"]isEqual:[NSNull null]] && [obj objectForKey:@"htmlParam"] != nil)
            {
                NSString *htmlParam = [NSString stringWithFormat:@"%@",[obj objectForKey:@"htmlParam"]];
                MyWebViewController *web = [[MyWebViewController alloc]init];
                web.html = htmlParam;
                web.type = @"1";
                web.openAccountType=self.openAccountType;
                [self.navigationController pushViewController:web animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            }
        }else if(_requestType==RequestTypeGetUserMessage){
            if (![[dics objectForKey:@"realName"]isEqual:[NSNull null]])
            {
                _nameWindow.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"realName"]];
            }
            
            if (![[dics objectForKey:@"idNo"]isEqual:[NSNull null]])
            {
                _idWindow.text = [dics objectForKey:@"idNo"];
            }
            if (![[dics objectForKey:@"cellPhone1"]isEqual:[NSNull null]])
            {
                _phone = [dics objectForKey:@"cellPhone1"];
            }
        }
    }
    else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{

}

// 无可用的网络
-(void) networkError
{
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


- (void)clearText:(UIButton *)button
{
    if (button.tag == NAME_tag) {
        _nameWindow.text = @"";
    }
    else if (button.tag == ID_tag) {
        _idWindow.text = @"";
    }
}



#pragma mark - textField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //判断真实姓名
    if (textField == _nameWindow && _nameWindow.text.length != 0) {
        if (textField.text.length<6) {
            
        }
    }
    
    //判断身份证 18位
    if (textField == _idWindow && _idWindow.text.length != 0 ) {
        
        if (_idWindow.text.length != 18) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号！"];
        }
    }
    
}


#pragma mark - 点击空白处收回键盘
- (void)ControlAction
{
    if (_idWindow.isEditing || _nameWindow.isEditing) {
        [_idWindow resignFirstResponder];
        [_nameWindow resignFirstResponder];
        
    }
}

#pragma mark - 初始化导航条
- (void)initNavigationBar
{
    self.title = @"开通托管账户";
}

-(void)back{
    if(self.openAccountType==OpenAccountTypeRegister)
       [self dismissViewControllerAnimated:YES completion:nil];
    else{
        [super back];
    }
        
}
#pragma mark - 退出页面，释放网络请求
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


@end
