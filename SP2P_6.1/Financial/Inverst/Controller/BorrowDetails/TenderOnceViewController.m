//
//  TenderOnceViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-24.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  投标

#import "TenderOnceViewController.h"
#import "ColorTools.h"
#import "LDProgressView.h"
#import "AccuontSafeViewController.h"
#import "MyWebViewController.h"
#import "JXLROpenAccountViewController.h"
#import "MyRechargeViewController.h"
#import "ToolBlackView.h"

#define NUMBERS @"0123456789.\n"

@interface TenderOnceViewController ()<UITextFieldDelegate,UIAlertViewDelegate,HTTPClientDelegate,UIScrollViewDelegate>
{

    NSArray *titleArr;
    NSInteger _num;
    NSNumber *progressnum;
    NSInteger isPayPwdSet;// 是否设置了交易密码
    NSInteger isdealPwdNeed;//投标是否需要交易密码

}
@property (nonatomic,strong)LDProgressView *progressView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *idLabel;
@property (nonatomic,strong)UILabel *borrowerLabel;
@property (nonatomic,strong)UIImageView *leveImg;
@property (nonatomic,strong)UILabel *rentalLabel;
@property (nonatomic,strong)UILabel *balancelLabel;
@property (nonatomic,strong)UITextField *TendermoneyField;
@property (nonatomic,strong)UITextField *passwordField;
@property (nonatomic,strong)UILabel *borrowsum;
@property (nonatomic,strong)UILabel *rateLabel;
@property (nonatomic,strong)UILabel *deadlineLabel;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UILabel *needLabel;
@property (nonatomic,strong)UILabel *thenLabel;
@property (nonatomic,strong)UILabel *minLabel;
@property (nonatomic,strong)UILabel *minValue;
@property (nonatomic,strong)UILabel *sumLabel;
@property (nonatomic,strong)UILabel *browseLabel;
@property (nonatomic,strong)UILabel *wayLabel;
@property (nonatomic,strong)UILabel *passwordLabel;
@property (nonatomic,strong)UIView *backView2;
@property (nonatomic,strong)UIScrollView  *scrollView;
@property (nonatomic,strong)UIButton *tenderBtn;
@property (nonatomic,strong)UILabel *needValueLabel; // 剩余份数
@property (nonatomic,strong)UILabel *TendermoneyLabel;
@property (nonatomic,strong)UIView *viewBlack;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation TenderOnceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
    _tenderBtn.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titleArr = @[@"借款金额:",@"年利率:",@"还款方式:",@"已投金额:",@"借款期限:",@"还需金额:",@"还款日期:"];
    
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
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  
    _num = 1;
    //获取投标相关信息接口(opt=15)
    [parameters setObject:@"15" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"borrowId"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];

    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
     
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    
    //滚动视图
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-HeightNavigationAndStateBar)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = ColorBGGray;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 505);
    [self.view addSubview:_scrollView];

    
    UIView *backView1  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 68)];
    backView1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView1];
    
    
    UIControl *viewControl1 = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl1 addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:viewControl1];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 220, 35)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [backView1 addSubview:_titleLabel];
    
    UILabel *idtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 10, 80, 30)];
    idtextLabel.text = @"编号:";
    idtextLabel.textColor = [UIColor lightGrayColor];
    idtextLabel.font = [UIFont systemFontOfSize:12.0f];
    idtextLabel.textAlignment = NSTextAlignmentLeft;
     [backView1 addSubview:idtextLabel];
    
    _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 10, 100, 30)];
    _idLabel.textColor = [UIColor lightGrayColor];
    _idLabel.font = [UIFont systemFontOfSize:12.0f];
    _idLabel.textAlignment = NSTextAlignmentLeft;
    _idLabel.text = _noId;
    [backView1 addSubview:_idLabel];
    
    UILabel *borrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 80, 30)];
    borrowLabel.text = @"借款人:";
    borrowLabel.textColor = [UIColor blackColor];
    borrowLabel.font = [UIFont systemFontOfSize:14.0f];
    borrowLabel.textAlignment = NSTextAlignmentLeft;
    [backView1 addSubview:borrowLabel];
    
    _borrowerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _borrowerLabel.textColor = [UIColor grayColor];
    _borrowerLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowerLabel.textAlignment = NSTextAlignmentLeft;
    [backView1 addSubview:_borrowerLabel];
  
   _leveImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [backView1 addSubview:_leveImg];
    
    _backView2  = [[UIView alloc] initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, 180)];
    _backView2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_backView2];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:_backView2.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView2 addSubview:viewControl];
    
    UILabel *rentalTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 100, 30)];
    rentalTextLabel.text = @"您的账户总额:";
    rentalTextLabel.textColor = ColorTextContent;
    rentalTextLabel.font = FontMedium;
    rentalTextLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:rentalTextLabel];
    
    _rentalLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, 150, 30)];
    _rentalLabel.textColor = PinkColor;
    _rentalLabel.font = [UIFont systemFontOfSize:14.0f];
    _rentalLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:_rentalLabel];
    
    UILabel *balanceTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 30)];
    balanceTextLabel.text = @"您的可用余额:";
    balanceTextLabel.textColor = ColorTextContent;
    balanceTextLabel.font = FontMedium;
    balanceTextLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:balanceTextLabel];
    
    _balancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 150, 30)];
    _balancelLabel.textColor = PinkColor;
    _balancelLabel.font = [UIFont systemFontOfSize:14.0f];
    _balancelLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:_balancelLabel];
    
    _needValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 100, 30)];
    _needValueLabel.textColor = ColorTextContent;
    _needValueLabel.font = FontMedium;
    _needValueLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:_needValueLabel];
    
    _TendermoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 100, 30)];
    _TendermoneyLabel.text = @"投标金额(元)";
    _TendermoneyLabel.textColor = ColorRedMain;
    _TendermoneyLabel.font = FontMedium;
    _TendermoneyLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:_TendermoneyLabel];
    
    _TendermoneyField = [[UITextField alloc] initWithFrame:CGRectMake(SpaceMediumSmall,170, WidthScreen-SpaceMediumSmall*2,35)];
    _TendermoneyField.font = FontTextContent;
    _TendermoneyField.delegate = self;
    _TendermoneyField.tag = 101;
    _TendermoneyField.placeholder = @"请输入投标金额";
    _TendermoneyField.borderStyle = UITextBorderStyleRoundedRect;
    _TendermoneyField.keyboardType = UIKeyboardTypeDecimalPad;
    _TendermoneyField.layer.borderColor=ColorTextVice.CGColor;
    _TendermoneyField.layer.borderWidth=1;
    [_scrollView addSubview:_TendermoneyField];
    
    _tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tenderBtn.frame = CGRectMake(SpaceMediumSmall, 215,WidthScreen-SpaceMediumSmall*2, 35);
    [_tenderBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [_tenderBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    [_tenderBtn setTitle:@"立即投标" forState:UIControlStateNormal];
    [_tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _tenderBtn.titleLabel.font = FontTextContent;
    [_tenderBtn.layer setMasksToBounds:YES];
    [_tenderBtn.layer setCornerRadius:3.0];
    [_tenderBtn addTarget:self action:@selector(tenderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_tenderBtn];
    
    _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(0, 255, self.view.frame.size.width, 10)];
    _progressView.color = ColorRedMain;
    _progressView.flat = @YES;// 是否扁平化
    _progressView.borderRadius = @0;
    _progressView.showBackgroundInnerShadow = @NO;
    _progressView.animate = @NO;
    _progressView.progressInset = @0;//内边的边距
    _progressView.showBackground = @NO;
    _progressView.outerStrokeWidth = @0;
    _progressView.showText = @YES;
    _progressView.showStroke = @NO;
    _progressView.background = [UIColor lightGrayColor];
    [_scrollView addSubview:_progressView];
    
    
    UIView *backView3  = [[UIView alloc] initWithFrame:CGRectMake(0, 270, self.view.frame.size.width, _scrollView.frame.size.height)];
    backView3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView3];
    
    UIControl *viewControl3 = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl3 addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [backView3 addSubview:viewControl3];
    
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 285 + i * 30,120, 20)];
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        if (i==5||i==6||i==4) {
            titleLabel.frame = CGRectMake(170, 285 + (i - 3) *30, 120, 20);
        }
        titleLabel.tag = 1000+i;
        [_scrollView addSubview:titleLabel];
    }
    
    _borrowsum = [[UILabel alloc] initWithFrame:CGRectMake(78, 280, 120, 30)];
    _borrowsum.textColor = [UIColor lightGrayColor];
    _borrowsum.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:_borrowsum];
    
    _rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 310, 120, 30)];
    _rateLabel.textColor = [UIColor lightGrayColor];
    _rateLabel.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:_rateLabel];
    
    _deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 310, 120, 30)];
    _deadlineLabel.textColor = [UIColor lightGrayColor];
    _deadlineLabel.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:_deadlineLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 370, 120, 30)];
    _dateLabel.textColor = [UIColor lightGrayColor];
    _dateLabel.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:_dateLabel];
    
    _needLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 340, 100, 30)];
    _needLabel.textColor = [UIColor lightGrayColor];
    _needLabel.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:_needLabel];
    
    _wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 340,93, 30)];
    _wayLabel.textColor = [UIColor lightGrayColor];
    _wayLabel.adjustsFontSizeToFitWidth = YES;
    _wayLabel.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:_wayLabel];
    
    _thenLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 370, 120, 30)];
    _thenLabel.textColor = [UIColor lightGrayColor];
    _thenLabel.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:_thenLabel];
    
    _minLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 405,120, 20)];
    _minLabel.textColor = [UIColor grayColor];
    _minLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_scrollView addSubview:_minLabel];
    
    _minValue = [[UILabel alloc] initWithFrame:CGRectZero];
    _minValue.textColor = [UIColor lightGrayColor];
    _minValue.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:_minValue];
    
    _sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 420, 250, 30)];
    _sumLabel.textColor = [UIColor lightGrayColor];
    _sumLabel.font = [UIFont systemFontOfSize:12.0f];
    [_scrollView addSubview:_sumLabel];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"投标";
}

-(void)onNotOpen{
    [_viewBlack removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)onOpen{
    [_viewBlack removeFromSuperview];
    JXLROpenAccountViewController *openAccount = [[JXLROpenAccountViewController alloc] init];
    openAccount.openAccountType=OpenAccountTypeTender;
    [self presentViewOrPushController:openAccount animated:YES completion:nil];
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    //NSLog(@"==投标返回=======%@",obj);
    //NSLog(@"msg ===========%@",[obj objectForKey:@"msg"]);
    
    NSDictionary *dics = obj;
    
    NSString *error = [NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]];
    
    if (_num == 1)
    {
        if ([error isEqualToString:@"-1"])
        {
            
            _titleLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"title"]];
            _borrowerLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"Name"]];
            
            NSArray *strArray = [[dics objectForKey:@"creditRating"] componentsSeparatedByString:@"/"];
            NSArray *strImageName=[strArray[strArray.count-1] componentsSeparatedByString:@"."];
            if(([strImageName[0] length])>0){
                [_leveImg setImage:[UIImage imageNamed:strImageName[0]]];
            }else{
                if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"creditRating"]] hasPrefix:@"http"]) {
                    [_leveImg  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dics objectForKey:@"creditRating"]]]];
                }else{
                    [_leveImg  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,[dics objectForKey:@"creditRating"]]]];
                }

            }
            _rentalLabel.text = [NSString stringWithFormat:@"¥ %@",[dics objectForKey:@"accountAmount"]];
            _balancelLabel.text = [NSString stringWithFormat:@"¥ %.2f",[[dics objectForKey:@"availableBalance"] floatValue]];
            
            _progressView.progress = [[dics objectForKey:@"schedules"] floatValue] /100;
            _borrowsum.text = [NSString stringWithFormat:@"¥ %@",[dics objectForKey:@"borrowAmount"]];
            _rateLabel.text =  [NSString stringWithFormat:@"%@%%",[dics objectForKey:@"annualRate"]];
            _deadlineLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"deadline"]];
            _wayLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"paymentMode"]];
            
            if ([[dics objectForKey:@"paymentTime"]  isEqual:[NSNull null]]) {
                _dateLabel.text  = @"";
                UILabel *textLabel = (UILabel *)[_scrollView viewWithTag:1006];
                [textLabel removeFromSuperview];
            }else {
                _dateLabel.text = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"paymentTime"]]substringWithRange:NSMakeRange(0, 10)];
            }
            //DLOG(@"_dateLabel.text is %@",_dateLabel.text);
            _needLabel.text =[NSString stringWithFormat:@"¥ %@", [dics objectForKey:@"needAmount"]];
            _thenLabel.text = [NSString stringWithFormat:@"¥ %@",[dics objectForKey:@"InvestmentAmount"]];
            _sumLabel.text = [NSString stringWithFormat:@"总投标数: %@ | 浏览量: %@",[dics objectForKey:@"investNum"],[dics objectForKey:@"views"]];
            isPayPwdSet = [[dics objectForKey:@"payPassword"] integerValue];
            isdealPwdNeed = [[dics objectForKey:@"isDealPassword"] integerValue];
            
            if (isdealPwdNeed == 1)
            {
                _passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 180, 100, 30)];
                _passwordLabel.text = @"交易密码";
                _passwordLabel.textColor = [UIColor blackColor];
                _passwordLabel.font = [UIFont boldSystemFontOfSize:14.0f];
                _passwordLabel.textAlignment = NSTextAlignmentLeft;
                [_scrollView addSubview:_passwordLabel];
                
                _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(115, 185, 125,25)];
                _passwordField.font = [UIFont systemFontOfSize:13.0f];
                _passwordField.delegate = self;
                _passwordField.placeholder = @"请输入交易密码";
                _passwordField.tag = 102;
                _passwordField.secureTextEntry = YES;
                _passwordField.borderStyle = UITextBorderStyleRoundedRect;
                [_scrollView addSubview:_passwordField];
            }
            
            if ([[dics objectForKey:@"minTenderedSum"] intValue] > 0) {
                _TendermoneyLabel.text=@"投标金额(元)";
                _minValue.frame = CGRectMake(105, 400, 120, 30);
                _minLabel.text = @"最低投标金额：";
                _minValue.text = [NSString stringWithFormat:@"¥ %@",[dics objectForKey:@"minTenderedSum"]];
            }else {
                _TendermoneyLabel.text=@"投标金额(份)";
                _minLabel.text = @"最小认购金额：";
                _minValue.frame = CGRectMake(105, 400, 120, 30);
                _minValue.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"needAmount"]];
                _needValueLabel.text = [NSString stringWithFormat:@"剩余份数：%@ 份",[dics objectForKey:@"needAccount"]];
            }
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font = [UIFont fontWithName:@"Arial" size:14];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize _label1Sz = [_borrowerLabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            _borrowerLabel.frame = CGRectMake(60, 40, _label1Sz.width + 10, 20);
            _leveImg.frame = CGRectMake(_borrowerLabel.frame.origin.x + _borrowerLabel.frame.size.width, 40, 20, 20);
            
        }else {

            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
        
    }else if (_num == 2)// 投标
    {
        
        if ([error isEqualToString:@"-1"])
        {
            if (![[obj objectForKey:@"htmlParam"]isEqual:[NSNull null]] && [obj objectForKey:@"htmlParam"] != nil)
            {
                NSString *htmlParam = [NSString stringWithFormat:@"%@",[obj objectForKey:@"htmlParam"]];
                MyWebViewController *web = [[MyWebViewController alloc]init];
                web.html = htmlParam;
                web.type = @"3";
                [self.navigationController pushViewController:web animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            }
        }
        else if ([error isEqualToString:@"-31"])
        {
             _tenderBtn.enabled = YES;

            _viewBlack=[ToolBlackView createRemindWithTitle:@"请开通资金托管账户" withContent:@"开通资金托管账户，投资理财更安全！" withLeftText:@"暂不开通" withRightText:@"立即开通" withTarget:self withActionLeft:@selector(onNotOpen) withActionRight:@selector(onOpen)];
        }
        else if ([error isEqualToString:@"-999"])
        {
             _tenderBtn.enabled = YES;
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"可用余额不足，是否现在充值？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 50;
            [alertView show];
            
        }
        
        else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
             _tenderBtn.enabled = YES;
        }
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    _tenderBtn.enabled = YES;

    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"服务器维护中"];

}


// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
    _tenderBtn.enabled = YES;
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    
    for (UITextField *textField in [self.scrollView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }
 
}


#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"bttonindex is %ld",(long)buttonIndex);
    
    if (alertView.tag == 50)
    {
        if (buttonIndex == 1)
        {
            MyRechargeViewController *RechargeView = [[MyRechargeViewController alloc] init];
            UINavigationController *NaVController = [[UINavigationController alloc] initWithRootViewController:RechargeView];
            [self presentViewController:NaVController animated:YES completion:nil];
        }
    }
    
}

#pragma 输入框代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma 限制只能输入数字和.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL canChange;
    if (textField.tag == 101) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        canChange = [string isEqualToString:filtered];
        
    }else {
        
        canChange = YES;
    
    }
    
    return canChange;
}

#pragma mark - 投标按钮
- (void)tenderBtnClick
{
    
    _tenderBtn.enabled = NO;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    _num = 2;
    //我要投标接口(opt=16)
    [parameters setObject:@"16" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_TendermoneyField.text forKey:@"amount"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"borrowId"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"userId"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma 返回按钮触发方法
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}
@end
