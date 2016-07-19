//
//  BorrowingDetailsViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  借款详情
#import "BorrowingDetailsViewController.h"
#import "LDProgressView.h"
#import "ColorTools.h"
#import "BorrowDetailsCell.h"
#import "TenderOnceViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFolderTableView.h"
#import "DetailsDescriptionViewController.h"
#import "MaterialAuditSubjectViewController.h"
#import "CBORiskControlSystemViewController.h"
#import "HistoricalRecordViewController.h"
#import "TenderAwardViewController.h"
#import "TenderRecordsViewController.h"
#import "AskBorrowerViewController.h"
#import "BorrowerInformationViewController.h"
#import "InterestcalculatorViewController.h"
#import "LiteratureAuditViewController.h"
#import "BorrowingBillViewController.h"
#import "FinancialBillsViewController.h"

#define HeightContentTitle (WidthScreen*0.22)
#define HeightContentNumber (WidthScreen*0.25)
#define HeightContentTime (WidthScreen*0.1)
#define FontTitle FontTextTitle
#define FontStateLabel [UIFont boldSystemFontOfSize:12.0f]
#define WidthContentNumber (WidthScreen-SpaceSmall)
#define WidthAprAndData ((WidthContentNumber-SpaceMediumSmall*2)*0.28)
#define WidthAmount ((WidthContentNumber-SpaceMediumSmall*2)*0.44)
#define HeightAprDataAndAmount (HeightContentNumber*0.50)
#define HeightBottom 44

@interface BorrowingDetailsViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,HTTPClientDelegate>
{
    
    NSArray *titleArr;
    NSArray *tableArr;
    NSMutableArray *_collectionArrays;
    UIView *scrollPanel;//证件展示
    BOOL isShowScrollerpanel;
    NSInteger num2;
    NSString *headertitles;
    NSInteger _attentionNum;
    NSInteger _collectNum;
    float _paceNum;
    NSString *bidAmout;     // 投标金额
    NSString *apr;          // 年利率
    NSString *deadLine;     // 投标期限
    int repayType;          // 还款方式
    int deadperiodUnit;     // 投标类型（-1：年  0：月  1：日）
    int deadType;           // 投标奖励类型
    NSString *deadValue;    // 投标奖励
    float bonus;
    float awardScale;
    NSString *noId;         // 编号
    UILabel *dateLabel1;    //剩余时间
}

@property (nonatomic, strong) UIFolderTableView *listView;
@property (assign)BOOL isOpen;
@property (nonatomic,strong)UIView *viewHeader;
@property (nonatomic,strong)UIView *viewContentTitle;
@property (nonatomic,strong)UIView *viewContentNumber;
@property (nonatomic,strong)UIView *dateBackView;
@property (nonatomic,strong)LDProgressView *progressView;
@property (nonatomic,strong)UILabel *progressLabel;
@property (nonatomic,strong)UILabel *usageLabel;
@property (nonatomic,strong)UIImageView *typeImg;
@property (nonatomic,strong)NSString *associatesStr;
@property (nonatomic,strong)NSString *CBOAuditStr;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UILabel *rateLabel;
@property (nonatomic,strong)UILabel *deadlineLabel;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UILabel *dateLabel2;
@property (nonatomic,copy)NSString *borrowerId;
@property (nonatomic,copy)NSString *attentionId;
@property (nonatomic,copy)NSString *collectId;
@property (nonatomic,copy)NSString   *borrowerheadImg;
@property (nonatomic,copy)NSString   *borrowername;
@property (nonatomic,copy)NSString   *borrowid;
@property (nonatomic,copy)NSString   *borrowId;
@property (nonatomic,copy)NSString   *creditRating;
@property (nonatomic,copy)NSArray    *list;    //审核数组  AuditSubjectName  auditStatus   imgpath
@property (nonatomic,strong)UILabel  *organizationLabel;
@property (nonatomic,copy)NSString   *BorrowsucceedStr;
@property (nonatomic,copy)NSString   *BorrowfailStr;
@property (nonatomic,copy)NSString   *repaymentnormalStr;
@property (nonatomic,copy)NSString   *repaymentabnormalStr;
@property (nonatomic,copy)NSString   *borrowDetails;
@property (nonatomic,copy)NSString   *registrationTime;
@property (nonatomic,copy)NSString   *reimbursementAmount;
@property (nonatomic,copy)NSString   *SuccessBorrowNum;
@property (nonatomic,copy)NSString   *NormalRepaymentNum;
@property (nonatomic,copy)NSString   *OverdueRepamentNum;
@property (nonatomic,copy)NSString   *BorrowingAmount;
@property (nonatomic,copy)NSString   *FinancialBidNum;
@property (nonatomic,copy)NSString   *paymentAmount;
@property (nonatomic,copy)NSString   *awardString;
@property (nonatomic,assign)NSInteger   statuNum;
@property (nonatomic,strong)NSMutableArray  *AuditdataArr;
@property (nonatomic,strong)NSMutableArray  *auditStatusArr;
@property (nonatomic,strong)NSMutableArray  *imgpathArr;
@property (nonatomic,strong)NSMutableArray  *isVisibleArr;
@property (nonatomic,copy)NSString  *bidIdSign;  //借款标id
@property (nonatomic,copy)NSString  *bidUserIdSign;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel  *stateLabel;
@property (nonatomic)NSTimeInterval time;//相差时间
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic ,strong) UIButton *attBtn;
@property(nonatomic ,strong) UIButton *collectBtn;
@property(nonatomic ,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *idLabel; // 编号

@property(nonatomic,strong)UILabel *labPeriod;
@property(nonatomic,strong)UILabel *labAmountNum;
@property(nonatomic,strong)UILabel *labApr;
@property(nonatomic,strong)UIButton *tenderBtn;
@property(nonatomic,assign)float heightContainTableView;
@end

@implementation BorrowingDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    self.isOpen = NO;
    
    //初始化网络数据
    [self initData];
    
    // 初始化视图
    [self initView];
}

/**
 * 初始化数据
 */
- (void)initData
{
    _paceNum = 0;
    _attentionId = [[NSString alloc] init];
    titleArr = @[@"借款金额:",@"年  利  率:",@"还款方式:",@"借款期限:",@"还款日期:"];
    tableArr = @[@"详情描述",@"必要材料审核科目",@"CBO风控体系审核",@"历史记录",@"投标奖励",@"投标记录",@"向借款人提问"];
    
    //展开行数组
    _collectionArrays =[[NSMutableArray alloc] init];
    _AuditdataArr = [[NSMutableArray alloc] init];
    _auditStatusArr = [[NSMutableArray alloc] init];
    _imgpathArr = [[NSMutableArray alloc] init];
    _isVisibleArr = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestdata];
}
/**
 *  剩余时间界面是否隐藏时
 *
 *  @param isHide <#isHide description#>
 */
-(void)onTimeViewHide:(BOOL)isHide{
    self.dateBackView.hidden=isHide;
    if(isHide){
        [self.listView beginUpdates];
        _viewHeader.frame=CGRectMake(0, 0, WidthScreen, CGRectGetMaxY(_viewContentNumber.frame)+SpaceSmall);
        [self.listView setTableHeaderView:_viewHeader];
        [self.listView endUpdates];
    }else{
        [self.listView beginUpdates];
        _viewHeader.frame=CGRectMake(0, 0, WidthScreen, CGRectGetMaxY(_dateBackView.frame)+SpaceSmall);
        [self.listView setTableHeaderView:_viewHeader];
        [self.listView endUpdates];
    }
    _heightContainTableView=self.listView.contentSize.height;
}
/**
 *  是否显示底部
 */
-(void)onShowBottom:(BOOL)isShow{
    _bottomView.hidden = !isShow;
    if(isShow){
        [_listView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, HeightBottom+HeightNavigationAndStateBar+SpaceBig, 0)];
        [_listView setContentInset:UIEdgeInsetsMake(0, 0, HeightBottom+HeightNavigationAndStateBar+SpaceBig, 0)];
    }else{
        [_listView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, HeightNavigationAndStateBar+SpaceBig, 0)];
        [_listView setContentInset:UIEdgeInsetsMake(0, 0, HeightNavigationAndStateBar+SpaceBig, 0)];
    }
    _heightContainTableView=self.listView.contentSize.height;
}
-(void)requestdata
{
    _attentionNum = 0;
    _collectNum = 0;
    
    num2 = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.2借款详情接口[借款详情详细信息]
    [parameters setObject:@"11" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowID] forKey:@"borrowId"];
    if (AppDelegateInstance.userInfo != nil) {
        [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"userId"];
    }
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
    
    _viewHeader=[[UIView alloc] init];
    _viewHeader.backgroundColor=[UIColor clearColor];
    
    _viewContentTitle=[[UIView alloc] initWithFrame:CGRectMake(0, SpaceSmall, WidthScreen, HeightContentTitle)];
    _viewContentTitle.backgroundColor=ColorWhite;
    [_viewHeader addSubview:_viewContentTitle];
    
    float spaceType=7;
    _typeImg = [[UIImageView alloc] initWithFrame:CGRectMake(spaceType, spaceType, HeightContentTitle-spaceType*2, HeightContentTitle-spaceType*2)];
    _typeImg.layer.cornerRadius=1.0;
    _typeImg.layer.masksToBounds=YES;
    [_viewContentTitle addSubview:_typeImg];
    
    float widthId=[SizeTools getStringWidth:@"J1840" Font:FontTextSmall];
    float HeightTitle=[SizeTools getStringHeight:@"title" Font:FontTitle];
    _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(WidthScreen-widthId-SpaceMediumBig, CGRectGetMinY(_typeImg.frame)+SpaceSmall, widthId, HeightTitle)];
    _idLabel.textColor = ColorRedMain;
    _idLabel.font = FontTextSmall;
    _idLabel.textAlignment = NSTextAlignmentRight;
    [_viewContentTitle addSubview:_idLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_typeImg.frame)+SpaceSmall, CGRectGetMinY(_idLabel.frame), CGRectGetMinX(_idLabel.frame)-CGRectGetMaxX(_typeImg.frame)-SpaceSmall, HeightTitle)];
    _titleLabel.font = FontTitle;
    _titleLabel.textColor=ColorTextContent;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_viewContentTitle addSubview:_titleLabel];
    
    float widthState=[SizeTools getStringWidth:@"借款中" Font:FontStateLabel]+SpaceMediumSmall;
    float heightState=[SizeTools getStringHeight:@"借款" Font:FontStateLabel]+8;
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_typeImg.frame)-heightState-SpaceSmall/2, widthState, heightState)];
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.adjustsFontSizeToFitWidth = YES;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.font = FontStateLabel;
    _stateLabel.backgroundColor = ColorRedMain;
    _stateLabel.layer.cornerRadius = 2.0f;
    _stateLabel.layer.masksToBounds=YES;
    [_viewContentTitle addSubview:_stateLabel];
    
    _usageLabel = [[UILabel alloc] init];
    _usageLabel.backgroundColor=[UIColor clearColor];
    _usageLabel.textColor = [UIColor darkGrayColor];
    _usageLabel.adjustsFontSizeToFitWidth = YES;
    _usageLabel.textAlignment = NSTextAlignmentCenter;
    _usageLabel.font = FontStateLabel;
    _usageLabel.layer.cornerRadius=2.0f;
    _usageLabel.layer.masksToBounds=YES;
    _usageLabel.textColor=ColorTextVice;
    [_viewContentTitle addSubview:_usageLabel];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setImage:[UIImage imageNamed:@"no_collection"] forState:UIControlStateNormal];
    [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_viewContentTitle addSubview:_collectBtn];
    
    _viewContentNumber=[[UIView alloc] initWithFrame:CGRectMake(SpaceSmall/2, CGRectGetMaxY(_viewContentTitle.frame)+SpaceSmall, WidthContentNumber, HeightContentNumber)];
    _viewContentNumber.backgroundColor=ColorWhite;
    _viewContentNumber.layer.cornerRadius=2.0;
    _viewContentNumber.layer.masksToBounds=YES;
    [_viewHeader addSubview:_viewContentNumber];
    
    //年化利率
    _labApr=[[UILabel alloc] initWithFrame:CGRectMake(SpaceMediumSmall, 0,WidthAprAndData, HeightAprDataAndAmount)];
    _labApr.textAlignment=NSTextAlignmentCenter;
    [_viewContentNumber addSubview:_labApr];
    
    //金额
    _labAmountNum=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labApr.frame), CGRectGetMinY(_labApr.frame),WidthAmount,  HeightAprDataAndAmount)];
    _labAmountNum.textAlignment=NSTextAlignmentCenter;
    [_viewContentNumber addSubview:_labAmountNum];
    
    //期限
    _labPeriod=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labAmountNum.frame), CGRectGetMinY(_labApr.frame),WidthAprAndData,  HeightAprDataAndAmount)];
    _labPeriod.textAlignment=NSTextAlignmentCenter;
    [_viewContentNumber addSubview:_labPeriod];
    
    float heightApr=[SizeTools getStringHeight:@"H" Font:FontTextSmall];
    UILabel *labAprText=[[UILabel alloc] initWithFrame:CGRectMake(SpaceMediumSmall, CGRectGetMaxY(_labApr.frame),WidthAprAndData,heightApr)];
    labAprText.textAlignment=NSTextAlignmentCenter;
    labAprText.text=@"年化利率";
    labAprText.font=FontTextMeidumSmall;
    labAprText.textColor=ColorTextVice;
    [_viewContentNumber addSubview:labAprText];
    
    UILabel *labAmountText=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labAprText.frame), CGRectGetMinY(labAprText.frame),WidthAmount,heightApr)];
    labAmountText.textAlignment=NSTextAlignmentCenter;
    labAmountText.font=FontTextMeidumSmall;
    labAmountText.textColor=ColorTextVice;
    labAmountText.text=@"借款金额";
    [_viewContentNumber addSubview:labAmountText];
    
    UILabel *labPeriodText=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labAmountText.frame), CGRectGetMinY(labAprText.frame),WidthAprAndData,heightApr)];
    labPeriodText.textAlignment=NSTextAlignmentCenter;
    labPeriodText.font=FontTextMeidumSmall;
    labPeriodText.textColor=ColorTextVice;
    labPeriodText.text=@"借款期限";
    [_viewContentNumber addSubview:labPeriodText];
    
    float widthProgressLabel=[SizeTools getStringWidth:@"100%" Font:FontTextSmall];
    float heightProgressLabel=HeightContentNumber-CGRectGetMaxY(labAprText.frame);
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(WidthContentNumber-widthProgressLabel-SpaceMediumSmall,CGRectGetMaxY(labAprText.frame), widthProgressLabel, heightProgressLabel)];
    _progressLabel.font = FontTextSmall;
    _progressLabel.textColor = ColorRedMain;
    _progressLabel.adjustsFontSizeToFitWidth = YES;
    _progressLabel.textAlignment=NSTextAlignmentRight;
    [_viewContentNumber addSubview:_progressLabel];
    
    float heightProgerss=3;
    _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(SpaceMediumSmall, CGRectGetMinY(_progressLabel.frame)+(heightProgressLabel-heightProgerss)/2+1, CGRectGetMinX(_progressLabel.frame)-SpaceMediumSmall*2, heightProgerss)];
    _progressView.color = ColorRedMain;
    _progressView.flat = @YES;// 是否扁平化
    _progressView.borderRadius = @1;
    _progressView.showBackgroundInnerShadow = @NO;
    _progressView.animate = @NO;
    _progressView.progressInset = @0;//内边的边距
    _progressView.showBackground = @YES;
    _progressView.outerStrokeWidth = @0;
    _progressView.showText = @NO;
    _progressView.showStroke = @NO;
    _progressView.background = [UIColor lightGrayColor];
    [_viewContentNumber addSubview:_progressView];
    
    _dateBackView=[[UIView alloc] initWithFrame:CGRectMake(SpaceSmall/2, CGRectGetMaxY(_viewContentNumber.frame)+SpaceSmall, WidthContentNumber, HeightContentTime)];
    _dateBackView.backgroundColor=[UIColor clearColor];
    [_viewHeader addSubview:_dateBackView];
    
    float widthDatelabel=WidthScreen*0.34;
    dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0, widthDatelabel, HeightContentTime)];
    dateLabel1.text = @"剩余时间";
    dateLabel1.backgroundColor=ColorRedMain;
    dateLabel1.textColor = [UIColor whiteColor];
    dateLabel1.textAlignment=NSTextAlignmentCenter;
    dateLabel1.font = FontTextTitle;
    [_dateBackView addSubview:dateLabel1];
    
    _dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel1.frame), CGRectGetMinY(dateLabel1.frame),WidthContentNumber-widthDatelabel, HeightContentTime)];
    _dateLabel2.textColor = ColorRedMain;
    _dateLabel2.backgroundColor = [UIColor whiteColor];
    _dateLabel2.textAlignment = NSTextAlignmentCenter;
    _dateLabel2.font = FontTextContent;
    [_dateBackView addSubview:_dateLabel2];
    
    _viewHeader.frame=CGRectMake(0, 0, WidthScreen, CGRectGetMaxY(_dateBackView.frame)+SpaceSmall);
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightScreen)  style:UITableViewStyleGrouped];
    [_listView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, HeightBottom+HeightNavigationAndStateBar, 0)];
    [_listView setContentInset:UIEdgeInsetsMake(0, 0, HeightBottom+HeightNavigationAndStateBar, 0)];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.showsVerticalScrollIndicator=NO;
    _listView.tableHeaderView=_viewHeader;
    [_listView setBackgroundColor:ColorBGGray];
    [self.view addSubview:_listView];
    
    //底部背景视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HeightScreen-HeightNavigationAndStateBar-HeightBottom, WidthScreen, HeightBottom)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *viewLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightLine)];
    viewLine.backgroundColor=ColorLine;
    [_bottomView addSubview:viewLine];
    
    [self.view addSubview:_bottomView];
    
    _tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tenderBtn.frame = CGRectMake(SpaceBig, SpaceSmall, WidthScreen-SpaceBig*2, HeightBottom-SpaceSmall*2);
    [_tenderBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [_tenderBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    [_tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [_tenderBtn.layer setMasksToBounds:YES];
    [_tenderBtn.layer setCornerRadius:3.0];
    [_bottomView addSubview:_tenderBtn];
    
    switch (_stateNum) {
        case 0:
        {
            [_tenderBtn setTitle:@"立即投标" forState:UIControlStateNormal];
            [_tenderBtn addTarget:self action:@selector(tenderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 1:
        {
            tableArr = @[@"详情描述",@"必要材料审核科目",@"CBO风控体系审核",@"历史记录",@"投标奖励"];
            [_listView reloadData];
            
            [_progressLabel removeFromSuperview];
            [_progressView removeFromSuperview];
            
            if (AppDelegateInstance.userInfo != nil) {
                [_tenderBtn setTitle:@"提交资料" forState:UIControlStateNormal];
                [_tenderBtn addTarget:self action:@selector(postInfoClick) forControlEvents:UIControlEventTouchUpInside];
             }
        }
            break;
        case 2:
        {
            tableArr = @[@"详情描述",@"必要材料审核科目",@"CBO风控体系审核",@"历史记录",@"投标奖励",@"投标记录"];
            [_listView reloadData];
            
            if (AppDelegateInstance.userInfo != nil) {
                [_tenderBtn setTitle:@"提交资料" forState:UIControlStateNormal];
                [_tenderBtn addTarget:self action:@selector(postInfoClick) forControlEvents:UIControlEventTouchUpInside];
             }
        }
            break;
        case 3:
        case 4:
        {
            tableArr = @[@"详情描述",@"必要材料审核科目",@"CBO风控体系审核",@"历史记录",@"投标奖励",@"投标记录"];
            [_listView reloadData];
            if (AppDelegateInstance.userInfo != nil) {
                [_tenderBtn setTitle:@"查看账单" forState:UIControlStateNormal];
                [_tenderBtn addTarget:self action:@selector(seeBillClick) forControlEvents:UIControlEventTouchUpInside];
             }
        }
            break;
        case 5:
        {
            if (AppDelegateInstance.userInfo != nil) {
                [_tenderBtn setTitle:@"查看账单" forState:UIControlStateNormal];
                [_tenderBtn addTarget:self action:@selector(finaBillClick) forControlEvents:UIControlEventTouchUpInside];
             }
        }
            break;
    }
    
    [self onShowBottom:NO];//初始时隐藏底部View
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"借款详情";
    // 导航条分享按钮
    BarButtonItem *shareItem=[BarButtonItem barItemWithTitle:@"分享" widthImage:[UIImage imageNamed:@"bar_right"] selectedImage:[UIImage imageNamed:@"bar_right_press"] withIsImageLeft:NO target:self action:@selector(shareClick)];
    [self.navigationItem setRightBarButtonItem:shareItem];
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
        if (num2 == 1) {
            //标题
            _titleLabel.text  = [dics objectForKey:@"borrowTitle"];
            
            //借款用途
            NSString *strUsage=[dics objectForKey:@"purpose"];
            float widthUsage=[SizeTools getStringWidth:strUsage Font:FontStateLabel];
            _usageLabel.frame=CGRectMake(CGRectGetMaxX(_stateLabel.frame)+SpaceMediumSmall, CGRectGetMinY(_stateLabel.frame), widthUsage, CGRectGetHeight(_stateLabel.frame));
            _usageLabel.text = strUsage;
            
            //借款类型
            if (![[dics objectForKey:@"borrowtype"] isEqual:[NSNull null]]) {
                if ([[dics objectForKey:@"borrowtype"] hasPrefix:@"http"]) {
                    [_typeImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dics objectForKey:@"borrowtype"]]] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
                }else{
                    
                    [_typeImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,[dics objectForKey:@"borrowtype"]]] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
                }
            }
            
            //借款标状态
            _statuNum = [[dics objectForKey:@"borrowStatus"] integerValue];
            switch (_statuNum) {
                case 1:
                case 2:
                case 3:
                    _stateLabel.text = @"借款中";
                    break;
                case 4:
                     _stateLabel.text = @"还款中";
                    break;
                case 5:
                    _stateLabel.text = @"已还款";
                    break;
                default:
                    _stateLabel.text = @"流 标";
                    break;
            }
            
            _bidIdSign = [dics objectForKey:@"bidIdSign"];//加密ID
            
            //收藏
            NSString *str = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionId"]];
            if(str.length)
            {
                _attentionNum = 1;
                _attentionId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionId"]];
            }
            NSString *str2 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionBidId"]];
            if(str2.length)
            {
                _collectNum = 1;
                _collectId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionBidId"]];
                [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }
            _collectBtn.frame=CGRectMake(CGRectGetMaxX(_usageLabel.frame)+SpaceMediumSmall, CGRectGetMinY(_stateLabel.frame), CGRectGetHeight(_stateLabel.frame), CGRectGetHeight(_stateLabel.frame));
            
            //进度
            _progressLabel.text = [NSString stringWithFormat:@"%0.0f%%",[[dics objectForKey:@"schedules"] floatValue]];
             _progressView.progress = [[dics objectForKey:@"schedules"] floatValue]/100;
            _paceNum =  [[dics objectForKey:@"schedules"] floatValue];
            if (_stateNum == 0) {
                if ([[dics objectForKey:@"schedules"] floatValue] >= 100.0) {
                    [self onShowBottom:NO];
                }else{
                    [self onShowBottom:YES];
                }
            }else{
                [self onShowBottom:YES];
            }
            
            //年化利率
            NSString *strApr = [NSString stringWithFormat:@"%0.1f%%",[[dics objectForKey:@"annualRate"] floatValue]];
            int numberApr=(int)strApr.length-1;
            NSMutableAttributedString *attrStrAprNum=[[NSMutableAttributedString alloc] initWithString:strApr];
            [attrStrAprNum addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, numberApr)];
            [attrStrAprNum addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:NSMakeRange(numberApr, 1)];
            [attrStrAprNum addAttribute:NSFontAttributeName value:FontTextBigNumber range:NSMakeRange(0, numberApr)];
            [attrStrAprNum addAttribute:NSFontAttributeName value:FontTextMeidumSmall range:NSMakeRange(numberApr, 1)];
            _labApr.attributedText=attrStrAprNum;
            
            float amount=([[dics objectForKey:@"borrowAmount"] floatValue]/10000.0);
            NSString *strAmount=[NSString stringWithFormat:@"%.1f万",amount];
            int numberAmount=(int)strAmount.length-1;
            NSMutableAttributedString *attrStrAmountNum=[[NSMutableAttributedString alloc] initWithString:strAmount];
            [attrStrAmountNum addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, numberAmount)];
            [attrStrAmountNum addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:NSMakeRange(numberAmount, 1)];
            [attrStrAmountNum addAttribute:NSFontAttributeName value:FontTextBigNumber range:NSMakeRange(0, numberAmount)];
            [attrStrAmountNum addAttribute:NSFontAttributeName value:FontTextMeidumSmall range:NSMakeRange(numberAmount, 1)];
            _labAmountNum.attributedText=attrStrAmountNum;
            
            NSString *strPeriod;
            int numberPeriod=1;
            int lenghtPeriod=1;//单位长度
            int periodUnit=[[dics objectForKey:@"periodUnit"] intValue];
            if(periodUnit==0){
                strPeriod = [NSString stringWithFormat:@"%@个月",[dics objectForKey:@"period"]];
                numberAmount=(int)strPeriod.length-2;
                lenghtPeriod=2;
            }  else if(periodUnit==-1){
                strPeriod = [NSString stringWithFormat:@"%@年",[dics objectForKey:@"period"]];
                numberAmount=(int)strPeriod.length-1;
            }else if(periodUnit==1){
                strPeriod = [NSString stringWithFormat:@"%@天",[dics objectForKey:@"period"]];
                numberAmount=(int)strPeriod.length-1;
            }
            NSMutableAttributedString *attrStrPeriod=[[NSMutableAttributedString alloc] initWithString:strPeriod];
            [attrStrPeriod addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, numberPeriod)];
            [attrStrPeriod addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:NSMakeRange(numberPeriod, lenghtPeriod)];
            [attrStrPeriod addAttribute:NSFontAttributeName value:FontTextBigNumber range:NSMakeRange(0, numberPeriod)];
            [attrStrPeriod addAttribute:NSFontAttributeName value:FontTextMeidumSmall range:NSMakeRange(numberPeriod, lenghtPeriod)];
            _labPeriod.attributedText=attrStrPeriod;
            
            
            bidAmout = [NSString stringWithFormat:@"%0.1f",[[dics objectForKey:@"borrowAmount"] floatValue]];
            apr = [NSString stringWithFormat:@"%0.1f",[[dics objectForKey:@"annualRate"] floatValue]];
            deadLine = [NSString stringWithFormat:@"%@", [dics objectForKey:@"period"]]; // 期限
            
            repayType = [[dics objectForKey:@"paymentType"] intValue];    // 还款方式
            deadType = [[dics objectForKey:@"bonusType"] intValue];
            bonus = [[dics objectForKey:@"bonus"] intValue];
            awardScale = [[dics objectForKey:@"awardScale"] intValue];
            
            //剩余时间
            if(![[dics objectForKey:@"paymentTime"] isEqual:[NSNull null]])
            {
                NSString *dataStr = [dics objectForKey:@"paymentTime"];
                _dateLabel.text =   [dataStr   substringWithRange:NSMakeRange(0,10)];//截取字符串
                
            }else {
                _dateLabel.text = nil;
            }
            
            if (_statuNum == 1 || _statuNum == 2 || _statuNum == 3) {
                // 借款中
                if ([_progressLabel.text isEqualToString:@"100%"])
                {
                    [self onTimeViewHide:YES];
                }
                if( [dics objectForKey:@"remainTime"] != nil &&![[dics objectForKey:@"remainTime"] isEqual:[NSNull null]])
                {
                    
                    NSString  *timeStr = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"remainTime"]] substringWithRange:NSMakeRange(0, 19)];
                    [self timeDown:timeStr];
                }
            }
            else
            {
                [self onTimeViewHide:YES];
            }
    
            //借款详情描述
            _borrowDetails = [dics objectForKey:@"borrowDetails"];
            //CBO审核
            _CBOAuditStr =  [dics objectForKey:@"CBOAuditDetails"];
            _borrowerId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"bidUserIdSign"]];
            _borrowId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"borrowid"]];
            _borrowerheadImg = [dics objectForKey:@"borrowerheadImg"];
            
            _idLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"no"]];
            noId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"no"]];
            
            if( [dics objectForKey:@"borrowername"] != nil &&![[dics objectForKey:@"borrowername"] isEqual:[NSNull null]])
            {
                _borrowername = [dics objectForKey:@"borrowername"];
            }
            _creditRating = [dics objectForKey:@"creditRating"];
            _BorrowsucceedStr = [dics objectForKey:@"borrowSuccessNum"];
            _BorrowfailStr = [dics objectForKey:@"borrowFailureNum"];
            _repaymentnormalStr= [dics objectForKey:@"repaymentNormalNum"];
            _repaymentabnormalStr = [dics objectForKey:@"repaymentOverdueNum"];
            
            //审核科目数组
            if( [dics objectForKey:@"list"] != nil && ![[dics objectForKey:@"list"] isEqual:[NSNull null]])
            {
                _list = [dics objectForKey:@"list"];
                for (NSDictionary* dic in _list) {
                    
                    if ([[dic objectForKey:@"statusNum"]integerValue]!= 4)//上传未付款不显示
                    {
                        [_AuditdataArr addObject:[dic  objectForKey:@"AuditSubjectName"]];
                        [_auditStatusArr addObject:[dic  objectForKey:@"statusNum"]];
                        [_imgpathArr addObject:[dic  objectForKey:@"imgpath"]];
                        
                        if( [dic objectForKey:@"isVisible"] != nil && ![[dic objectForKey:@"isVisible"] isEqual:[NSNull null]])
                        {
                            [_isVisibleArr addObject:[dic  objectForKey:@"isVisible"]];
                        }
                    }
                    
                }
            }
          
            //历史纪录部分
            if( [dics objectForKey:@"registrationTime"] != nil &&![[dics objectForKey:@"registrationTime"] isEqual:[NSNull null]])
            {
                _registrationTime = [NSString stringWithFormat:@"%@",[dics objectForKey:@"registrationTime"]];
            }
            
            _SuccessBorrowNum = [NSString stringWithFormat:@"%@",[dics objectForKey:@"SuccessBorrowNum"]];
            _NormalRepaymentNum = [NSString stringWithFormat:@"%@",[dics objectForKey:@"NormalRepaymentNum"]];
            _OverdueRepamentNum = [NSString stringWithFormat:@"%@",[dics objectForKey:@"OverdueRepamentNum"]];
            _reimbursementAmount = [NSString stringWithFormat:@"%@",[dics objectForKey:@"reimbursementAmount"]];
            _BorrowingAmount = [NSString stringWithFormat:@"%@",[dics objectForKey:@"BorrowingAmount"]];
            _FinancialBidNum = [NSString stringWithFormat:@"%@",[dics objectForKey:@"FinancialBidNum"]];
            _paymentAmount = [NSString stringWithFormat:@"%@",[dics objectForKey:@"paymentAmount"]];
 
            //投标奖励
            _awardString = [NSString stringWithFormat:@"%@",[dics objectForKey:@"bonus"]] ;//奖励
    
            [_listView reloadData];
            
        }else if (num2 == 2) {
            //DLOG(@"收藏信息===========%@",[obj objectForKey:@"msg"]);
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            NSString *str = [NSString stringWithFormat:@"%@",[obj objectForKey:@"attentionBidId"]];
            
            if(str.length)
            {
                _collectNum = 1;
                _collectId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionBidId"]];
                [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }
        }else if (num2 == 5){
        
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            _collectNum = 0;
            [_collectBtn setImage:[UIImage imageNamed:@"no_collection"] forState:UIControlStateNormal];
        
        }else if (num2 == 3) {
          //关注用户
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            NSString *str = [NSString stringWithFormat:@"%@",[obj objectForKey:@"attentionId"]];
            
            if(str.length)
            {
                _attentionNum = 1;
                _attentionId = [NSString stringWithFormat:@"%@",[obj objectForKey:@"attentionId"]];
                   [_attBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            }
        
        }else if (num2 == 4){
            //取消用户
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            _attentionNum = 0;
               [_attBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }
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

#pragma mark - UItableViewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableArr count]+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 95.0f;
    }else {
        return 35.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static  NSString *cellID = @"cellid";
        BorrowDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[BorrowDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[NSString stringWithFormat:@"%@",_borrowerheadImg] hasPrefix:@"http"]) {
             [cell.HeadimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_borrowerheadImg]] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
        }else{
          
            [cell.HeadimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,_borrowerheadImg]] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
        }
        
        cell.NameLabel.text = [NSString stringWithFormat:@"%@***", [_borrowername substringWithRange:NSMakeRange(0, 1)]];
        cell.BorrowsucceedLabel.text = _BorrowsucceedStr;
        cell.BorrowfailLabel.text = _BorrowfailStr;
        cell.repaymentnormalLabel.text = _repaymentnormalStr;
        cell.repaymentabnormalLabel.text = _repaymentabnormalStr;

        NSArray *strArray = [_creditRating componentsSeparatedByString:@"/"];
        NSArray *strImageName=[strArray[strArray.count-1] componentsSeparatedByString:@"."];
        if(([strImageName[0] length])>0){
            [cell.LevelimgView setImage:[UIImage imageNamed:strImageName[0]]];
        }else{
            if ([_creditRating hasPrefix:@"http"]) {
                [cell.LevelimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_creditRating]] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
                
            }else{
                [cell.LevelimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,_creditRating]] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
            }
        }
        
        if(_attentionNum){
            
            [cell.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }
        [cell.attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.CalculateBtn setImage:[UIImage imageNamed:@"menu_calculator"] forState:UIControlStateNormal];
        [cell.CalculateBtn addTarget:self action:@selector(CalculateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *expanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        expanBtn.frame = CGRectMake(self.view.frame.size.width-30, 35, 25, 20);
        [expanBtn setImage:[UIImage imageNamed:@"cell_more_btn"] forState:UIControlStateNormal];
        [expanBtn setTag:100];
        expanBtn.userInteractionEnabled = NO;
        [cell addSubview:expanBtn];
        return cell;
    }else {
        NSString *cellID2 = @"cellid2";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        }
        cell.textLabel.text = [tableArr objectAtIndex:indexPath.section-1];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
        UIButton *expanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        expanBtn.frame = CGRectMake(self.view.frame.size.width-30, 8, 25, 20);
        [expanBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
        [expanBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateSelected];
        [expanBtn setTag:indexPath.section];
        expanBtn.userInteractionEnabled = NO;
        if (indexPath.section == 6||indexPath.section == 7) {

            [expanBtn setImage:[UIImage imageNamed:@"cell_more_btn"] forState:UIControlStateNormal];
        
        }
        [cell addSubview:expanBtn];
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell1 = [_listView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell1 viewWithTag:indexPath.section];
    
    if (btn.selected == 0) {
        btn.selected = 1;
    }
    
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    switch (indexPath.section) {
        case 0:
        {
            BorrowerInformationViewController *BorrowerInformationView = [[BorrowerInformationViewController alloc] init];
            BorrowerInformationView.borrowerID = _borrowerId;
            BorrowerInformationView.borrowId = _borrowId;
            BorrowerInformationView.paceNum = _paceNum;
            [self.navigationController pushViewController:BorrowerInformationView animated:YES];
        }
            break;
            
        case 1:
        {
                        
            DetailsDescriptionViewController *DetailsDescriptionView = [[DetailsDescriptionViewController alloc] init];
            
            NSString *result = nil;
            
            if(_borrowDetails != nil && ![_borrowDetails isEqual:[NSNull null]])
            {
                result = [self filterHTML:_borrowDetails];
            }else{
                _borrowDetails = @"无更多描述";
                result = _borrowDetails;
            }

            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font =[UIFont boldSystemFontOfSize:13.0f];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize labelSize = [result boundingRectWithSize:CGSizeMake(WidthScreen-30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            DetailsDescriptionView.textString = result;
            DetailsDescriptionView.labelSize =labelSize;
            
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:DetailsDescriptionView.view openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                         btn.selected = !btn.selected;
                                           _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView+labelSize.height+SpaceMediumBig);
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            
                                        }
                                   completionBlock:^{
                                       _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView);
                                   }];
        }
            break;
        case 2:
        {
            MaterialAuditSubjectViewController *MaterialAuditSubjectView = [[MaterialAuditSubjectViewController alloc] init];
            MaterialAuditSubjectView.view.frame = CGRectMake(0, 0, 1000, [_AuditdataArr count]*35+20);
            
            if (_AuditdataArr.count) {
                for (int i = 0; i<[_AuditdataArr count]; i++) {
                    
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5+35*i, 120, 30)];
                    titleLabel.font = [UIFont systemFontOfSize:13.0f];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.text = [_AuditdataArr objectAtIndex:i];
                    [MaterialAuditSubjectView.view addSubview:titleLabel];
                    
                    UIButton *lookBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
                    [lookBtn setTag:i+100];
                    [lookBtn setFrame:CGRectMake(WidthScreen-80, 5 + 35 * i, 80, 30)];
            
                    NSString *temp = nil;
                    
                    if (_isVisibleArr.count != 0)
                    {
                        temp = [NSString stringWithFormat:@"%@", [_isVisibleArr objectAtIndex:i]];
                    }
                    
                    if([[_imgpathArr objectAtIndex:i] isEqual:[NSNull null]] || [temp isEqualToString:@"0"])
                    {
                        [lookBtn setTitle:@"不可见" forState:UIControlStateNormal];
                        lookBtn.userInteractionEnabled = NO;
                    }else {
                        [lookBtn setTitle:@"查看" forState:UIControlStateNormal];
                    }
                    
                    [lookBtn setTintColor:[UIColor grayColor]];
                    lookBtn.titleLabel.textColor = [UIColor grayColor];
                    [lookBtn addTarget:self action:@selector(LookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [MaterialAuditSubjectView.view addSubview:lookBtn];
                    
                    UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 8+35*i, 25, 25)];
                    [stateView setTag:i+100];
                    
                    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateView.frame)+10, 0+35*i, 90, 40)];
                    [stateLabel setTag:i+300];
                    stateLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
                    
                    switch ([[_auditStatusArr objectAtIndex:i] integerValue]) {
                        case 0:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_nopass"]];
                            stateLabel.text = @"未提交";
                            stateLabel.textColor = [UIColor grayColor];
                        }
                            break;
                        case 1:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_wait"]];
                            stateLabel.text = @"审核中";
                            stateLabel.textColor = [UIColor grayColor];
                        }
                            break;
                        case 2:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_pass"]];
                            stateLabel.text = @"通过审核";
                            stateLabel.textColor = GreenColor;
                        }
                            break;
                        case 3:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_nopass"]];
                            stateLabel.text = @"过期失效";
                            stateLabel.textColor = [UIColor grayColor];
                        }
                            break;
                        case -1:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_nopass"]];
                            stateLabel.text = @"未通过审核";
                            stateLabel.textColor = [UIColor grayColor];
                        }
                            break;
                    }
                    
                    [MaterialAuditSubjectView.view addSubview:stateView];
                    [MaterialAuditSubjectView.view addSubview:stateLabel];
                }
                
            }
            
            
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:MaterialAuditSubjectView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             btn.selected = !btn.selected;
                                             _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView+[_AuditdataArr count]*35+20);
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            
                                        }
                                   completionBlock:^{
                                       _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView);
                                   }];
            
        }
            
            break;
        case 3:
        {
            CBORiskControlSystemViewController *CBORiskControlSystemView = [[CBORiskControlSystemViewController alloc] init];
            
            if(_CBOAuditStr!= nil && ![_CBOAuditStr isEqual:[NSNull null]])
            {
                CBORiskControlSystemView.CBOtextString= _CBOAuditStr;
                
            }else{
                
                _CBOAuditStr = @"暂无审核情况";
                CBORiskControlSystemView.CBOtextString = _CBOAuditStr;
            }
            //判断内容尺寸
            CGSize maxSize = CGSizeMake(WidthScreen-60, 10000);
            CGSize ViewSize = [_CBOAuditStr boundingRectWithSize:maxSize
                                                         options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                         context:nil].size;
            
            CBORiskControlSystemView.view.frame = CGRectMake(0, 0, WidthScreen, ViewSize.height+10);
            CBORiskControlSystemView.textlabel.frame = CGRectMake(30, 0, WidthScreen-60, ViewSize.height+8);
            
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:CBORiskControlSystemView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             btn.selected = !btn.selected;
                                             _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView+ViewSize.height+SpaceMediumBig);
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                        }
                                   completionBlock:^{
                                       _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView);
                                   }];

        }
            break;
        case 4:
        {
            // 历史记录
            HistoricalRecordViewController *HistoricalRecordView = [[HistoricalRecordViewController alloc] init];
            HistoricalRecordView.timeString = _registrationTime;
            HistoricalRecordView.successfulnumString = [NSString stringWithFormat:@"%@  次",_SuccessBorrowNum];
            HistoricalRecordView.normalnumString = [NSString stringWithFormat:@"%@  次",_NormalRepaymentNum];
            HistoricalRecordView.limitnumString = [NSString stringWithFormat:@"%@  次",_OverdueRepamentNum];
            HistoricalRecordView.repaymentString = [NSString stringWithFormat:@"%@  元",_reimbursementAmount];
            HistoricalRecordView.borrowString = [NSString stringWithFormat:@"%@  元",_BorrowingAmount];
            HistoricalRecordView.tendernumString = [NSString stringWithFormat:@"%@  次",_FinancialBidNum];
            HistoricalRecordView.receiptString = [NSString stringWithFormat:@"%@  元",_paymentAmount];
            
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:HistoricalRecordView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                                btn.selected = !btn.selected;
                                             _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView+HeightHistoricalView+SpaceMediumBig);
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                        }
                                   completionBlock:^{
                                       _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView);
                                   }];
        }
            break;
            
            
        case 5:
        {
            // 投标奖励
            TenderAwardViewController *TenderAwardView = [[TenderAwardViewController alloc] init];
            
            UILabel *textlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 30)];
            textlabel1.font = [UIFont boldSystemFontOfSize:13.0f];
            textlabel1.textColor = [UIColor grayColor];
            
            UILabel *textlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 260, 30)];
            textlabel3.font = [UIFont systemFontOfSize:13.0f];
            textlabel3.textColor = [UIColor redColor];
            
            UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(155, 20, 260, 30)];
            textlabel2.font = [UIFont boldSystemFontOfSize:13.0f];
            textlabel2.textColor = [UIColor grayColor];
            
            if(deadType == 0)
            {
                textlabel2.text = @"不设置奖励";
                textlabel2.frame = CGRectMake(20, 20, 260, 30);
                
            }else {
                
                if (deadType == 1) {
                    textlabel1.text = @"固定奖金";
                    textlabel2.text = @"元。";
                    textlabel3.text = [NSString stringWithFormat:@"%.0f", bonus];
                }else if (deadType == 2) {
                    textlabel1.text = @"百分比奖金";
                    textlabel2.text = @"%。";
                    textlabel3.text = [NSString stringWithFormat:@"%.0f", awardScale];
                }
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                UIFont *font = [UIFont boldSystemFontOfSize:13.0f];
                NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
   
                CGSize _label3Sz = [textlabel3.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                CGSize _label2Sz = [textlabel2.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
                if (deadType == 1) {
                    textlabel3.frame = CGRectMake(85, 20,  _label3Sz.width + 5, 30);
                }else if(deadType == 2) {
                    textlabel3.frame = CGRectMake(100, 20,  _label3Sz.width + 5, 30);
                }
                
                textlabel2.frame = CGRectMake(textlabel3.frame.origin.x + textlabel3.frame.size.width+10, 20, _label2Sz.width + 15, 30);
                
            }
            
            [TenderAwardView.view addSubview:textlabel1];
            [TenderAwardView.view addSubview:textlabel3];
            [TenderAwardView.view addSubview:textlabel2];

            [folderTableView openFolderAtIndexPath:indexPath WithContentView:TenderAwardView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                                btn.selected = !btn.selected;
                                             _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView+HeightTender+SpaceMediumBig);
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                        }
                                   completionBlock:^{
                                       _listView.contentSize = CGSizeMake(WidthScreen, _heightContainTableView);
                                   }];
            
        }
            break;
            
        case 6:
        {
            // 投标记录
            btn.selected = 0;
            TenderRecordsViewController *TenderRecordsView = [[TenderRecordsViewController alloc] init];
            TenderRecordsView.borrowID = _borrowId;
            TenderRecordsView.paceNum = _paceNum;
            [self.navigationController pushViewController:TenderRecordsView animated:YES];
            
        }
            break;
            
        case 7:
        {
            // 向借款人提问
            btn.selected = 0;
            AskBorrowerViewController *AskBorrowerView = [[AskBorrowerViewController alloc] init];
            AskBorrowerView.borrowId = _borrowId;
            AskBorrowerView.bidUserIdSign = _borrowerId;
            AskBorrowerView.paceNum = _paceNum;
            [self.navigationController pushViewController:AskBorrowerView animated:YES];
            
        }
            break;
    }
}


#pragma mark - 证件审核查看按钮
- (void)LookBtnClick:(UIButton *)btn
{
    if ([_imgpathArr objectAtIndex:btn.tag-100]) {
        isShowScrollerpanel=YES;
        scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
        scrollPanel.backgroundColor = ColorBGGray;
        scrollPanel.alpha = 0;

        //点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceMediumSmall, SpaceMediumSmall, WidthScreen-SpaceMediumSmall*2, HeightScreen-SpaceMediumSmall*2-HeightNavigationAndStateBar)];
        imageView.layer.cornerRadius=2.0f;
        imageView.layer.masksToBounds=YES;
        if ([[NSString stringWithFormat:@"%@",[_imgpathArr objectAtIndex:btn.tag-100]] hasPrefix:@"http"]) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_imgpathArr objectAtIndex:btn.tag-100]]]];
        }else{
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,[_imgpathArr objectAtIndex:btn.tag-100]]]];
        }
       
        [imageView addGestureRecognizer:tap];
        [imageView setUserInteractionEnabled:YES];
        [scrollPanel addSubview:imageView];
        
        [self.view bringSubviewToFront:scrollPanel];
        scrollPanel.alpha = 1.0;
        [self.view addSubview:scrollPanel];
    }
}

#pragma 退出证件查看
-(void)tapClick
{
    isShowScrollerpanel=NO;
    [scrollPanel removeFromSuperview];
}

#pragma mark 关注按钮
- (void)attentionBtnClick:(UIButton *)btn
{
    _attBtn = btn;
    if (AppDelegateInstance.userInfo == nil) {
       [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }
    else
    {
        //DLOG(@"关注按钮");
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if(_attentionNum == 0){
        num2 = 3;
        //关注接口
        [parameters setObject:@"71" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:[NSString stringWithFormat:@"%@",_borrowerId] forKey:@"bidUserIdSign"];
        [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
        }else{
            
        num2 = 4;
        //取消关注接口
        [parameters setObject:@"150" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_attentionId forKey:@"attentionId"];
        }
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
      
        }
       [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}
#pragma mark 计算器按钮
- (void)CalculateBtnClick
{
    InterestcalculatorViewController *interestcalculatorView = [[InterestcalculatorViewController alloc] init];
    interestcalculatorView.status = 1;
    interestcalculatorView.bidAmout = bidAmout;
    interestcalculatorView.apr = apr;
    interestcalculatorView.deadLine = deadLine;
    interestcalculatorView.repayType = repayType;
    interestcalculatorView.bonus = bonus;
    interestcalculatorView.deadType = deadType;
    interestcalculatorView.awardScale = awardScale;
    interestcalculatorView.deadperiodUnit = deadperiodUnit;
    [self.navigationController pushViewController:interestcalculatorView animated:YES];
}

#pragma mark 收藏按钮
- (void)collectBtnClick:(UIButton *)btn
{
     //DLOG(@"收藏按钮");
    if (AppDelegateInstance.userInfo == nil) {
     [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if(_collectNum ==0)
        {
            num2 = 2;
            //收藏借款标接口
            [parameters setObject:@"72" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%@",_bidIdSign] forKey:@"bidIdSign"];
            [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
          
        }else{
            num2 = 5;
            //取消收藏接口
            [parameters setObject:@"153" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"bidId"];
            [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"userId"];
        }

        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma  分享按钮
- (void)shareClick
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }else {
        //DLOG(@"分享按钮 -> %@", _borrowID);
        NSString *shareUrl = [NSString stringWithFormat:@"%@/front/invest/invest?bidId=%@", Baseurl, _borrowID];
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来融金服 我要投资 借款详情%@",shareUrl]
                   defaultContent:@"默认分享内容，没内容时显示"
                      image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"news_image_default"]]
                             title:@"借款详情"url:shareUrl
                    description:@"这是一条测试信息"mediaType:SSPublishContentMediaTypeNews];
        
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        //DLOG(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        //DLOG(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [error errorDescription]]];
                                    }
                                }];
    }
}

#pragma 立即投标
- (void)tenderBtnClick
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }else {
        TenderOnceViewController *tenderOnceView = [[TenderOnceViewController alloc] init];
        tenderOnceView.borrowId = _borrowId;
        tenderOnceView.noId = noId;
        [self presentViewOrPushController:tenderOnceView animated:YES completion:nil];
    }
}


#pragma 提交资料
- (void)postInfoClick
{
    LiteratureAuditViewController *literatureAuditView = [[LiteratureAuditViewController alloc] init];
    [self presentViewOrPushController:literatureAuditView animated:YES completion:nil];
}

#pragma 查看理财账单
- (void)finaBillClick
{
    FinancialBillsViewController *financialBillsView = [[FinancialBillsViewController alloc] init];
    [self presentViewOrPushController:financialBillsView animated:YES completion:nil];
}

#pragma 查看账单
- (void)seeBillClick
{
    BorrowingBillViewController *borrowbillView = [[BorrowingBillViewController alloc] init];
    [self presentViewOrPushController:borrowbillView animated:YES completion:nil ];
}

//剩余时间倒计时
- (void)timeDown:(NSString *)timeStr
{
    //剩余时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSDate *senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:timeStr];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    _time=[endDate timeIntervalSinceDate:senderDate];
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0)
    {
        _dateLabel2.text =@"已过期";
        [self onShowBottom:NO];
    }
    else
    {
        _dateLabel2.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
    }


}

//剩余时间倒计时(每秒钟调用一次)
- (void)timerFireMethod
{
    _time--;
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0)
    {
        _dateLabel2.text =@"已过期";
        [self onShowBottom:NO];
    }
    else
    {
        _dateLabel2.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
 
    }
}

// *******  去掉 html字符串中所有标签  **********
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    
    NSString * text = nil;
    
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    return html;
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}
-(void)back{
    if(isShowScrollerpanel){
        [self tapClick];
    }else{
        [super back];
    }
}
@end
