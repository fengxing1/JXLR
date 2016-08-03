//
//  ReleaseBorrowInfoViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  发布借款
#import "ReleaseBorrowInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorTools.h"
#import "AJComboBox.h"
#import "QCheckBox.h"
#import "ReleaseSuccessViewController.h"
#import "RechargeViewController.h"
#import "NetWorkConfig.h"
#import "MSKeyboardScrollView.h"
#import "MyWebViewController.h"
#import "JXLROpenAccountViewController.h"
#import "MyRechargeViewController.h"
#import "ToolButton.h"
#import "ToolBlackView.h"

#define NUMBERS @"0123456789.\n"
#define FontLeftText FontTextContent //左侧字体
#define ColorLeftText ColorTextContent // 左侧文字颜色
#define ColorTextFieldBorder ColorTextVice //输入框边缘颜色
#define FontTip [UIFont boldSystemFontOfSize:12.0f] //提示文字大小
#define ColorTip ColorTextVice //提示文字颜色

@interface ReleaseBorrowInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AJComboBoxDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,HTTPClientDelegate,UITextViewDelegate,QCheckBoxDelegate>
{
    
    NSArray *unitsArr;
    NSArray *yearArr;
    NSArray *monthArr;
    NSArray *dayArr;
    NSInteger _num;
    float  _amountNum; //借款金额
    float  _aprNum;    //借款利率
    float  _peroidNum; //借款期限
    NSInteger _unitNum;//借款单元
    NSInteger _rtypeNum; //借款类型
    
}
@property (nonatomic,strong) MSKeyboardScrollView *scrollView;
@property (nonatomic,strong) AJComboBox *ComboBox;
@property (nonatomic,strong) AJComboBox *deadlineComboBox;
@property (nonatomic,strong) AJComboBox *unitsComboBox;
@property (nonatomic,strong) AJComboBox *fullScaleComboBox;
@property (nonatomic,strong) AJComboBox *wayComboBox;
@property (nonatomic,strong) QCheckBox *check1;
@property (nonatomic,strong) QCheckBox *check2;
@property (nonatomic,strong) UITextField *titleField;
@property (nonatomic,strong)  UITextField *moneyField;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *purposeIdArr;
@property (nonatomic,strong) NSArray *limitTimeArr;
//@property (nonatomic,strong) NSArray *unitsArr;
@property (nonatomic,strong) NSMutableArray *wayArr;
@property (nonatomic,strong) NSMutableArray *repaymentIdArr;//还款方式ID
@property (nonatomic,strong) NSArray *fullDateArr;
@property (nonatomic,strong) UITextView *averagetextView;//拆分分数
@property (nonatomic,strong) UITextView *ratetextView; //利率范围
@property (nonatomic,strong) UITextView *MintextView; //最小投标金额
@property (nonatomic,strong) UITextField *MinmoneyField;//最小投标金额
@property (nonatomic,strong) UITextField *averageField; //平均份额
@property (nonatomic,strong) UITextField *rateField; //利率
@property (nonatomic,strong) UILabel *interestLabel;  //实际利息
@property (nonatomic,strong) QCheckBox *norewardCheckBox;//不设置奖金
@property (nonatomic,strong) QCheckBox *fixedCheckBox; //设置固定奖金
@property (nonatomic,strong) QCheckBox *totalCheckBox; //比例分配
@property (nonatomic,strong) UITextView *detailstextView;//借款详情
//@property (nonatomic,strong) UITextField *fixedField; //固定奖金
//@property (nonatomic,strong) UITextField *totalField; //比例奖金
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) NSMutableArray *requireArr;
@property (nonatomic,strong) UIButton *postBtnBtn;
@property (nonatomic,strong) NetWorkClient *requestClient;


@property (nonatomic,copy) NSString *purposeIdStr;	//借款用途id
@property (nonatomic,copy) NSString *titleStr;	//	标题
@property (nonatomic,copy) NSString *amountStr;	//	借款金额
@property (nonatomic,copy) NSString *periodUnitStr;	//	借款期限单位
@property (nonatomic,copy) NSString *periodStr;	//	借款期限
@property (nonatomic,copy) NSString *repaymentIdStr;	//	还款方式id
@property (nonatomic,copy) NSString *minInvestAmountStr;	//	最少投标金额
@property (nonatomic,copy) NSString *averageInvestAmountStr;	//	平价金额招标
@property (nonatomic,copy) NSString *investPeriodStr;	//	满标期限id
@property (nonatomic,copy) NSString *aprStr;	//	年利率
@property (nonatomic,copy) NSString *imageFilenameStr;	//	图片路径
@property (nonatomic,copy) NSString *descriptionStr;	//	内容描述
@property (nonatomic,copy) NSString *bonusTypeStr;	//	设置投标奖励id
@property (nonatomic,copy) NSString *awardScaleStr;	//	设置奖金比例
@property (nonatomic,copy) NSString *bonusStr;	//	设置固定奖金
@property (nonatomic,copy) NSString *productIdStr;	//	产品id
@property (nonatomic,copy) NSString *userIdStr;	//	用户id
@property (nonatomic,copy) NSString *borrowImgStr;
@property (nonatomic,copy) NSString *typeImgStr; //图片上传类型
@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *backView2;
@property (nonatomic,strong) UILabel *uiLabel;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong)UIView *viewBlack;
@end

@implementation ReleaseBorrowInfoViewController

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
    _bonusTypeStr = 0;
    _amountNum = 0;
    _aprNum = 0;
    _peroidNum = 0;
    _unitNum = 0;
    _rtypeNum = 0;
    
    //    _unitsArr = [[NSArray alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    _purposeIdArr = [[NSMutableArray alloc] init];
    _repaymentIdArr = [[NSMutableArray alloc] init];
    _limitTimeArr = [[NSArray alloc] init];
    unitsArr =  @[@"年",@"月",@"日"];
    _fullDateArr = [[NSArray alloc] init];
    _wayArr = [[NSMutableArray alloc] init];
    _productIdStr = [[NSString alloc] init];
    _requireArr = [[NSMutableArray alloc] init];
    _borrowImgStr = [[NSString alloc] init];
    _typeImgStr = [[NSString alloc] init];
    
    _num =1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    3.3客户端获取发布借款当前状态接口（OPT=20）
    [parameters setObject:@"20" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",self.productID]   forKey:@"productId"];
    
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

    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HeightScreen-HeightNavigationAndStateBar)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = ColorBGGray;
    [self.view addSubview:_scrollView];
    
    UIControl *viewControl111 = [[UIControl alloc] initWithFrame:_scrollView.bounds];
    [viewControl111 addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl111];
    
    _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    _backView1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_backView1];
    
    // 释放键盘
    UIControl *viewControl1 = [[UIControl alloc] initWithFrame:_backView1.bounds];
    [viewControl1 addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView1 addSubview:viewControl1];
    
    UITextView *titletextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+2, 30)];
    titletextView.backgroundColor = ColorRedMain;
    titletextView.text = @"借款标基本信息";
    titletextView.font = [UIFont boldSystemFontOfSize:13.0f];
    titletextView.textColor = [UIColor whiteColor];
    titletextView.userInteractionEnabled = NO;
    [_backView1 addSubview:titletextView];
    
    UILabel  *textlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 80,30)];
    textlabel1.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel1.font = FontLeftText;
    textlabel1.text = @"借款用途:";
    textlabel1.textColor=ColorLeftText;
    [_backView1 addSubview:textlabel1];
    
    //借款用途选择框
    _ComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(90, 37, 130, 26)];
    [_ComboBox setLabelText:@"选择借款用途"];
    [_ComboBox setTag:201];
    [_ComboBox setDelegate:self];
    _ComboBox.layer.borderColor=ColorTextVice.CGColor;
    [_scrollView addSubview:_ComboBox];
    
    UILabel  *textlabel11 = [[UILabel alloc] initWithFrame:CGRectMake(20, 72, 80,30)];
    textlabel11.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel11.font = FontLeftText;
    textlabel11.text = @"借款标题:";
    textlabel11.textColor=ColorLeftText;
    [_scrollView addSubview:textlabel11];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(SpaceBig, 95, self.view.frame.size.width-SpaceMediumSmall*3, 35)];
    textView.textColor = ColorTip;
    textView.text = @"不超过24个汉字,重视标题描述,能加快借款标满标。";
    textView.font = FontTip;
    textView.userInteractionEnabled = NO;
    [_scrollView addSubview:textView];
    
    //标题输入框
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(90, 74, WidthScreen-90-SpaceBig,25)];
    _titleField.font = FontLeftText;
    _titleField.textColor=ColorLeftText;
    _titleField.delegate = self;
    _titleField.placeholder = @"请输入标题";
    _titleField.tag = 301;
    _titleField.borderStyle = UITextBorderStyleNone;
    _titleField.layer.borderWidth = HeightLine;
    _titleField.layer.borderColor=ColorTextFieldBorder.CGColor;
//    _titleField.layer.cornerRadius = 2.0f;
//    _titleField.layer.masksToBounds=YES;
    _titleField.leftViewMode=UITextFieldViewModeAlways;
    _titleField.leftView=[self createLeftView];
    [_scrollView addSubview:_titleField];
    
    UILabel  *textlabel12 = [[UILabel alloc] initWithFrame:CGRectMake(20, 128, 80,30)];
    textlabel12.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel12.font = FontLeftText;
    textlabel12.textColor=ColorLeftText;
    textlabel12.text = @"借款金额:";
    [_scrollView addSubview:textlabel12];
    
    UITextView *textView2 = [[UITextView alloc] initWithFrame:CGRectMake(85, 150, 190, 22)];
    textView2.textColor = [UIColor lightGrayColor];
    textView2.text = self.edfwStr;
    textView2.font = [UIFont boldSystemFontOfSize:11.0f];
    textView2.userInteractionEnabled = NO;
    [_scrollView addSubview:textView2];
    
    //借款金额
    _moneyField = [[UITextField alloc] initWithFrame:CGRectMake(90, 130, WidthScreen-90-SpaceBig-SpaceMediumBig,25)];
    _moneyField.font = FontLeftText;
    _moneyField.textColor=ColorLeftText;
    _moneyField.delegate = self;
    _moneyField.tag = 302;
    _moneyField.placeholder = @"请输入金额";
    _moneyField.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyField.borderStyle = UITextBorderStyleNone;
    _moneyField.layer.borderWidth = HeightLine;
    _moneyField.layer.borderColor=ColorTextFieldBorder.CGColor;
    _moneyField.leftView=[self createLeftView];
    _moneyField.leftViewMode=UITextFieldViewModeAlways;
    [_moneyField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    [_scrollView addSubview:_moneyField];
    
    UILabel  *textlabel14 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_moneyField.frame)+SpaceSmall, 130, SpaceMediumBig,25)];
    textlabel14.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel14.font = FontLeftText;
    textlabel14.text = @"元";
    textlabel14.textColor = ColorLeftText;
    [_scrollView addSubview:textlabel14];
    
    UILabel *textlabel13 = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, 80,30)];
    textlabel13.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel13.font = FontLeftText;
    textlabel13.text = @"借款期限:";
    textlabel12.textColor=ColorLeftText;
    [_scrollView addSubview:textlabel13];
    
    //年月日单位选择框
    _unitsComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(90, 172, (WidthScreen-90-SpaceBig-SpaceSmall)/2, 26)];
    
    if (_isRepayment) {
        [_unitsComboBox setLabelText:@"日"];
        _unitsComboBox.userInteractionEnabled = NO;
        _periodUnitStr = @"1";
        
    }else {
        [_unitsComboBox setLabelText:@"-请选择-"];
        _unitsComboBox.userInteractionEnabled = YES;
    }
    
    [_unitsComboBox setDelegate:self];
    [_unitsComboBox setTag:202];
    [_unitsComboBox setArrayData:unitsArr];
    [_scrollView addSubview:_unitsComboBox];
    
    //时长选择框
    _deadlineComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_unitsComboBox.frame)+SpaceSmall, 172, CGRectGetWidth(_unitsComboBox.frame), 26)];
    [_deadlineComboBox setLabelText:@"-请选择-"];
    [_deadlineComboBox setDelegate:self];
    [_deadlineComboBox setTag:203];
    //    [_deadlineComboBox setArrayData:_limitTimeArr];
    [_scrollView addSubview:_deadlineComboBox];
    
    UILabel  *waylabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 80,30)];
    waylabel.lineBreakMode = NSLineBreakByCharWrapping;
    waylabel.font = FontLeftText;
    waylabel.textColor=ColorLeftText;
    waylabel.text = @"还款方式:";
    [_backView1 addSubview:waylabel];
    
    //还款方式选择框
    _wayComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(90, 212, 130, 26)];
    
    if (_isRepayment) {
        [_wayComboBox setLabelText:@"一次性还款"];
        _wayComboBox.userInteractionEnabled = NO;
        _repaymentIdStr = @"3";
    }else {
        [_wayComboBox setLabelText:@"选择还款方式"];
        _wayComboBox.userInteractionEnabled = YES;
    }
    
    [_wayComboBox setDelegate:self];
    [_wayComboBox setTag:204];
    [_scrollView addSubview:_wayComboBox];
    
    //单选按钮
    _check1 = [[QCheckBox alloc] initWithDelegate:self];
    _check1.frame = CGRectMake(20, 255, 150, 25);
    [_check1 setTag:101];
    _check1.checked = 1;
    [_check1 setTitle:@"按最低金额招标" forState:UIControlStateNormal];
    [_check1 setTitleColor:ColorLeftText forState:UIControlStateNormal];
    [_check1.titleLabel setFont:FontLeftText];
    [_check1 setImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
    [_check1 setImage:[UIImage imageNamed:@"checkbox2_checked"] forState:UIControlStateSelected];
    [_scrollView addSubview:_check1];
    
    UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(25, 285, 100,30)];
    textlabel2.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel2.font = FontLeftText;
    textlabel2.textColor = ColorLeftText;
    textlabel2.text = @"最低投标金额";
    [_scrollView addSubview:textlabel2];
    
    //最低投标金额
    _MinmoneyField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textlabel2.frame)+SpaceSmall, 288, 140,25)];
    _MinmoneyField.font = FontLeftText;
    _MinmoneyField.textColor=ColorLeftText;
    _MinmoneyField.delegate = self;
    _MinmoneyField.tag = 303;
    _MinmoneyField.placeholder = @"请输入金额";
    _MinmoneyField.borderStyle = UITextBorderStyleNone;
    _MinmoneyField.layer.borderWidth = HeightLine;
    _MinmoneyField.layer.borderColor=ColorTextFieldBorder.CGColor;
    _MinmoneyField.leftView=[self createLeftView];
    _MinmoneyField.leftViewMode=UITextFieldViewModeAlways;
    _MinmoneyField.keyboardType = UIKeyboardTypeDecimalPad;
    _MinmoneyField.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_MinmoneyField];
    
    UILabel *textlabel21 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_MinmoneyField.frame)+SpaceSmall, 285, 100,30)];
    textlabel21.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel21.font = FontLeftText;
    textlabel21.textColor = ColorLeftText;
    textlabel21.text = @"元";
    [_scrollView addSubview:textlabel21];
    
    //最小投标金额
    _MintextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_MinmoneyField.frame), 310, 190, 30)];
    _MintextView.textColor = ColorTip;
    _MintextView.font = FontTip;
    _MintextView.backgroundColor = [UIColor clearColor];
    _MintextView.userInteractionEnabled = NO;
    [_scrollView addSubview:_MintextView];
    
    //单选按钮
    _check2 = [[QCheckBox alloc] initWithDelegate:self];
    _check2.frame = CGRectMake(20, 335, 150, 25);
    [_check2 setTag:102];
    [_check2 setTitle:@"按平均金额招标" forState:UIControlStateNormal];
    [_check2 setTitleColor:ColorLeftText forState:UIControlStateNormal];
    [_check2.titleLabel setFont:FontLeftText];
    [_check2 setImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
    [_check2 setImage:[UIImage imageNamed:@"checkbox2_checked"] forState:UIControlStateSelected];
    [_scrollView addSubview:_check2];
    
    
    UILabel *textlabel22 = [[UILabel alloc] initWithFrame:CGRectMake(25, 365, 70,30)];
    textlabel22.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel22.font = FontLeftText;
    textlabel22.text = @"平均每份";
    textlabel22.textColor = ColorLeftText;
    [_scrollView addSubview:textlabel22];
    
    _averageField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textlabel22.frame)+SpaceSmall, 368, 115,25)];
    _averageField.font = FontLeftText;
    _averageField.delegate = self;
    _averageField.tag =304;
    _averageField.placeholder = @"平均份额";
    _averageField.keyboardType = UIKeyboardTypeDecimalPad;
    _averageField.borderStyle = UITextBorderStyleNone;
    _averageField.layer.borderWidth = HeightLine;
    _averageField.layer.borderColor=ColorTextFieldBorder.CGColor;
    _averageField.leftView=[self createLeftView];
    _averageField.leftViewMode=UITextFieldViewModeAlways;
    _averageField.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_averageField];
    
    _averageField.enabled = NO;
    
    UILabel *textlabel23 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_averageField.frame)+SpaceSmall, 365, 100,30)];
    textlabel23.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel23.font = FontLeftText;
    textlabel23.text = @"元";
    textlabel23.textColor = ColorLeftText;
    [_scrollView addSubview:textlabel23];
    
    //最多均分份额
    _averagetextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_averageField.frame), 390, 200, 30)];
    _averagetextView.textColor = ColorTip;
    _averagetextView.font = FontTip;
    _averagetextView.backgroundColor = [UIColor clearColor];
    _averagetextView.userInteractionEnabled = NO;
    [_scrollView addSubview:_averagetextView];
    
    // 修正单选框
    _MinmoneyField.userInteractionEnabled = YES;
    _averageField.userInteractionEnabled = NO;
    
    _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 425, self.view.frame.size.width, 300)];
    _backView2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_backView2];
    
    UIControl *viewControl12 = [[UIControl alloc] initWithFrame:_backView2.bounds];
    [viewControl12 addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView2 addSubview:viewControl12];
    
    
    UILabel *fulllabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 433, 100,30)];
    fulllabel.lineBreakMode = NSLineBreakByCharWrapping;
    fulllabel.font = FontLeftText;
    fulllabel.text = @"满标期限";
    fulllabel.textColor=ColorLeftText;
    [_scrollView addSubview:fulllabel];
    
    //选择框
    _fullScaleComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(95, 436, 90, 26)];
    [_fullScaleComboBox setLabelText:@"-请选择-"];
    [_fullScaleComboBox setDelegate:self];
    [_fullScaleComboBox setTag:205];
    [_scrollView addSubview:_fullScaleComboBox];
    
    
    UILabel *daylabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 440, 20,20)];
    daylabel.lineBreakMode = NSLineBreakByCharWrapping;
    daylabel.textColor = ColorLeftText;
    daylabel.font = FontLeftText;
    daylabel.text = @"日";
    [_scrollView addSubview:daylabel];
    
    
    UILabel *yearRatelabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 470, 100,30)];
    yearRatelabel.lineBreakMode = NSLineBreakByCharWrapping;
    yearRatelabel.font = FontLeftText;
    yearRatelabel.text = @"年利率";
    yearRatelabel.textColor=ColorLeftText;
    [_scrollView addSubview:yearRatelabel];
    
    
    UILabel *Ratelabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 470, 80,30)];
    Ratelabel.lineBreakMode = NSLineBreakByCharWrapping;
    Ratelabel.font = FontLeftText;
    Ratelabel.text = @"%";
    Ratelabel.textColor=ColorLeftText;
    [_scrollView addSubview:Ratelabel];
    
    
    //年利率范围
    _ratetextView = [[UITextView alloc] initWithFrame:CGRectMake(80, 498, 220, 50)];
    _ratetextView.textColor = ColorTip;
    _ratetextView.font =FontTip;
    _ratetextView.userInteractionEnabled = NO;
    [_scrollView addSubview:_ratetextView];
    
    
    _rateField = [[UITextField alloc] initWithFrame:CGRectMake(95, 475, 120,25)];
    _rateField.font = FontLeftText;
    _rateField.textColor=ColorLeftText;
    _rateField.delegate = self;
    _rateField.keyboardType = UIKeyboardTypeDecimalPad;
    _rateField.tag = 305;
    _rateField.placeholder = @"请输入年利率";
    _rateField.borderStyle = UITextBorderStyleNone;
    _rateField.layer.borderWidth = HeightLine;
    _rateField.layer.borderColor=ColorTextFieldBorder.CGColor;
    _rateField.leftView=[self createLeftView];
    _rateField.leftViewMode=UITextFieldViewModeAlways;
    _rateField.backgroundColor = [UIColor whiteColor];
    [_rateField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    [_scrollView addSubview:_rateField];
    
    UILabel  *interestlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 540, 100,30)];
    interestlabel.lineBreakMode = NSLineBreakByCharWrapping;
    interestlabel.font = FontLeftText;
    interestlabel.text = @"实际支付利息:";
    interestlabel.textColor=ColorLeftText;
    [_scrollView addSubview:interestlabel];
    
    _interestLabel = [[UILabel alloc] initWithFrame:CGRectMake(107, 542, 200,25)];
    _interestLabel.font = FontLeftText;
    _interestLabel.textColor = ColorRedMain;
    _interestLabel.backgroundColor = [UIColor clearColor];
    _interestLabel.text = @"0元";
    [_scrollView addSubview:_interestLabel];
    
    UILabel  *imglabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 575, 100,30)];
    imglabel.lineBreakMode = NSLineBreakByCharWrapping;
    imglabel.font = FontLeftText;
    imglabel.text = @"借款图片:";
    imglabel.textColor=ColorLeftText;
    [_scrollView addSubview:imglabel];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.frame = CGRectMake(80, 580, 80, 80);
    _imgView.image = [UIImage imageNamed:@"logo"];
    //    imgView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_imgView];
    
    _postBtnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _postBtnBtn.frame = CGRectMake(200,610, 60, 30);
    _postBtnBtn.backgroundColor = GreenColor;
    [_postBtnBtn setTitle:@"上传图片"forState:UIControlStateNormal];
    [_postBtnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _postBtnBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0];
    [_postBtnBtn.layer setMasksToBounds:YES];
    [_postBtnBtn.layer setCornerRadius:3.0];
    [_postBtnBtn addTarget:self action:@selector(PostBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_postBtnBtn];
    
    UITextView *prompttextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imgView.frame), 655, 200, 20)];
    prompttextView.textColor = ColorTip;
    prompttextView.text = @"友情提示:图片大小为110*110px";
    prompttextView.font = [UIFont boldSystemFontOfSize:10.0f];
    prompttextView.userInteractionEnabled = NO;
    [_scrollView addSubview:prompttextView];
    
    UITextView *titletextView2 = [[UITextView alloc] initWithFrame:CGRectMake(-2, 680, self.view.frame.size.width+2, 30)];
    titletextView2.backgroundColor = GreenColor;
    titletextView2.text = @"借款详情";
    titletextView2.textColor = [UIColor whiteColor];
    titletextView2.font = FontLeftText;
    titletextView2.userInteractionEnabled = NO;
    [_scrollView addSubview:titletextView2];
    
    _detailstextView = [[UITextView alloc] initWithFrame:CGRectMake(5,CGRectGetMaxY(titletextView2.frame)+SpaceSmall/2, self.view.frame.size.width - 10, 130)];
    [_detailstextView.layer setBorderWidth:1.0f];
    [_detailstextView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    _detailstextView.backgroundColor = [UIColor whiteColor];
    _detailstextView.delegate = self;
    [_detailstextView setTag:99];
    _detailstextView.font = FontLeftText;
    _detailstextView.userInteractionEnabled = YES;
    [_scrollView addSubview:_detailstextView];
    
    //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    _uiLabel = [[UILabel alloc] init];
    _uiLabel.frame = CGRectMake(5, 5, _detailstextView.frame.size.width - 100, 20);
    _uiLabel.text = @"请输入借款详情...";
    _uiLabel.enabled = NO;//lable必须设置为不可用
    _uiLabel.font = FontLeftText;
    _uiLabel.backgroundColor = [UIColor clearColor];
    [_detailstextView addSubview:_uiLabel];
    
//    UITextView *titletextView3 = [[UITextView alloc] initWithFrame:CGRectMake(-2, CGRectGetMaxY(_detailstextView.frame)+SpaceSmall/2, self.view.frame.size.width+2, 30)];
//    titletextView3.backgroundColor = GreenColor;
//    titletextView3.text = @"投标奖励";
//    titletextView3.textColor = [UIColor whiteColor];
//    titletextView3.font = FontLeftText;
//    titletextView3.userInteractionEnabled = NO;
//    [_scrollView addSubview:titletextView3];
//    
//    QCheckBox *norewardCheckBox= [[QCheckBox alloc] initWithDelegate:self];
//    norewardCheckBox.frame = CGRectMake(10, CGRectGetMaxY(titletextView3.frame)+SpaceMediumSmall, 150, 25);
//    [norewardCheckBox setTag:103];
//    [norewardCheckBox setTitle:@"不设置奖励" forState:UIControlStateNormal];
//    [norewardCheckBox setTitleColor:ColorLeftText forState:UIControlStateNormal];
//    [norewardCheckBox.titleLabel setFont:FontMedium];
//    [norewardCheckBox.titleLabel setTextColor:ColorLeftText];
//    [norewardCheckBox setImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
//    [norewardCheckBox setImage:[UIImage imageNamed:@"checkbox2_checked"] forState:UIControlStateSelected];
//    [_scrollView addSubview:norewardCheckBox];
//    
//    QCheckBox  *fixedCheckBox= [[QCheckBox alloc] initWithDelegate:self];
//    fixedCheckBox.frame = CGRectMake(10, 910, 110, 25);
//    [fixedCheckBox setTag:104];
//    [fixedCheckBox setTitle:@"设置固定奖金" forState:UIControlStateNormal];
//    [fixedCheckBox setTitleColor:ColorLeftText forState:UIControlStateNormal];
//    [fixedCheckBox.titleLabel setFont:FontMedium];
//    [fixedCheckBox.titleLabel setTintColor:ColorLeftText];
//    [fixedCheckBox setImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
//    [fixedCheckBox setImage:[UIImage imageNamed:@"checkbox2_checked"] forState:UIControlStateSelected];
//    [_scrollView addSubview:fixedCheckBox];
//    
//    //固定奖金
//    _fixedField = [[UITextField alloc] initWithFrame:CGRectMake(115, 910, 60,25)];
//    _fixedField.font = FontMedium;
//    _fixedField.textColor=ColorLeftText;
//    _fixedField.delegate = self;
//    _fixedField.tag = 307;
//    _fixedField.userInteractionEnabled = NO;
//    _fixedField.borderStyle = UITextBorderStyleNone;
//    _fixedField.layer.borderWidth = HeightLine;
//    _fixedField.layer.borderColor=ColorTextFieldBorder.CGColor;
//    _fixedField.leftView=[self createLeftView];
//    _fixedField.leftViewMode=UITextFieldViewModeAlways;
//    _fixedField.backgroundColor = [UIColor whiteColor];
//    _fixedField.keyboardType = UIKeyboardTypeDecimalPad;
//    [_scrollView addSubview:_fixedField];
//    
//    UILabel  *fixedlabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 910, 200,30)];
//    fixedlabel.lineBreakMode = NSLineBreakByCharWrapping;
//    fixedlabel.font = FontMedium;
//    fixedlabel.textColor=ColorLeftText;
//    fixedlabel.text = @"元，按投标比例分配。";
//    [_scrollView addSubview:fixedlabel];
//    
//    QCheckBox  *totalCheckBox= [[QCheckBox alloc] initWithDelegate:self];
//    totalCheckBox.frame = CGRectMake(10, 940, 110, 25);
//    [totalCheckBox setTag:105];
//    [totalCheckBox setTitle:@"按借款总额的" forState:UIControlStateNormal];
//    [totalCheckBox setTitleColor:ColorLeftText forState:UIControlStateNormal];
//    [totalCheckBox.titleLabel setFont:FontMedium];
//    [totalCheckBox.titleLabel setTextColor:ColorLeftText];
//    [totalCheckBox setImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
//    [totalCheckBox setImage:[UIImage imageNamed:@"checkbox2_checked"] forState:UIControlStateSelected];
//    [_scrollView addSubview:totalCheckBox];
//    
//    //比例奖金
//    _totalField = [[UITextField alloc] initWithFrame:CGRectMake(115, 940, 40,25)];
//    _totalField.font = FontMedium;
//    _totalField.textColor=ColorLeftText;
//    _totalField.delegate = self;
//    _totalField.tag = 308;
//    _totalField.userInteractionEnabled = NO;
//    _totalField.borderStyle = UITextBorderStyleNone;
//    _totalField.layer.borderWidth = HeightLine;
//    _totalField.layer.borderColor=ColorTextFieldBorder.CGColor;
//    _totalField.leftView=[self createLeftView];
//    _totalField.leftViewMode=UITextFieldViewModeAlways;
//    _totalField.backgroundColor = [UIColor whiteColor];
//    _totalField.keyboardType = UIKeyboardTypeDecimalPad;
//    [_scrollView addSubview:_totalField];
//    
//    UILabel  *totallabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 940, 200,30)];
//    totallabel.lineBreakMode = NSLineBreakByCharWrapping;
//    totallabel.font = FontMedium;
//    totallabel.textColor=ColorLeftText;
//    totallabel.text = @"%设奖金,按投标比例分配。";
//    [_scrollView addSubview:totallabel];
    
    _submitBtn = [ToolButton CreateMainButton:CGRectMake(SpaceBig, CGRectGetMaxY(_detailstextView.frame)+SpaceBig, WidthScreen-SpaceBig*2, 40) withTitle:@"提交发布" withTarget:self withAction:@selector(SubmitBtnClick)];
    [_scrollView addSubview:_submitBtn];
    
    // 释放键盘
    UIControl *viewControl9 = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl9 addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.scrollView.contentSize=CGSizeMake(WidthScreen, CGRectGetMaxY(_submitBtn.frame)+SpaceBig*2);
}
/**
 *  创建一个UITextField的LeftView
 *
 */
-(UIView *)createLeftView{
    UIView *viewLeft=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 7.0f, 0)];
    return viewLeft;
}
/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"发布借款";
}

-(void)onNotOpen{
    [_viewBlack removeFromSuperview];
}
-(void)onOpen{
    [_viewBlack removeFromSuperview];
    JXLROpenAccountViewController *openAccount = [[JXLROpenAccountViewController alloc] init];
    openAccount.openAccountType=OpenAccountTypeRelease;
    [self presentViewOrPushController:openAccount animated:YES completion:nil];
}

#pragma mark 实现UITextView的代理
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _uiLabel.text = @"请输入借款详情...";
    }else{
        _uiLabel.text = @"";
    }
}


#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    [self showHudWitText:@"发布中..."];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
   //DLOG(@"==发布借款相关信息=======%@",obj);
    [self hidHud];
    NSDictionary *dics = obj;
    if (_num == 1) {
        
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
            
            //借款用途
            NSArray *purposeArr = [dics objectForKey:@"purpose"];
            for (NSDictionary *dic in purposeArr) {
                NSString *purposeStr = [dic objectForKey:@"name"];
                [_dataArr addObject:purposeStr];
                [_purposeIdArr addObject:[dic objectForKey:@"id"]];
            }
            //用途
            [_ComboBox setArrayData:_dataArr];
            
            
            //借款期限年月日组合
            yearArr = [dics objectForKey:@"periodYearArray"];
            monthArr = [dics objectForKey:@"periodMonthArray"];
            dayArr = [dics objectForKey:@"periodDayArray"];
            
            if (_isRepayment)
            {
                _unitNum = 1;
                _rtypeNum = 3;
                _limitTimeArr = dayArr;
                [_deadlineComboBox setArrayData:_limitTimeArr];
                _deadlineComboBox.userInteractionEnabled = YES;
                
                _deadlineComboBox.table.frame= CGRectMake(_deadlineComboBox.frame.origin.x, _deadlineComboBox.frame.origin.y + 26 - _scrollView.contentOffset.y, _deadlineComboBox.frame.size.width, _limitTimeArr.count >= 6?6*30:_limitTimeArr.count*30);
            }
            
            //还款方式
            NSArray *wayArr = [dics objectForKey:@"repayWay"];
            for (NSDictionary *dic in wayArr) {
                NSString *wayStr = [dic objectForKey:@"name"];
                [_wayArr addObject:wayStr];
                [_repaymentIdArr addObject:[dic objectForKey:@"id"]];
            }
            if (_repaymentIdArr.count == 1) {
                _repaymentIdStr = [NSString stringWithFormat:@"%@",[_repaymentIdArr objectAtIndex:0]];
                [_wayComboBox setLabelText:[NSString stringWithFormat:@"%@",[_wayArr objectAtIndex:0]]];
                _rtypeNum = [_repaymentIdStr integerValue];
            }
            
            //满标期限
            _fullDateArr = [dics objectForKey:@"tenderTimeArray"];
            [_fullScaleComboBox setArrayData:_fullDateArr];
            
            //还款方式
            [_wayComboBox setArrayData:_wayArr];
            
            _wayComboBox.table.frame= CGRectMake(_wayComboBox.frame.origin.x, _wayComboBox.frame.origin.y+88, _wayComboBox.frame.size.width, _wayArr.count>=6?6*30:_wayArr.count*30);
            
            _fullScaleComboBox.table.frame= CGRectMake(_fullScaleComboBox.frame.origin.x, _fullScaleComboBox.frame.origin.y+88, _fullScaleComboBox.frame.size.width, _fullDateArr.count>=6?6*30:_fullDateArr.count*30);
            _ComboBox.table.frame= CGRectMake(_ComboBox.frame.origin.x, _ComboBox.frame.origin.y+88, _ComboBox.frame.size.width, _dataArr.count>=6?6*30:_dataArr.count*30);
            
            
            
            //最低投标金额
            _MintextView.text =  [NSString stringWithFormat:@"最低设置不低于%@元",[dics objectForKey:@"minInvestAmount"]];
            //拆分最多份数
            _averagetextView.text = [NSString stringWithFormat:@"注：借款标最多拆分不超过%@份",[dics objectForKey:@"maxCopies"]];
            //利率范围
            _ratetextView.text =  [NSString stringWithFormat:@"建议年利率设置在:%@%%-%@%%之间，利率越高，满标速度越快",[dics objectForKey:@"minInterestRate"],[dics objectForKey:@"maxInterestRate"]];
            
            NSInteger typeNum = [[dics objectForKey:@"loanImageType"] integerValue];
            
            if (typeNum == 1) {
                
                if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"loanImageFilename"]] hasPrefix:@"http"]) {
                    
                    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dics objectForKey:@"loanImageFilename"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                }else
                {
                    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,[dics objectForKey:@"loanImageFilename"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                }
                
                
                [_postBtnBtn removeFromSuperview];
                _borrowImgStr = [dics objectForKey:@"loanImageFilename"];
                
            } 
        }
        else{
            
            //DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            
        }
    }
    
    else if(_num == 2)//发布借款
    {
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
            
            if (![[obj objectForKey:@"htmlParam"]isEqual:[NSNull null]] && [obj objectForKey:@"htmlParam"] != nil)
            {
                NSString *htmlParam = [NSString stringWithFormat:@"%@",[obj objectForKey:@"htmlParam"]];
                MyWebViewController *web = [[MyWebViewController alloc]init];
                web.html = htmlParam;
                web.type = @"5";
                web.amountString = self.moneyField.text;
                web.titleString = self.titleField.text;
                [self.navigationController pushViewController:web animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            }
            
        }
        else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-31"])
        {
            _submitBtn.enabled = YES;

            _viewBlack=[ToolBlackView createRemindWithTitle:@"请开通资金托管账户" withContent:@"开通资金托管账户，投资理财更安全！" withLeftText:@"暂不开通" withRightText:@"立即开通" withTarget:self withActionLeft:@selector(onNotOpen) withActionRight:@selector(onOpen)];
        }
        else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-999"])
        {
            _submitBtn.enabled = YES;
            
            MyRechargeViewController *RechargeView = [[MyRechargeViewController alloc] init];
            UINavigationController *NaVController = [[UINavigationController alloc] initWithRootViewController:RechargeView];
            [self presentViewController:NaVController animated:YES completion:nil];
        }
        else{
            
            _submitBtn.enabled = YES;
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"失败：%@", [obj objectForKey:@"msg"]]];
            
        }
        
    }
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hidHud];
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    _submitBtn.enabled = YES;
    
}

// 无可用的网络
-(void) networkError
{
    [self hidHud];
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
    _submitBtn.enabled = YES;
}



#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    QCheckBox *checkbox1  = (QCheckBox *)[_scrollView viewWithTag:101];
    QCheckBox *checkbox2  = (QCheckBox *)[_scrollView viewWithTag:102];
    
    
    //最小额和均分单选框
    if (checkbox.tag==101&&checkbox.checked ==1) {
        
        checkbox2.checked = NO;
        _averageField.userInteractionEnabled = NO;
        _averageField.text = nil;
        _MinmoneyField.userInteractionEnabled = YES;
    }
    else if (checkbox.tag==101&&checkbox.checked ==0) {
        checkbox2.checked = YES;
        _averageField.userInteractionEnabled = YES;
        _MinmoneyField.userInteractionEnabled = NO;
        _MinmoneyField.text = nil;
        
        _averageField.enabled = YES;
        
    }
    
    if (checkbox.tag==102&&checkbox.checked ==1) {
        
        checkbox1.checked = NO;
        _averageField.userInteractionEnabled = YES;
        _MinmoneyField.userInteractionEnabled = NO;
        _MinmoneyField.text = nil;
    }
    else if (checkbox.tag==102&&checkbox.checked ==0) {
        checkbox1.checked = YES;
        _averageField.userInteractionEnabled = NO;
        _averageField.text = nil;
        _MinmoneyField.userInteractionEnabled = YES;
        
    }
    

}

#pragma mark 单选框代理方法
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    
    if (comboBox.tag == 201) {
        //DLOG(@"借款用途:%@",[_dataArr objectAtIndex:selectedIndex]);
        //DLOG(@"借款用途ID:%@",[_purposeIdArr objectAtIndex:selectedIndex]);
        _purposeIdStr = [NSString stringWithFormat:@"%@",[_purposeIdArr objectAtIndex:selectedIndex]];
    }
    
    else if (comboBox.tag == 202) {
        switch (selectedIndex) {
            case 0:
                _limitTimeArr = yearArr;
                break;
            case 1:
                _limitTimeArr = monthArr;
                break;
            case 2:
                _limitTimeArr = dayArr;
                break;
        }
        //DLOG(@"借款时间单位:%@, %ld",[unitsArr objectAtIndex:selectedIndex], (long)selectedIndex);
        _unitNum = selectedIndex - 1;
        _periodUnitStr = [NSString stringWithFormat:@"%d",(int)selectedIndex-1];
        
        if (selectedIndex == 2) {
            for (int i = 0; i < _repaymentIdArr.count; i++)
            {
                if ([[_wayArr objectAtIndex:i] isEqualToString:@"一次性还款"])
                {
                   // _rtypeNum = i + 1;
                    _repaymentIdStr = [NSString stringWithFormat:@"%@",[_repaymentIdArr objectAtIndex:i]];
                    _rtypeNum = [_repaymentIdStr integerValue];
                    [_wayComboBox setLabelText:@"一次性还款"];
                    _wayComboBox.userInteractionEnabled = NO;
                }
            }
        }else {
            //当还款方式只有一种时，默认选择那种
            if (_repaymentIdArr.count == 1)
            {
                _repaymentIdStr = [NSString stringWithFormat:@"%@",[_repaymentIdArr objectAtIndex:0]];
                [_wayComboBox setLabelText:[NSString stringWithFormat:@"%@",[_wayArr objectAtIndex:0]]];
                _rtypeNum = [_repaymentIdStr integerValue];
            }else{
                [_wayComboBox setLabelText:@"选择还款方式"];
            }
 
            _wayComboBox.userInteractionEnabled = YES;
            
        }
        
         //当借款期限重选时，期限时长恢复初始值或指定值
        [_deadlineComboBox setArrayData:_limitTimeArr];

        if (_limitTimeArr.count == 1) {
            _periodStr = [NSString stringWithFormat:@"%@",[_limitTimeArr objectAtIndex:0]];
            _peroidNum = [[_limitTimeArr objectAtIndex:0] floatValue];
            [_deadlineComboBox setLabelText:_periodStr];
        }else{
            [_deadlineComboBox setLabelText:@"-请选择-"];
            _periodStr = nil;
            _peroidNum = 0;
        }
        
        _deadlineComboBox.table.frame= CGRectMake(_deadlineComboBox.frame.origin.x, _deadlineComboBox.frame.origin.y + 26 - _scrollView.contentOffset.y, _deadlineComboBox.frame.size.width, _limitTimeArr.count >= 6?6*30:_limitTimeArr.count*30);

        
    }
    else if (comboBox.tag == 203){
        //DLOG(@"借款期限:%@",[_limitTimeArr objectAtIndex:selectedIndex]);
        _periodStr = [NSString stringWithFormat:@"%@",[_limitTimeArr objectAtIndex:selectedIndex]];
        _peroidNum = [[_limitTimeArr objectAtIndex:selectedIndex] floatValue];
    }
    
    else if (comboBox.tag == 204){
        //DLOG(@"还款方式:%@, %ld",[_wayArr objectAtIndex:selectedIndex], (long)selectedIndex);
        //DLOG(@"还款方式ID:%@",[_repaymentIdArr objectAtIndex:selectedIndex]);
        _repaymentIdStr = [NSString stringWithFormat:@"%@",[_repaymentIdArr objectAtIndex:selectedIndex]];
       // _rtypeNum = selectedIndex + 1;
        _rtypeNum = [_repaymentIdStr integerValue];
    }
    else if (comboBox.tag == 205){
        //DLOG(@"满标期限:%@",[_fullDateArr objectAtIndex:selectedIndex]);
        _investPeriodStr = [NSString stringWithFormat:@"%@",[_fullDateArr objectAtIndex:selectedIndex]];
    }
    [self getInterest:_peroidNum units:_unitNum apr:_aprNum amount:_amountNum rType:_rtypeNum];
}


#pragma mark 点击空白处收回键盘
- (void)controlAction
{
    [_titleField resignFirstResponder];
    [_moneyField resignFirstResponder];
    [_MinmoneyField resignFirstResponder];
    [_averageField resignFirstResponder];
    [_rateField resignFirstResponder];
    [_detailstextView resignFirstResponder];

}

// 监听文本输入文字自动求值
- (void)valueChange:(UITextField *)textF {
    
    if(textF.tag == 302)
    {
        _amountNum = [textF.text floatValue];
        //DLOG(@"金额为:%.2f",_amountNum);
    }
    if (textF.tag == 305){
        
        if([textF.text rangeOfString:@"."].location ==NSNotFound)
        {
            if (textF.text.length > 2) {
                textF.text = [textF.text substringToIndex:2];
                
            }
            
        }else{
            
            if (textF.text.length > 5) {
                textF.text = [textF.text substringToIndex:5];
                
            }
        }
        
        
        _aprNum = [textF.text floatValue];
        //DLOG(@"利率为:%.2f",_aprNum);
        
    }
    [self getInterest:_peroidNum units:_unitNum apr:_aprNum amount:_amountNum rType:_rtypeNum];
}

#pragma mark -
#pragma mark UITextField文本框代理
#pragma 限制只能输入数字和.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL canChange;
    if (textField.tag == 301) {
        
        canChange = YES;
        
    }
    else {
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        canChange = [string isEqualToString:filtered];
        
    }
    
    return canChange;
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
        if ([textView.text length] < 200) {//判断字符个数
            return YES;
        }
    }
    return NO;
}


#pragma mark 年利率自动计算方法
- (void)getInterest:(float)period units:(NSInteger)unit  apr:(float)apr  amount:(float)amount rType:(NSInteger)rType
{
    
    float interest = 0; // 总利息
    float monthApr = apr / 12 / 100; // 月利率
    float rperiod = 0; // 还款期数
    
    /* 根据借款期限算出利息 */
    switch(unit){
            /* 年 */
        case -1:
            interest = apr/100*period*amount;
            rperiod = period * 12;
            break;
            /* 月 */
        case 0:
            interest = apr/12/100*period*amount;
            rperiod = period;
            break;
            /* 日 */
        case 1:
            interest = apr/360/100*period*amount;
            rperiod = 1;
            break;
    }
    //NSLog(@"rType-->%ld",(long)rType);

    /* 根据还款方式算出利息 */
    switch(rType){
            /* 按月还款、等额本息 */
        case 1:{
            if (_aprNum) {
                
                float monthSum = amount * monthApr *powf((1 + monthApr), rperiod) / (powf((1 + monthApr), rperiod) - 1);
                //DLOG(@"实际支付利息_等额本息 %f",monthSum * rperiod - amount);
                _interestLabel.text = [NSString stringWithFormat:@"%0.2f元",monthSum * rperiod - amount];
            }
            
        }
            break;
            /* 按月付息、一次还款; 一次还款 */
        case 2:
        case 3:
            //DLOG(@"实际支付利息 %f",interest);
            _interestLabel.text = [NSString stringWithFormat:@"%0.2f元",interest];
            break;
    }
    
}

#pragma mark 提交发布按钮触发方法
- (void)SubmitBtnClick
{
    
    if (_purposeIdStr == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择借款用途"];
        
    }
    else if (_titleField.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入借款标题"];
    }
    
    else if (_moneyField.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入借款金额"];
    }
    
    
    else if (_periodUnitStr == nil || _periodStr == nil){
        [SVProgressHUD showErrorWithStatus:@"请选择借款期限"];
    }
    else if (_repaymentIdStr ==nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择还款方式"];
    }
    
    else if ( _investPeriodStr == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择满标期限"];
        
    }
    
    else if (_rateField.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入年利率"];
    }
    
    
    else if (_borrowImgStr.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请上传借款图片"];
    }
    
    else if (_detailstextView.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入借款详情"];
    }else {
        
        _submitBtn.enabled = NO;
        //DLOG(@"提交发布按钮");
        _num = 2;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        //客户端发布借款接口（OPT=21）
        [parameters setObject:@"21" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_purposeIdStr forKey:@"purposeId"];//	purposeId 借款用途id
        [parameters setObject:_titleField.text forKey:@"title"];//  title	标题
        [parameters setObject:_moneyField.text forKey:@"amount"];//    amount	借款金额
        [parameters setObject:_periodUnitStr forKey:@"periodUnit"];//    periodUnit	借款期限单位
        [parameters setObject:_periodStr forKey:@"period"];//    period	借款期限
        [parameters setObject:_repaymentIdStr forKey:@"repaymentId"];//    repaymentId	还款方式id
        [parameters setObject:_repaymentIdStr forKey:@"repaymentTypeId"];//    repaymentId	还款方式id
        [parameters setObject:_MinmoneyField.text forKey:@"minInvestAmount"];//    minInvestAmount	最少投标金额
        [parameters setObject:_averageField.text forKey:@"averageInvestAmount"];//    averageInvestAmount	平价金额招标
        [parameters setObject:_investPeriodStr forKey:@"investPeriod"];//    investPeriod	满标期限id
        [parameters setObject:_rateField.text forKey:@"apr"];//    apr	年利率
        [parameters setObject:_borrowImgStr forKey:@"imageFilename"]; // imageFilename图片路径
        // [parameters setObject:@"" forKey:@"imageFilename"];
        [parameters setObject:_detailstextView.text forKey:@"description"];//    description	内容描述
        [parameters setObject:@"0" forKey:@"bonusType"];//    bonusType	设置投标奖励id
        [parameters setObject:@"" forKey:@"awardScale"];//    awardScale	设置奖金比例
        [parameters setObject:@"" forKey:@"bonus"];//    bonus	设置固定奖金
        [parameters setObject:[NSString stringWithFormat:@"%@",self.productID]   forKey:@"productId"];//    productId	产品id
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];//    userId	用户id
        
        
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
        
    }
    
}

#pragma  mark UIScrollViewdellegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _unitsComboBox.table.frame = CGRectMake(_unitsComboBox.frame.origin.x, _unitsComboBox.frame.origin.y+26-scrollView.contentOffset.y, _unitsComboBox.frame.size.width, unitsArr.count>=6?6*30:unitsArr.count*30);
    _wayComboBox.table.frame= CGRectMake(_wayComboBox.frame.origin.x, _wayComboBox.frame.origin.y+26-scrollView.contentOffset.y, _wayComboBox.frame.size.width, _wayArr.count>=6?6*30:_wayArr.count*30);
    
    _ComboBox.table.frame= CGRectMake(_ComboBox.frame.origin.x, _ComboBox.frame.origin.y+26-scrollView.contentOffset.y, _ComboBox.frame.size.width, _dataArr.count>=6?6*30:_dataArr.count*30);
    _deadlineComboBox.table.frame= CGRectMake(_deadlineComboBox.frame.origin.x, _deadlineComboBox.frame.origin.y+26-scrollView.contentOffset.y, _deadlineComboBox.frame.size.width, _limitTimeArr.count>=6?6*30:_limitTimeArr.count*30);
    
    _fullScaleComboBox.table.frame= CGRectMake(_fullScaleComboBox.frame.origin.x, _fullScaleComboBox.frame.origin.y+26-scrollView.contentOffset.y, _fullScaleComboBox.frame.size.width, _fullDateArr.count>=6?6*30:_fullDateArr.count*30);
}

#pragma 上传图片按钮触发方法
- (void)PostBtnClick
{
    //DLOG(@"上传图片按钮");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"从手机相册选择"];
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showInView:self.view];
}


#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    if (buttonIndex == 0)//照相机
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"该设备没有摄像头"];
            
        }
    }
    if (buttonIndex == 1)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    if (buttonIndex == 2)
    {
        
    }
}

#pragma mark
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)saveImage:(UIImage *)image
{
    _imgView.image = image;
    
    if (image!=nil) {
        
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"1" forKey:@"type"];
        
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@",Baseurl,@"/app/uploadPhoto"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //上传时使用当前的系统事件作为文件名
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmss";
            formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
            
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
           
            [formData appendPartWithFileData:imageData name:@"imgFile" fileName:fileName mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            if([[dic objectForKey:@"error"] integerValue] == -1)
            {
                //                                             _borrowImgStr =[NSString stringWithFormat:@"%@%@", Baseurl, [dic objectForKey:@"filename"]] ;
                _borrowImgStr =[NSString stringWithFormat:@"%@",[dic objectForKey:@"filename"]] ;
                [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
                //DLOG(@"图片连接 is %@",_borrowImgStr);
                
            }else{
                
                _borrowImgStr = @"";
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                    
                    
                    
                });
                
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // //DLOG(@"返回按钮");
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


@end