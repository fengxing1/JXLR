//
//  InterestcalculatorViewController.m
//  SP2P_6.1
//
//  Created by Kiu on 14-6-12.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  利率计算器

#import "InterestcalculatorViewController.h"

#import "ColorTools.h"
#import "AJComboBox.h"

#define fontSize  16.0f  //字体大小

@interface InterestcalculatorViewController ()<UIScrollViewDelegate,UITextFieldDelegate, HTTPClientDelegate, AJComboBoxDelegate>
{
    NSArray *selectArr;
    
    NSArray *titleArr1;
    NSArray *titleArr2;
    NSArray *titleArr3;
    NSArray *titleArr4;
    NSArray *titleArr5;  // 投标奖励
    NSArray *wayArr;
    
    BOOL isauto;
}
@property (nonatomic, strong)UITextField  *textField;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UILabel *titlelabel22;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *downView;
@property (nonatomic, strong)AJComboBox *repayment;
@property (nonatomic, strong)AJComboBox *touB;
@property (nonatomic, strong)UILabel *serviceFee;   // 管理费
@property (nonatomic, strong)UILabel *periodUnitLabel;   // 投标期限类型
@property (nonatomic, strong)UILabel *monPayLabel;
@property (nonatomic, strong)UILabel *amountValue;      // 投标总额
@property (nonatomic, strong)UILabel *earningValue;     // 年化收益
@property (nonatomic, strong)UILabel *interestValue;    // 总计利息
@property (nonatomic, strong)UILabel *awardValue;       // 投标奖励
@property (nonatomic, strong)UILabel *monPayValue;      // 每月还款
@property (nonatomic, strong)UILabel *sumValue;         // 总收益
@property (nonatomic, strong)UILabel *tLabel;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation InterestcalculatorViewController

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
    selectArr = @[@"等额本息",@"先息后本",@"一次性还款"];
    
    titleArr1 = @[@"投标金额",@"年利率", @"投标期限", @"还款方式", @"投标奖励",@""];
    titleArr2 = @[@"元", @"%"];
    titleArr3 = @[@"投标总额    |  ",@"年化收益:    |  ", @"总计利息:    |  ", @"投标奖励:    |  ",@"总收益    |  "];
    titleArr4 = @[@"请输入投标金额",@"请输入年化率",@"请输入投标期限",@"请输入投标奖励"];
    wayArr = @[@"等额本息",@"先息后本",@"一次性还款"];
    
    titleArr5 = @[@"固定奖励",@"奖励比例"];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    //滚动视图
    _scrollView =[[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = ColorBGGray;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 760);
    [self.view addSubview:_scrollView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(SpaceMediumSmall, SpaceMediumSmall, WidthScreen-SpaceMediumSmall*2, 320)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_topView.layer setMasksToBounds:YES];
    [_topView.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_scrollView addSubview:_topView];
    
    // 监听屏幕，释放键盘
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:viewControl];
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(10, 340, 300, 340)];
    _downView.backgroundColor = [UIColor whiteColor];
    [_downView.layer setMasksToBounds:YES];
    [_downView.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_scrollView addSubview:_downView];
    
    // 监听屏幕，释放键盘
    UIControl *viewControl1 = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl1 addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:viewControl1];
    
    for (int i = 0; i <= 5; i++) {
        
        UILabel *titlelabel11 = [[UILabel alloc] initWithFrame:CGRectMake(30, 20 + i * 40, 70, 30)];
        titlelabel11.text = [titleArr1 objectAtIndex:i];
        titlelabel11.textAlignment = NSTextAlignmentRight;
        titlelabel11.font = [UIFont systemFontOfSize:fontSize];
        titlelabel11.backgroundColor = [UIColor clearColor];
        
        [_topView addSubview:titlelabel11];
        
        UILabel *titlelabel12 = [[UILabel alloc] initWithFrame:CGRectMake(_topView.frame.size.width*0.5 + 15, 20 + i * 40, 100, 30)];
        if (i==0) {
            titlelabel12.text = [titleArr2 objectAtIndex:0];
        }else if(i==1) {
            titlelabel12.text = [titleArr2 objectAtIndex:1];
            
        }else {
            titlelabel12.text = @" ";
        }
        titlelabel12.textAlignment = NSTextAlignmentRight;
        titlelabel12.font = [UIFont systemFontOfSize:fontSize];
        titlelabel12.backgroundColor = [UIColor clearColor];
        [_topView addSubview:titlelabel12];
    }
    
    _periodUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_topView.frame.size.width - 65, 100, 30, 30)];
    _periodUnitLabel.textAlignment = NSTextAlignmentRight;
    _periodUnitLabel.font = [UIFont systemFontOfSize:fontSize];
    _periodUnitLabel.backgroundColor = [UIColor clearColor];
    [_topView addSubview:_periodUnitLabel];
    
    for (int i = 0; i < 4; i++) {
        //第一表格输入文本框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        if (i > 2) {
            textField.frame = CGRectMake(_topView.frame.size.width * 0.5 - 45, 108 + i * 40, 140, 35);
        }else {
            textField.frame = CGRectMake(_topView.frame.size.width * 0.5 - 45, 18 + i * 40, 140, 35);
        }
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.delegate = self;
        textField.placeholder = [titleArr4 objectAtIndex:i];
        textField.font = [UIFont systemFontOfSize:12.0f];
        [textField setTag:100 + i];
        textField.text = @"";
        [_topView addSubview:textField];
    }
    
    // 还款方式
    _repayment = [[AJComboBox alloc] initWithFrame:CGRectMake(_topView.frame.size.width * 0.5 - 45, 138, 140, 35)];
    _repayment.table.frame= CGRectMake(_repayment.frame.origin.x + 10, _repayment.frame.origin.y + 85, _repayment.frame.size.width, 90);
    [_repayment setLabelText:@"- 请选择 -"];
    [_repayment setDelegate:self];
    _repayment.tag = 110;
    [_repayment setArrayData:selectArr];
    [_topView addSubview:_repayment];
    
    // 投标奖励
    _touB = [[AJComboBox alloc] initWithFrame:CGRectMake(_topView.frame.size.width * 0.5 - 45, 183, 140, 35)];
    _touB.table.frame= CGRectMake(_repayment.frame.origin.x + 10, _repayment.frame.origin.y + 85, _repayment.frame.size.width, 60);
    [_touB setLabelText:@"- 请选择 -"];
    [_touB setDelegate:self];
    _touB.tag = 111;
    [_touB setArrayData:titleArr5];
    [_topView addSubview:_touB];
    
    _tLabel = [[UILabel alloc] initWithFrame:CGRectMake(_topView.frame.size.width - 55, 230, 20, 30)];
    _tLabel.textAlignment = NSTextAlignmentRight;
    _tLabel.font = [UIFont systemFontOfSize:fontSize];
    _tLabel.backgroundColor = [UIColor clearColor];
    [_topView addSubview:_tLabel];
    
    // 计算 按钮
    
    UIButton *calculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calculateBtn.frame = CGRectMake(SpaceBig, 275, CGRectGetWidth(_topView.frame)-SpaceBig*2, 30);
    [calculateBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [calculateBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    [calculateBtn setTitle:@"计 算" forState:UIControlStateNormal];
    [calculateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    calculateBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [calculateBtn.layer setMasksToBounds:YES];
    [calculateBtn.layer setCornerRadius:3.0];
    [calculateBtn addTarget:self action:@selector(calculateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:calculateBtn];
    
    // 标题文本
    UILabel *heardlabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 40)];
    heardlabel.text = @"计算结果";
    heardlabel.textAlignment = NSTextAlignmentCenter;
    [heardlabel.layer setMasksToBounds:YES];
    [heardlabel.layer setCornerRadius:5.0f];
    heardlabel.font = [UIFont boldSystemFontOfSize:fontSize];
    heardlabel.backgroundColor = SETCOLOR(230, 230, 230, 1);
    [_downView addSubview:heardlabel];
    
    // 计算结果 -> 左边文案
    for (int k = 0; k < 5; k++) {
        UILabel *titlelabel21 = [[UILabel alloc] initWithFrame:CGRectZero];
        
        if (k == 4) {
            titlelabel21.frame = CGRectMake(_downView.frame.size.width * 0.5 - 120, 225, 120, 100);
        }else {
            titlelabel21.frame = CGRectMake(_downView.frame.size.width * 0.5 - 120, 25 + k * 40, 120, 100);
        }
        
        titlelabel21.text = [titleArr3 objectAtIndex:k];
        titlelabel21.textAlignment = NSTextAlignmentRight;
        titlelabel21.numberOfLines = 0;
        titlelabel21.lineBreakMode = NSLineBreakByCharWrapping;
        titlelabel21.font = [UIFont systemFontOfSize:fontSize];
        titlelabel21.backgroundColor = [UIColor clearColor];
        [_downView addSubview:titlelabel21];
    }
    
    _monPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(_downView.frame.size.width * 0.5 - 120, 185, 120, 100)];
    _monPayLabel.textAlignment = NSTextAlignmentRight;
    _monPayLabel.font = [UIFont systemFontOfSize:fontSize];
    _monPayLabel.backgroundColor = [UIColor clearColor];
    _monPayLabel.text = @"月还本息:    |  ";
    [_downView addSubview:_monPayLabel];
    
    // 投标总额 (计算出来的值)
    _amountValue = [[UILabel alloc] initWithFrame:CGRectMake(_downView.frame.size.width * 0.5 + 20, 60, 120, 30)];
    _amountValue.textAlignment = NSTextAlignmentLeft;
    _amountValue.font = [UIFont systemFontOfSize:fontSize];
    [_amountValue setTextColor:[UIColor redColor]];
    [_downView addSubview:_amountValue];
    
    // 年化收益 (计算出来的值)
    _earningValue = [[UILabel alloc] initWithFrame:CGRectMake(_downView.frame.size.width * 0.5 + 20, 100, 120, 30)];
    _earningValue.textAlignment = NSTextAlignmentLeft;
    _earningValue.font = [UIFont systemFontOfSize:fontSize];
    [_earningValue setTextColor:[UIColor redColor]];
    [_downView addSubview:_earningValue];
    
    // 总计利息 (计算出来的值)
    _interestValue = [[UILabel alloc] initWithFrame:CGRectMake(_downView.frame.size.width * 0.5 + 20, 140, 120, 30)];
    _interestValue.textAlignment = NSTextAlignmentLeft;
    _interestValue.font = [UIFont systemFontOfSize:fontSize];
    [_interestValue setTextColor:[UIColor redColor]];
    [_downView addSubview:_interestValue];
    
    // 投标奖励 (计算出来的值)
    _awardValue = [[UILabel alloc] initWithFrame:CGRectMake(_downView.frame.size.width * 0.5 + 20, 180, 120, 30)];
    _awardValue.textAlignment = NSTextAlignmentLeft;
    _awardValue.font = [UIFont systemFontOfSize:fontSize];
    [_awardValue setTextColor:[UIColor redColor]];
    [_downView addSubview:_awardValue];
    
    // 每月还款 (计算出来的值)
    _monPayValue = [[UILabel alloc] initWithFrame:CGRectMake(_downView.frame.size.width * 0.5 + 20, 220, 120, 30)];
    _monPayValue.textAlignment = NSTextAlignmentLeft;
    _monPayValue.font = [UIFont systemFontOfSize:fontSize];
    [_monPayValue setTextColor:[UIColor redColor]];
    [_downView addSubview:_monPayValue];
    
    // 总收益 (计算出来的值)
    _sumValue = [[UILabel alloc] initWithFrame:CGRectMake(_downView.frame.size.width * 0.5 + 20, 260, 120, 30)];
    _sumValue.textAlignment = NSTextAlignmentLeft;
    _sumValue.font = [UIFont systemFontOfSize:fontSize];
    [_sumValue setTextColor:[UIColor redColor]];
    [_downView addSubview:_sumValue];
    
    for (int j = 0; j <= 5; j++) {
        
        UILabel *titlelabel23 = [[UILabel alloc] initWithFrame:CGRectMake(_downView.frame.size.width*0.5 + 100, 60 + j * 40, 100, 30)];
        if (j==1) {
            titlelabel23.text = [titleArr2 objectAtIndex:1];
        }
        else
            titlelabel23.text = [titleArr2 objectAtIndex:0];
        if (j==5) {
            titlelabel23.text = nil;
        }
        titlelabel23.font = [UIFont systemFontOfSize:fontSize];
        titlelabel23.backgroundColor = [UIColor clearColor];
        [_downView addSubview:titlelabel23];
    }
    
    _serviceFee = [[UILabel alloc] initWithFrame:CGRectMake(_downView.frame.size.width * 0.5 - 140, 280, 130, 30)];
    _serviceFee.textAlignment = NSTextAlignmentRight;
    _serviceFee.textColor = [UIColor lightGrayColor];
    _serviceFee.font = [UIFont systemFontOfSize:10];
    [_downView addSubview:_serviceFee];
    
    if (_status) {
        [self setValue];
    }else {
        _periodUnitLabel.text = @"月";
        _deadperiodUnit = 0;
    }
}

- (void)setValue {
    // 赋值, 直接输入相关参数
    
    //通过tag获取控件对象
    UITextField *textfield1 = (UITextField *)[_topView viewWithTag:100];
    UITextField *textfield2 = (UITextField *)[_topView viewWithTag:101];
    UITextField *textfield3 = (UITextField *)[_topView viewWithTag:102];
    UITextField *textfield4 = (UITextField *)[_topView viewWithTag:103];
    textfield1.text = _bidAmout;
    textfield2.text = _apr;
    textfield3.text = _deadLine;
    
    //DLOG(@"_deadperiodUnit -> %d", _deadperiodUnit);
    
    switch (_deadperiodUnit) {
        case -1:
            _periodUnitLabel.text = @"年";
            
            break;
        case 0:
            _periodUnitLabel.text = @"月";
            
            break;
        case 1:
            _periodUnitLabel.text = @"日";
            break;
    }
    
    [_repayment setLabelText:[NSString stringWithFormat:@"%@", selectArr[_repayType - 1]]];
    
    if (_deadType == 0) {
        
    }else if (_deadType == 1) {
        [_touB setLabelText:[NSString stringWithFormat:@"%@", titleArr5[0]]];
        _tLabel.text = @"元";
        textfield4.text = [NSString stringWithFormat:@"%.2f", _bonus];
    }else {
        [_touB setLabelText:[NSString stringWithFormat:@"%@", titleArr5[1]]];
        _tLabel.text = @"%";
        textfield4.text = [NSString stringWithFormat:@"%.0f", _awardScale];
    }
    
    // 根据还款方式类型，判断下面文案。
    if ((_repayType - 1) == 0) {
        _monPayLabel.text = @"月还本息:    |  ";
    }else if ((_repayType - 1) == 1) {
        _monPayLabel.text = @"月还利息:    |  ";
    }else if ((_repayType - 1) == 2) {
        _monPayLabel.text = @"应还本息:    |  ";
    }
    
    [self loadRequest];
}

#pragma mark -
#pragma mark AJComboBoxDelegate

-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    
    if (comboBox.tag == 111) {
        isauto = YES;
        
        if (_touB.selectedIndex == 0) {
            _tLabel.text = @"元";
            _deadType = 1;
        }else {
            _tLabel.text = @"%";
            _deadType = 2;
        }
        //DLOG(@"_touB.selectedIndex -> %ld", (long)_touB.selectedIndex);
    }else {
        _repayType = _repayment.selectedIndex + 1;
        
        //DLOG(@"_repayType -> %lu", (unsigned long)_repayType);
        
        switch (_repayment.selectedIndex) {
            case 0:
                _monPayLabel.text = @"月还本息:    |  ";
                break;
            case 1:
                _monPayLabel.text = @"月还利息:    |  ";
                break;
            case 2:
                _monPayLabel.text = @"应还本息:    |  ";
                break;
        }
    }
}

#pragma  mark UIScrollViewdellegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _repayment.table.frame = CGRectMake(_repayment.frame.origin.x + 10, _repayment.frame.origin.y + 45 - scrollView.contentOffset.y, _repayment.frame.size.width, 90);
    _touB.table.frame = CGRectMake(_touB.frame.origin.x + 10, _touB.frame.origin.y + 45 - scrollView.contentOffset.y, _touB.frame.size.width, 60);
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"利率计算器";
}

#pragma 点击计算按钮触发方法
- (void)calculateBtnClick:(UIButton *)btn
{
    //DLOG(@"计算");
    
    //通过tag获取控件对象
    UITextField *textfield1 = (UITextField *)[_topView viewWithTag:100];
    UITextField *textfield2 = (UITextField *)[_topView viewWithTag:101];
    UITextField *textfield3 = (UITextField *)[_topView viewWithTag:102];
    UITextField *textfield4 = (UITextField *)[_topView viewWithTag:103];
    
    //判断输入框输入状态
    if ([textfield1.text length]==0||[textfield2.text length]==0||[textfield3.text length]==0)
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入完整信息后再进行计算！"];
        
    }else {
        
        _bidAmout = textfield1.text;
        _apr = textfield2.text;

        if (isauto) {
            if (_touB.selectedIndex == 0) {
                _bonus = [textfield4.text floatValue];
            }else {
                _awardScale = [textfield4.text floatValue];
                
                //DLOG(@"_awardScale -> %.2f", _awardScale);
            }
        }
        
        [self loadRequest];
    }
}

- (void)loadRequest {
    
    UITextField *textfield3 = (UITextField *)[_topView viewWithTag:102];
    
    if (_deadperiodUnit == -1) {
        _deadLine = [NSString stringWithFormat:@"%d",[textfield3.text intValue] * 12];
    }else{
        _deadLine = textfield3.text;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //利率计算器接口
    [parameters setObject:@"22" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_bidAmout forKey:@"amount"];
    [parameters setObject:_apr forKey:@"apr"];
    [parameters setObject:_deadLine forKey:@"deadline"];
    [parameters setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_repayType] forKey:@"repayType"];
    
    if (self.deadperiodUnit==1) {
        [parameters setObject:@"1" forKey:@"loadType"];
    }else{
        [parameters setObject:@"2" forKey:@"loadType"];
    }
    
    
    if (_deadType == 0) {
        
        
    }else if (_deadType == 1){
        
        [parameters setObject:[NSString stringWithFormat:@"%.2f", _bonus] forKey:@"bonus"];
        
    }else if (_deadType == 2){
        
        [parameters setObject:[NSString stringWithFormat:@"%.2f", _awardScale * 0.01] forKey:@"awardScale"];
        
        //DLOG(@"kkkkkk -> %.2f", _awardScale);
    }
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma 文本框协议代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark 点击空白处收回键盘
- (void)controlAction
{
    
    for (UITextField *textField in [_topView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }
    
    for (UITextField *textField in [_downView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }
    
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        //DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
        
        _amountValue.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"amount"]];
        _earningValue.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"earning"]];
        _interestValue.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"interest"] floatValue]];
        _awardValue.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"award"]];
        _monPayValue.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"monPay"] floatValue]];
        _sumValue.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"sum"]];
        _serviceFee.text = [NSString stringWithFormat:@"(扣除%.2f元管理费)", [[obj objectForKey:@"serviceFee"] floatValue]];
        
    }else {
        
        //DLOG(@"返回失败===========%@",[obj objectForKey:@"msg"]);
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
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
