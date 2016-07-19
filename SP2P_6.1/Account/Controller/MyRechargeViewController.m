//
//  MyRechargeViewController.m
//  SP2P_6.1
//
//  Created by EIMS-IOS on 15-3-1.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "MyRechargeViewController.h"
#import "MyWebViewController.h"
#import "MSKeyboardScrollView.h"
#import "OpenAccountViewController.h"
#import "JXLROpenAccountViewController.h"
#import "ToolButton.h"
#import "ToolBlackView.h"

#define FontTitle FontTextContent

@interface MyRechargeViewController ()<UITextFieldDelegate,HTTPClientDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UITextField *rechargeField;
@property (nonatomic,strong) NetWorkClient *requestClient;
@property (nonatomic,strong)UILabel *rentallabel;
@property (nonatomic,strong)UILabel *balancelabel;
@property (nonatomic,strong)MSKeyboardScrollView *scrollView;
@property (nonatomic,assign)NSInteger requestType;
@property (nonatomic,strong)UIView *viewBlack;
@end

@implementation MyRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(initData) name:@"rechargeUpdate" object:nil];
    [self initData];
    [self initView];
}

- (void)initData
{
    _requestType = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"145" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

- (void)initView
{
    self.title = @"充值";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //滚动视图
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = ColorBGGray;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    [self.view addSubview:_scrollView];
    
    UIView *viewHeader=[[UIView alloc] init];
    viewHeader.backgroundColor=ColorWhite;
    [_scrollView addSubview:viewHeader];
    
    float heightTitle=[SizeTools getStringHeight:@"H" Font:FontTitle];
    
    NSString *strAmount=@"账户总额:";
    UILabel *labAmount= [[UILabel alloc] init];
    labAmount.frame = CGRectMake(SpaceMediumSmall, SpaceMediumSmall, [SizeTools getStringWidth:strAmount Font:FontTitle], heightTitle);
    labAmount.font = FontTitle;
    labAmount.text = strAmount;
    [viewHeader addSubview:labAmount];
    
    NSString *strBalance=@"其中可用余额为:";
    UILabel *labBalance= [[UILabel alloc] init];
    labBalance.frame = CGRectMake(SpaceMediumSmall, CGRectGetMaxY(labAmount.frame)+SpaceSmall, [SizeTools getStringWidth:strBalance Font:FontTitle], heightTitle);
    labBalance.font = FontTitle;
    labBalance.text = strBalance;
    [viewHeader addSubview:labBalance];
    
    //总额文本
    _rentallabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labAmount.frame)+SpaceSmall, CGRectGetMinY(labAmount.frame), WidthScreen-CGRectGetMaxX(labAmount.frame)+SpaceMediumBig, heightTitle)];
    _rentallabel.font = FontTitle;
    [viewHeader addSubview:_rentallabel];
    
    //余额文本
    _balancelabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labBalance.frame)+SpaceSmall, CGRectGetMinY(labBalance.frame), WidthScreen-CGRectGetMaxX(labBalance.frame)+SpaceMediumBig, heightTitle)];
    _balancelabel.font = FontTitle;
    [viewHeader addSubview:_balancelabel];
    
    viewHeader.frame=CGRectMake(0, SpaceSmall/2, WidthScreen, CGRectGetMaxY(labBalance.frame)+SpaceMediumSmall);
    
    NSString *strRecharge=@"充值金额";
    UILabel *labRecharge= [[UILabel alloc] init];
    labRecharge.frame = CGRectMake(SpaceMediumSmall, CGRectGetMaxY(viewHeader.frame)+SpaceBig, [SizeTools getStringWidth:strRecharge Font:FontTitle], heightTitle);
    labRecharge.font = FontTitle;
    labRecharge.text = strRecharge;
    [_scrollView addSubview:labRecharge];
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7.0, 30)];
    
    _rechargeField = [[UITextField alloc] initWithFrame:CGRectMake(SpaceMediumSmall, CGRectGetMaxY(labRecharge.frame)+SpaceSmall,WidthScreen-SpaceMediumSmall*2, 30)];
    _rechargeField.borderStyle = UITextBorderStyleNone;
    _rechargeField.backgroundColor = [UIColor whiteColor];
    _rechargeField.layer.borderWidth = 0.8f;
    _rechargeField.layer.cornerRadius =3.0f;
    _rechargeField.layer.borderColor = ColorTextVice.CGColor;
    _rechargeField.layer.masksToBounds = YES;
    _rechargeField.placeholder = @"请输入充值金额";
    _rechargeField.font = FontTextContent;
    [_rechargeField setTag:1];
    _rechargeField.delegate = self;
    _rechargeField.leftViewMode=UITextFieldViewModeAlways;
    _rechargeField.leftView=leftview;
    _rechargeField.keyboardType = UIKeyboardTypeDecimalPad;
    [_scrollView addSubview:_rechargeField];
    
    UIButton *btnSure=[ToolButton CreateMainButton:CGRectMake(SpaceMediumSmall, CGRectGetMaxY(_rechargeField.frame)+SpaceMediumSmall, WidthScreen-SpaceMediumSmall*2, 35) withTitle:@"确定" withTarget:self withAction:@selector(SureClick)];
    [_scrollView addSubview:btnSure];
}
#pragma mark 确定点击触发方法
- (void)SureClick
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    [_rechargeField resignFirstResponder];
    
    _requestType = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"170" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:_rechargeField.text forKey:@"amount"];            // 申请金额
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

-(void)onNotOpen{
    [_viewBlack removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)onOpen{
    [_viewBlack removeFromSuperview];
    JXLROpenAccountViewController *openAccount = [[JXLROpenAccountViewController alloc] init];
    openAccount.openAccountType=OpenAccountTypeRecharge;
    openAccount.type=@"recharge";
    [self presentViewOrPushController:openAccount animated:YES completion:nil];
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    if(_requestType==1){
        [self showHudWitText:@"数据加载中..."];
    }else if(_requestType==2){
        [self showHudWitText:@"等待充值..."];
    }
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hidHud];
    NSDictionary *dics = obj;
    if (_requestType == 1) {
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
            
            NSString *strRent=[NSString stringWithFormat:@"%@元", [obj objectForKey:@"userBalance"]];
            NSMutableAttributedString *attrRent=[[NSMutableAttributedString alloc] initWithString:strRent];
            [attrRent addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, strRent.length)];
            [attrRent addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[strRent rangeOfString:@"元"]];
            _rentallabel.attributedText = attrRent;
            
            NSString *strBalance=[NSString stringWithFormat:@"%@元", [obj objectForKey:@"withdrawalAmount"]];
            NSMutableAttributedString *attrBalance=[[NSMutableAttributedString alloc] initWithString:strBalance];
            [attrBalance addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, strBalance.length)];
            [attrBalance addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[strBalance rangeOfString:@"元"]];
            _balancelabel.attributedText = attrBalance;
        }
    }
    else if (_requestType == 2)
    {
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"])
        {
            if (![[obj objectForKey:@"htmlParam"]isEqual:[NSNull null]] && [obj objectForKey:@"htmlParam"] != nil)
            {
                NSString *htmlParam = [NSString stringWithFormat:@"%@",[obj objectForKey:@"htmlParam"]];
                MyWebViewController *web = [[MyWebViewController alloc]init];
                web.html = htmlParam;
                web.type = @"2";
                [self.navigationController pushViewController:web animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            }
        
        }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-31"])
        {
            _viewBlack=[ToolBlackView createRemindWithTitle:@"请开通资金托管账户" withContent:@"开通资金托管账户，投资理财更安全！" withLeftText:@"暂不开通" withRightText:@"立即开通" withTarget:self withActionLeft:@selector(onNotOpen) withActionRight:@selector(onOpen)];
        }
        else {
            // 服务器返回数据异常
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
