//
//  WithdrawalViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心 --》账户管理 ---》提现
#import "WithdrawalViewController.h"

#import "ColorTools.h"
#import "AJComboBox.h"
#import "WithdrawRecordsViewController.h"
#import "BankCard.h"
#import "SetNewDealPassWordViewController.h"
#import "MSKeyboardScrollView.h"
#import "MyWebViewController.h"
#import "JXLROpenAccountViewController.h"
#import "ToolButton.h"
#import "ToolBlackView.h"

#define FontTitle FontTextContent

@interface WithdrawalViewController ()<UITextFieldDelegate, AJComboBoxDelegate, UIScrollViewDelegate, UITextViewDelegate, HTTPClientDelegate>
{
    NSArray *titleArr;
    NSMutableArray *cardArr;
    NSMutableArray *cardNameArr;
    
    int isOPT;
    NSInteger curr;   // 记录当前银行卡状态
    BOOL payPasswordStatus;  // 交易密码状态
}
@property (nonatomic,strong)UITextField *Withdrawfield;
@property (nonatomic,strong)UITextField *passwordield;
@property (nonatomic,strong)UILabel *rentallabel;
@property (nonatomic,strong)UILabel *balancelabel;
@property (nonatomic,strong)UILabel *yuanlabel1;
@property (nonatomic,strong)UILabel *yuanlabel2;
@property (nonatomic,strong)UILabel *balancelabel2;
@property (nonatomic,strong)AJComboBox *ComboBox;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UILabel *highLabel;
@property (nonatomic,strong)UITextView *cardInfoTextView;

@property (nonatomic,strong)UILabel *userBank;     // 开户银行
@property (nonatomic,strong)UILabel *userAccount;  // 账号
@property (nonatomic,strong)UILabel *userName;     // 收款人
@property (nonatomic, strong)UIButton *dealBtn;     // 交易密码按钮
@property (nonatomic,strong)UIView *viewBlack;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@end

@implementation WithdrawalViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    isOPT = 1;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    
    // 初始化视图
    [self initView];
}

/**
 * 初始化数据
 */
- (void)initData
{
    titleArr = @[@"账户总额:",@"其中可提现余额为:",@"提现金额"];//,@"选择提现银行卡",@"银行信息"
    cardArr = [[NSMutableArray alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //滚动视图
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-HeightNavigationAndStateBar)];
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
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];
    
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

    NSString *strRecharge=@"提现金额";
    UILabel *labRecharge= [[UILabel alloc] init];
    labRecharge.frame = CGRectMake(SpaceMediumSmall, CGRectGetMaxY(viewHeader.frame)+SpaceBig, [SizeTools getStringWidth:strRecharge Font:FontTitle], heightTitle);
    labRecharge.font = FontTitle;
    labRecharge.text = strRecharge;
    [_scrollView addSubview:labRecharge];
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7.0, 30)];
    
    _Withdrawfield = [[UITextField alloc] initWithFrame:CGRectMake(SpaceMediumSmall, CGRectGetMaxY(labRecharge.frame)+SpaceSmall,WidthScreen-SpaceMediumSmall*2, 30)];
    _Withdrawfield.borderStyle = UITextBorderStyleNone;
    _Withdrawfield.backgroundColor = [UIColor whiteColor];
    _Withdrawfield.layer.borderWidth = 0.8f;
    _Withdrawfield.layer.cornerRadius =3.0f;
    _Withdrawfield.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _Withdrawfield.layer.masksToBounds = YES;
    _Withdrawfield.placeholder = @"请输入提现金额";
    _Withdrawfield.font = [UIFont systemFontOfSize:15.0f];
    [_Withdrawfield setTag:1];
    _Withdrawfield.delegate = self;
    _Withdrawfield.keyboardType = UIKeyboardTypeDecimalPad;
    _Withdrawfield.leftViewMode=UITextFieldViewModeAlways;
    _Withdrawfield.leftView=leftview;
    [_scrollView addSubview:_Withdrawfield];
    
    _highLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_Withdrawfield.frame), CGRectGetMaxY(_Withdrawfield.frame)+SpaceSmall, WidthScreen-SpaceMediumSmall*2, heightTitle)];
    _highLabel.font = [UIFont systemFontOfSize:13.0f];
    _highLabel.textColor = ColorTextVice;
    [_scrollView addSubview:_highLabel];
    
    UIButton *btnSure=[ToolButton CreateMainButton:CGRectMake(SpaceMediumSmall, CGRectGetMaxY(_highLabel.frame)+SpaceMediumSmall, WidthScreen-SpaceMediumSmall*2, 35) withTitle:@"确定" withTarget:self withAction:@selector(SureClick)];
    [_scrollView addSubview:btnSure];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"提现";
    
    // 导航条右边按钮
    BarButtonItem *barDrawItem=[BarButtonItem barItemRightDefaultWithTitle:@"提现记录"  target:self action:@selector(WithdrawClick)];
    [self.navigationItem setRightBarButtonItem:barDrawItem];
}

#pragma 设置交易密码
- (void)dealClick {
    if (AppDelegateInstance.userInfo.isTeleStatus) {
        SetNewDealPassWordViewController *setDealPass = [[SetNewDealPassWordViewController alloc] init];
        setDealPass.ispayPasswordStatus = payPasswordStatus;
        setDealPass.statuStr = @"正常设置";
        [self.navigationController pushViewController:setDealPass animated:YES];
    }else {
        [SVProgressHUD showErrorWithStatus:@"亲，你还没有设置安全手机"];
    }
}

#pragma mark 单选框代理方法
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    if (comboBox.tag == 1) {
        //DLOG(@"selectedIndex -> %ld", (long)selectedIndex);
        
        BankCard *bankCark = cardArr[selectedIndex];
        curr = bankCark.bankCardId;
        _userBank.text = [NSString stringWithFormat:@"开户银行: %@", bankCark.bankName];
        _userAccount.text = [NSString stringWithFormat:@"账号: %@", bankCark.account];
        _userName.text = [NSString stringWithFormat:@"收款人: %@", bankCark.accountName];
    }
}

#pragma mark 确定点击触发方法
- (void)SureClick
{
    if(_Withdrawfield.text.floatValue==0){
        [SVProgressHUD showErrorWithStatus:@"对不起，无提现金额"];
        return;
    }
    
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    if (_Withdrawfield.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入提现金额！"];
        return;
    }
    
    if (_balancelabel.text.floatValue < _Withdrawfield.text.floatValue) {
        [SVProgressHUD showErrorWithStatus:@"对不起，已超出最大提现金额"];
        return;
    }
    
    if (_balancelabel.text.floatValue < _Withdrawfield.text.floatValue) {
        [SVProgressHUD showErrorWithStatus:@"对不起，已超出最大提现金额"];
        return;
    }
    
    [self ControlAction];
    
    
    isOPT = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"144" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
    [parameters setObject:_Withdrawfield.text forKey:@"amount"];            // 申请金额
    //        [parameters setObject:[NSString stringWithFormat:@"%d", curr] forKey:@"bankId"];            // 银行卡id
    //        [parameters setObject:[NSString encrypt3DES:_passwordield.text key:DESkey] forKey:@"payPassword"];       // 交易密码
    [parameters setObject:@"1" forKey:@"type"];             // 类型（默认为1）
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}


#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    // 收回文本键盘
    for (UITextField *textField in [_scrollView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
    
    for (UITextView *textView in [_scrollView subviews])
    {
        if ([textView isKindOfClass: [UITextView class]]) {
            
            [textView  resignFirstResponder];
        }
    }
}
#pragma mark 提现记录
- (void)WithdrawClick
{
    WithdrawRecordsViewController *WithdrawRecordsView = [[WithdrawRecordsViewController alloc] init];
    [self.navigationController pushViewController:WithdrawRecordsView animated:YES];
}

#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

-(void)onNotOpen{
    [_viewBlack removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)onOpen{
    [_viewBlack removeFromSuperview];
    JXLROpenAccountViewController *openAccount = [[JXLROpenAccountViewController alloc] init];
    openAccount.openAccountType=OpenAccountTypeWithdraw;
    [self presentViewOrPushController:openAccount animated:YES completion:nil];
}

#pragma  mark UIScrollViewdellegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _ComboBox.table.frame= CGRectMake(_ComboBox.frame.origin.x, _ComboBox.frame.origin.y+20-scrollView.contentOffset.y, _ComboBox.frame.size.width, [cardNameArr count]*30);
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    if(isOPT==1){
        [self showHudWitText:@"数据加载中..."];
    }else if(isOPT==2){
        [self showHudWitText:@"等待提现..."];
    }
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hidHud];
    NSDictionary *dics = obj;
    NSString *error = [NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]];
    
    if (isOPT == 1) {
        if ([error isEqualToString:@"-1"]) {
            payPasswordStatus = [[obj objectForKey:@"payPasswordStatus"] boolValue];
            if (!payPasswordStatus) {
                _dealBtn.userInteractionEnabled = YES;
                _dealBtn.alpha = 1;
            }else {
                _dealBtn.userInteractionEnabled = NO;
                _dealBtn.alpha = 0;
            }
            
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
            
            _highLabel.text = [NSString stringWithFormat:@"本次最高提现金额为: %.2f 元", [[obj objectForKey:@"withdrawalAmount"] floatValue]] ;
            
            cardNameArr = [[NSMutableArray alloc] init];
            NSArray *provinceArr = [dics objectForKey:@"bankList"];
            for (NSDictionary *item in provinceArr) {
                BankCard *bankCard = [[BankCard alloc] init];
                bankCard.bankCardId = [[item objectForKey:@"id"] intValue];
                bankCard.accountName = [item objectForKey:@"accountName"];
                bankCard.bankName = [item objectForKey:@"bankName"];
                bankCard.account = [item objectForKey:@"account"];
                
                [cardArr addObject:bankCard];
                //DLOG(@"%@", [item objectForKey:@"bankName"]);
                [cardNameArr addObject:[item objectForKey:@"bankName"]];
            }
            
            [_ComboBox setArrayData:cardNameArr];
            _ComboBox.table.frame= CGRectMake(_ComboBox.frame.origin.x, _ComboBox.frame.origin.y+90, _ComboBox.frame.size.width, [cardNameArr count]*30);
        }
        else {
            // 服务器返回数据异常
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
        
    }else if (isOPT == 2)
    {
        if ([error isEqualToString:@"-1"]) {
            
            //NSLog(@"提现返回 -> %@",dics);
            //NSLog(@"msg -> %@", [obj objectForKey:@"msg"]);
            
            if (![[obj objectForKey:@"htmlParam"]isEqual:[NSNull null]] && [obj objectForKey:@"htmlParam"] != nil)
            {
                NSString *htmlParam = [NSString stringWithFormat:@"%@",[obj objectForKey:@"htmlParam"]];
                MyWebViewController *web = [[MyWebViewController alloc]init];
                web.html = htmlParam;
                web.type = @"4";
                [self.navigationController pushViewController:web animated:YES];
                
                _Withdrawfield.text = @"";
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            }
        }
        else if ([error isEqualToString:@"-31"])//-31 未开户
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
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
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

@end
