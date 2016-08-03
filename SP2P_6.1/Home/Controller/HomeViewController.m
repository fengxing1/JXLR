//
//  HomeViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  首页
//
#import "HomeViewController.h"
#import "BarButtonItem.h"
#import "ColorTools.h"
#import "HomeListView.h"
#import "Investment.h"
#import "AdvertiseGallery.h"
#import "AdWebViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "CacheUtil.h"
#import "ViewInvestContent.h"
#import "AdScrollViewLabel.h"
#import "BorrowingDetailsViewController.h"
#import "ToolBlackView.h"
#import "HomeBid.h"

#define AppStoreAPI @"http://itunes.apple.com/lookup?id=1049683807"
#define AppStoreDownLoadUrl @"https://itunes.apple.com/cn/app/lai-rong-jin-fu/id1049683807?mt=8"
#define HeightAnnouncement 35  //公告高度
#define HeightAnnouncementMessage 24
#define WHImageAnnounce 18  //公告
#define WidthImageMore 9      //更多
#define HeightImageMore 17
#define HeightBtnReConnect 35 //重新加载按钮高度
#define WidthBtnReConnect 110 //重新加载按钮宽度
#define HeightContentScroller (HeightScreen-HeightNavigationAndStateBar-HeightTabBar)

@interface HomeViewController ()<FocusImageFrameDelegate,FocusMessageFrameDelegate>
{
    NSMutableArray *_adArrays;
}

@property (nonatomic, strong) UIScrollView *scrollContent;
//广告 公告内容
@property (nonatomic, strong) UIView *viewContentAnnounce;
@property (nonatomic, strong) UIButton *btnAnnounceMent;//广告滚动栏下的公告
@property (nonatomic, strong) AdScrollViewLabel *adScrollViewLabel;
@property (nonatomic, strong) NSMutableArray *arrayNewBidMessage;//最新投标资讯
@property (nonatomic, strong) NSMutableArray *arrayTempNewBidMessage;//图片信息
@property (nonatomic, strong) NSMutableArray *arrayNewBidData;
@property (nonatomic, strong) UILabel *labNewBidMessage;
//新标内容
@property (nonatomic, strong) UIView *viewContentNewBid;
@property (nonatomic, strong) HomeBid *homeBid;
@property (nonatomic, strong) ViewInvestContent *viewInvestContentOne;
@property (nonatomic, strong) ViewInvestContent *viewInvestContentTwo;
//重新连接
@property (nonatomic, strong) UIView *viewContentReConnect;
@property (nonatomic, strong) UILabel *labReConnectMessage;
@property (nonatomic, strong) UIImageView *imageViewReConnect;
@property (nonatomic, strong) UIButton *btnReConnect;
@property (nonatomic, strong) NSMutableArray  *tempArrays;
@property (nonatomic,strong) UIView *blockView;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取刷新新标通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:InvestRefresh object:nil];
    
    //self.navigationController.navigationBarHidden = YES;
    
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navgationState=NavgationStateWhiteNotBack;
    [super viewWillAppear:animated];
    [self requestData];
    [self requestLogin];
    //升级检测
    [self upload];
}


- (void)readAdData
{
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:_tempArrays.count+2];
    //添加最后一张图 用于循环
    if (_tempArrays.count > 1)
    {
        AdvertiseGallery *bean = [_tempArrays objectAtIndex:_tempArrays.count-1];
        bean.tag = -1;
        [itemArray addObject:bean];
    }
    
    for (int i = 0; i < _tempArrays.count; i++)
    {
        AdvertiseGallery *bean = [_tempArrays objectAtIndex:i];
        [itemArray addObject:bean];
    }
    
    //添加第一张图 用于循环
    if (_tempArrays.count >1)
    {
        AdvertiseGallery *bean = [_tempArrays objectAtIndex:0];
        bean.tag = _tempArrays.count;
        [itemArray addObject:bean];
    }
    
    [_adArrays addObjectsFromArray:itemArray];
}

-(void)readMessageData{
    NSMutableArray *itemMessageArray = [NSMutableArray arrayWithCapacity:_arrayNewBidMessage.count+2];
    //添加最后一张图 用于循环
    if (_arrayNewBidMessage.count > 1)
    {
        NSString *message = [_arrayTempNewBidMessage objectAtIndex:_arrayTempNewBidMessage.count-1];
        [itemMessageArray addObject:message];
    }
    
    for (int i = 0; i < _arrayTempNewBidMessage.count; i++)
    {
        NSString *message = [_arrayTempNewBidMessage objectAtIndex:i];
        [itemMessageArray addObject:message];
    }
    
    //添加第一张图 用于循环
    if (_arrayTempNewBidMessage.count >1)
    {
        NSString *message = [_arrayTempNewBidMessage objectAtIndex:0];
        [itemMessageArray addObject:message];
    }
    
    [_arrayNewBidMessage addObjectsFromArray:itemMessageArray];
}

/**
 *  读取首页缓存数据
 */
-(void) readCacheData
{
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:CacheFileHomeMessage];// 合成归档保存的完整路径
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    [self readCacheAdData:dics];// 读取上一次成功缓存的数据
}

/**
 * 初始化数据
 */
- (void)initData
{
    _adArrays = [[NSMutableArray alloc] init];
    _tempArrays = [[NSMutableArray alloc] init];
    _arrayNewBidData=[[NSMutableArray alloc] init];
    for (int i=0; i<4;i++)
    {
        AdvertiseGallery *bean = [[AdvertiseGallery alloc] initWithTitle:@"" image:@"" tag:i url:@"" id:@""];
        [_tempArrays addObject:bean];
    }
    _arrayNewBidMessage=[[NSMutableArray alloc] init];
    _arrayTempNewBidMessage=[[NSMutableArray alloc] init];
    NSString *startMessage=@"普惠三农，你来我融！";
    NSMutableAttributedString *attriMessage=[[NSMutableAttributedString alloc] initWithString:startMessage];
    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[startMessage rangeOfString:startMessage]];
    [_arrayTempNewBidMessage addObject:attriMessage];
    
    [self readAdData];
    [self readMessageData];
}

bool isUpdate = YES;
#pragma mark 版本更新
-(void) upload
{
    NSDate *dateLast=[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsTimeIntervalUpdate];
    int hours;
    if(dateLast==nil){
        hours=9;
    }else{
        NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:dateLast];
        hours=((int)time)/3600;
    }
    
    if (hours>=TimeIntervalUpdate) {
        if (isUpdate) {
            isUpdate = NO;
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:UserDefaultsTimeIntervalUpdate];
            
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];//CFBundleVersion
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:AppStoreAPI]];
            [request setHTTPMethod:@"POST"];
            
            NSHTTPURLResponse *urlResponse = nil;
            NSError *error = nil;
            NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [self dictionaryWithJsonString:results];
            NSArray *infoArray = [dic objectForKey:@"results"];
            if ([infoArray count]) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                AppDelegateInstance.lastVersion=lastVersion;
                NSComparisonResult result=[currentVersion compare:lastVersion];
                NSString *releaseNotes = [releaseInfo objectForKey:@"releaseNotes"];
                AppDelegateInstance.releaseNotes=releaseNotes;
                
                if(result == NSOrderedAscending)
                {
                    _blockView=[ToolBlackView createRemindWithContent:[NSString stringWithFormat:@"%@", releaseNotes] withTarget:self withAction:@selector(onClickUpdata) withCloseAction:@selector(onClickUpdataClose)];
                }
            }
        }
    }
}

/**
 初始化数据
 */
- (void)initView
{
    self.title = NSLocalizedString(@"Tab_Home", nil);
    //滑动内容View
    _scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightScreen - HeightNavigationAndStateBar)];
    _scrollContent.showsHorizontalScrollIndicator = NO;
    _scrollContent.showsVerticalScrollIndicator = NO;
    [_scrollContent setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 48, 0)];
    [_scrollContent setContentInset:UIEdgeInsetsMake(0, 0, 48, 0)];
    _scrollContent.contentSize = CGSizeMake(WidthScreen,HeightContentScroller);
    _scrollContent.backgroundColor=ColorBGGray;
    [self.view addSubview:_scrollContent];

    //广告公告内容
    _viewContentAnnounce=[[UIView alloc] init];
    _viewContentAnnounce.backgroundColor=[UIColor clearColor];
    [_scrollContent addSubview:_viewContentAnnounce];
    
    //广告展板
    _adScrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, WidthScreen/RateAd) delegate:self imageItems:_adArrays isAuto:YES];
    _adScrollView.contentMode =  UIViewContentModeScaleAspectFill;
    [_viewContentAnnounce addSubview:_adScrollView];
    
    //公告信息
    _btnAnnounceMent=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnAnnounceMent.frame=CGRectMake(0, CGRectGetMaxY(_adScrollView.frame), WidthScreen, HeightAnnouncement);
    _btnAnnounceMent.backgroundColor=[UIColor whiteColor];
//    [_btnAnnounceMent setBackgroundImage:[ImageTools imageWithColor:[UIColor whiteColor] withSize:CGSizeMake(WidthScreen, HeightAnnouncement)] forState:UIControlStateNormal];
//    [_btnAnnounceMent setBackgroundImage:[ImageTools imageWithColor:ColorBtnWhiteHighlight withSize:CGSizeMake(WidthScreen, HeightAnnouncement)] forState:UIControlStateHighlighted];
    
    //设置公告动画
    NSArray *arrayImg=[NSArray arrayWithObjects:[UIImage imageNamed:@"announcement_1"],[UIImage imageNamed:@"announcement_2"],[UIImage imageNamed:@"announcement_3"], nil];
    UIImageView *imageViewAnn=[[UIImageView alloc] initWithFrame:CGRectMake(SpaceMediumBig,CGRectGetHeight(_btnAnnounceMent.frame)/2-WHImageAnnounce/2, WHImageAnnounce, WHImageAnnounce)];
    [imageViewAnn setAnimationImages:arrayImg];
    [imageViewAnn setAnimationDuration:1.5f];
    [imageViewAnn startAnimating];
    [_btnAnnounceMent addSubview:imageViewAnn];
    
    //公告展板
    _adScrollViewLabel = [[AdScrollViewLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageViewAnn.frame)+SpaceSmall, (HeightAnnouncement-HeightAnnouncementMessage)/2, WidthScreen-CGRectGetMaxX(imageViewAnn.frame)-SpaceSmall-SpaceBig,HeightAnnouncementMessage) delegate:self messages:_arrayNewBidMessage isAuto:YES];
    [_btnAnnounceMent addSubview:_adScrollViewLabel];
    
//    //更多 image
//    UIImageView *imageViewMore=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
//    imageViewMore.frame=CGRectMake(WidthScreen-SpaceMediumBig-WidthImageMore, (HeightAnnouncement-HeightImageMore)/2, WidthImageMore, HeightImageMore);
//    [_btnAnnounceMent addSubview:imageViewMore];
//    
//    //更多 label
//    NSString *strMore=NSLocalizedString(@"More", nil);
//    UILabel *labMore=[[UILabel alloc] init];
//    labMore.font=FontTextContent;
//    labMore.textColor=ColorTextContent;
//    CGFloat widthMore=[SizeTools getStringWidth:strMore Font:FontTextContent];
//    labMore.text=strMore;
//    labMore.frame=CGRectMake(CGRectGetMinX(imageViewMore.frame)-widthMore-SpaceSmall, 0, widthMore, HeightAnnouncement);
//    [_btnAnnounceMent addSubview:labMore];
    
    //新标预告数据
//    _labNewBidMessage=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageViewAnn.frame)+SpaceSmall, 0, CGRectGetMinX(labMore.frame)-CGRectGetMaxX(imageViewAnn.frame)-SpaceSmall-SpaceMediumSmall, HeightAnnouncement)];
//    _labNewBidMessage.font=FontTextContent;
//    _labNewBidMessage.textColor=ColorTextContent;
//    _labNewBidMessage.text=@"公告｜新标预告借款金额100万借款金额100万借款金额100万借款金额100万";
//    _labNewBidMessage.textAlignment=NSTextAlignmentLeft;
//    [_btnAnnounceMent addSubview:_labNewBidMessage];
    
    [_viewContentAnnounce addSubview:_btnAnnounceMent];
    _viewContentAnnounce.frame=CGRectMake(0, 0, WidthScreen, CGRectGetMaxY(_btnAnnounceMent.frame));
    
    //新标信息
    _viewContentNewBid=[[UIView alloc] init];
    _viewContentNewBid.backgroundColor=[UIColor clearColor];
    [_scrollContent addSubview:_viewContentNewBid];
//
//    _homeBid =[[HomeBid alloc] init];
//    _homeBid.frame=CGRectMake(0, 0, WidthScreen, WidthScreen/1.1);
//    [_homeBid.btnContent addTarget:self action:@selector(onClickBid) forControlEvents:UIControlEventTouchUpInside];
//    [_homeBid.btnInvest addTarget:self action:@selector(onClickBid) forControlEvents:UIControlEventTouchUpInside];
//    [_homeBid initContentBackground];
//    [_viewContentNewBid addSubview:_homeBid];
    
    _homeBid=[[HomeBid alloc]init];
    _homeBid.frame=CGRectMake(0, CGRectGetMinY(_viewContentNewBid.frame), WidthScreen, HeightViewInvestContent);
    [_homeBid.btnContent addTarget:self action:@selector(onClickOneBid) forControlEvents:UIControlEventTouchUpInside];
    [_homeBid.btnInvest addTarget:self action:@selector(onClickOneBidButton) forControlEvents:UIControlEventTouchUpInside];
    [_homeBid initContentBackground];
    [_viewContentNewBid addSubview:_homeBid];

//    
//    _viewInvestContentOne=[[ViewInvestContent alloc] init];
//    _viewInvestContentOne.frame=CGRectMake(0, 0, WidthScreen, HeightViewInvestContent);
//    [_viewInvestContentOne.btnContent addTarget:self action:@selector(onClickOneBid) forControlEvents:UIControlEventTouchUpInside];
//    [_viewInvestContentOne.btnInvest addTarget:self action:@selector(onClickOneBidButton) forControlEvents:UIControlEventTouchUpInside];
//    [_viewInvestContentOne initContentBackground];
//    [_viewContentNewBid addSubview:_viewInvestContentOne];
//
//    _viewInvestContentTwo=[[ViewInvestContent alloc]init];
//    _viewInvestContentTwo.frame=CGRectMake(0, CGRectGetMaxY(_viewInvestContentOne.frame)+SpaceMediumSmall, WidthScreen, HeightViewInvestContent);
//    [_viewInvestContentTwo.btnContent addTarget:self action:@selector(onClickTwoBid) forControlEvents:UIControlEventTouchUpInside];
//    [_viewInvestContentTwo.btnInvest addTarget:self action:@selector(onClickTwoBidButton) forControlEvents:UIControlEventTouchUpInside];
//    [_viewInvestContentTwo initContentBackground];
//    [_viewContentNewBid addSubview:_viewInvestContentTwo];
    
    _viewContentNewBid.frame=CGRectMake(0, CGRectGetMaxY(_btnAnnounceMent.frame)+SpaceMediumSmall, WidthScreen, CGRectGetMaxY(_homeBid.frame));
    _viewContentNewBid.hidden=YES;
    
    //重新加载内容
    _viewContentReConnect=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewContentAnnounce.frame), WidthScreen, HeightScreen-CGRectGetMaxY(_viewContentAnnounce.frame)-HeightNavigationAndStateBar)];
    _viewContentAnnounce.backgroundColor=[UIColor clearColor];
    [_scrollContent addSubview:_viewContentReConnect];
    
    _labReConnectMessage=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_viewContentReConnect.frame)/2-HeightBtnReConnect-SpaceBig*2, WidthScreen, HeightBtnReConnect)];
    _labReConnectMessage.font=FontMedium;
    _labReConnectMessage.textColor=ColorTextVice;
    _labReConnectMessage.text=@"网络异常，请重新连接网络！";
    _labReConnectMessage.textAlignment=NSTextAlignmentCenter;
    [_viewContentReConnect addSubview:_labReConnectMessage];
    
    _btnReConnect=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnReConnect.frame=CGRectMake((CGRectGetWidth(_viewContentReConnect.frame)-WidthBtnReConnect)/2, CGRectGetHeight(_viewContentReConnect.frame)/2-SpaceBig*1.5, WidthBtnReConnect, HeightBtnReConnect);
    _btnReConnect.layer.borderColor=ColorTextVice.CGColor;
    _btnReConnect.layer.borderWidth=HeightLine;
    _btnReConnect.layer.cornerRadius=4.0;
    _btnReConnect.layer.masksToBounds=YES;
    [_btnReConnect setBackgroundImage:[ImageTools imageWithColor:ColorBGGray] forState:UIControlStateNormal];
    [_btnReConnect setBackgroundImage:[ImageTools imageWithColor:ColorLine withAlpha:0.6] forState:UIControlStateHighlighted];
    [_btnReConnect setTitle:@"重新连接" forState:UIControlStateNormal];
    [_btnReConnect setTitleColor:ColorTextVice forState:UIControlStateNormal];
    _btnReConnect.titleLabel.font=FontTextContent;
        [_btnReConnect addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    [_viewContentReConnect addSubview:_btnReConnect];
    _viewContentReConnect.hidden=YES;
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    UIImage *image1 = [UIImage imageNamed:@"listview_pull_refresh01"];
    UIImage *image2 = [UIImage imageNamed:@"listview_pull_refresh02"];
    NSArray *refreshImages = [NSArray arrayWithObjects:image1,image2, nil];
    // Hide the time
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    // Hide the status
    gifHeader.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    [gifHeader setImages:refreshImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [gifHeader setImages:refreshImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [gifHeader setImages:refreshImages forState:MJRefreshStateRefreshing];
    
    _scrollContent.mj_header = gifHeader;

}

-(void)showNewBidDetails:(Investment *)investment{
    [self.netWorkRM requestBorrowDetails:investment.borrowId];
    BorrowingDetailsViewController *BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    BorrowingDetailsView.titleString = investment.title;
    BorrowingDetailsView.borrowID = investment.borrowId;
    BorrowingDetailsView.progressnum = (investment.progress)*0.01;
    BorrowingDetailsView.rate = investment.rate;
    BorrowingDetailsView.timeString = investment.time;
    BorrowingDetailsView.stateNum = 0;
    BorrowingDetailsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:BorrowingDetailsView animated:YES];
}

-(void)onClickOneBid{
    if([self.arrayNewBidData count]>0){
        [self showNewBidDetails:[self.arrayNewBidData objectAtIndex:0]];
    }
}
-(void)onClickTwoBid{
    if([self.arrayNewBidData count]>1){
        [self showNewBidDetails:[self.arrayNewBidData objectAtIndex:1]];
    }
}
-(void)onClickOneBidButton{
    if([self.arrayNewBidData count]>0){
        [self showNewBidDetails:[self.arrayNewBidData objectAtIndex:0]];
    }
}
-(void)onClickTwoBidButton{
    if([self.arrayNewBidData count]>1){
        [self showNewBidDetails:[self.arrayNewBidData objectAtIndex:1]];
    }
}

//成功获取到新标数据
-(void)onHaveNewBidMessage{
    _viewContentReConnect.hidden=YES;
    _viewContentNewBid.hidden=NO;
    
    float contentHeight=MAX(CGRectGetMaxY(_viewContentNewBid.frame)+SpaceMediumSmall, HeightContentScroller);
    _scrollContent.contentSize = CGSizeMake(WidthScreen,contentHeight);
}
//获取数据失败
-(void)onErrorGetNewMessage{
    _viewContentReConnect.hidden=NO;
    _viewContentNewBid.hidden=YES;
    
    _scrollContent.contentSize = CGSizeMake(WidthScreen,HeightContentScroller);
}
#pragma mark 开始进入刷新状态
-(void)requestData{
    [self requestNewBidData];
}
/**
 *  获取滚动栏和公告信息
 */
-(void)requestHomeMessage
{
    [self.netWorkRM requestHomeMessage];
}
/**
 *  获取两个新标数据
 */
-(void)requestNewBidData{
    [self.netWorkRM requestNewBidWithApr:@"0" withAmount:@"" withPage:1];
}
/**
 *  进入首页直接登录
 */
-(void)requestLogin{
    NSString *name=[[AppDefaultUtil sharedInstance] getDefaultAccount];
    NSString *password=[[AppDefaultUtil sharedInstance] getDefaultUserNoPassword];
    if(name!=nil&&password!=nil&&[name length]>0&&[password length]>0){
        [self.netWorkRM requestLoginWithAccount:name withPassword:password withDeviceType:[[AppDefaultUtil sharedInstance] getdeviceType]];
    }
}
#pragma HTTPClientDelegate 网络数据回调代理
-(void)startRequestHomeMessage{
    
}
-(void)responseSuccessHomeMessage:(NSMutableArray *)arrayAdMessage withAnnuMessage:(NSMutableArray *)arrayAnnuMessage withMessge:(NSString *)message{
    [self hiddenRefreshView];
    if(arrayAdMessage.count>0||arrayAnnuMessage.count>0){
        if(arrayAdMessage.count>0){
            [_adArrays removeAllObjects];
            [_tempArrays removeAllObjects];
            for (int i=0;i<arrayAdMessage.count;i++)
            {
                [_tempArrays addObject:arrayAdMessage[i]];
            }
            [self readAdData];
            [_adScrollView changeImageViewsContent:_adArrays];
        }
       
        if(arrayAnnuMessage.count>0){
            [_arrayNewBidMessage removeAllObjects];
            [_arrayTempNewBidMessage removeAllObjects];
            for (int i=0;i<arrayAnnuMessage.count;i++)
            {
                [_arrayTempNewBidMessage addObject:arrayAnnuMessage[i]];
            }
            [self readMessageData];
            [_adScrollViewLabel changeMessagesContent:_arrayNewBidMessage];
        }
    }else{
        if(message==nil)
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        else
            [SVProgressHUD showErrorWithStatus:message];
    }
}

-(void)responseSuccessNewBid:(NSMutableArray *)newBids withMessge:(NSString *)message{
    [self hidHud];
    [self hiddenRefreshView];
    if(newBids.count>0){
        [self onHaveNewBidMessage];
        
        if (newBids.count == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"无新标数据"];
        }else {
            [_arrayNewBidData removeAllObjects];
            [_arrayNewBidData addObject:newBids[0]];
            [_arrayNewBidData addObject:newBids[1]];
            _homeBid.investment = newBids[0];
            _viewInvestContentOne.investment=newBids[0];
            _viewInvestContentTwo.investment=newBids[1];
            [self onHaveNewBidMessage];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self hiddenRefreshView];
            });
        }
    }else{
        [self onErrorGetNewMessage];
        if(message==nil)
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        else
            [SVProgressHUD showErrorWithStatus:message];
    }
    //加载完成新标数据后加载首页数据
    [self requestHomeMessage];
}

-(void)responseSuccessLogin:(UserInfo *)userInfo withMessage:(NSString *)message{
    if(userInfo!=nil){
        AppDelegateInstance.userInfo=userInfo;
    }
}
-(void)networkError{
    [super networkError];
    [self hiddenRefreshView];
    [self onErrorGetNewMessage];
}
-(void)responseFailure:(NSError *)error{
    [super responseFailure:error];
    [self hiddenRefreshView];
    [self onErrorGetNewMessage];
}

-(void) readCacheAdData:(NSDictionary *)dataDics
{
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        //广告滚动条.
        if (![[dataDics objectForKey:@"homeAds"] isEqual:[NSNull null]]) {
            
            NSArray *dataArr = [dataDics objectForKey:@"homeAds"];
            if ([dataArr count]!=0) {
                [_adArrays removeAllObjects];
                [_tempArrays removeAllObjects];
                for (NSDictionary *item in dataArr)
                {
                    AdvertiseGallery *bean = [[AdvertiseGallery alloc] init];
                    bean.title = [item objectForKey:@"title"];
                    
                    if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]] hasPrefix:@"http"]) {
                        
                        bean.image = [NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]];
                    }else
                    {
                        bean.image = [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"image_filename"]];
                    }
                    
                    bean.urlStr = [item objectForKey:@"url"];
                    bean.tag = [_tempArrays count] + 1;
                    [_tempArrays addObject:bean];
                }
                [self readAdData];
                [_adScrollView changeImageViewsContent:_adArrays];
            }
        }
        
        //公告滚动条.
        if (![[dataDics objectForKey:@"invests"] isEqual:[NSNull null]]) {
            
            NSArray *dataMessageArr = [dataDics objectForKey:@"invests"];
            if ([dataMessageArr count]!=0) {
                [_arrayNewBidMessage removeAllObjects];
                [_arrayTempNewBidMessage removeAllObjects];
                for (NSDictionary *item in dataMessageArr)
                {
                    NSString *nameStr = [NSString  stringWithFormat:@"%@",[item objectForKey:@"userName"]];
                    NSString *numStr = [NSString  stringWithFormat:@"%@",[item objectForKey:@"count"]];
                    NSString *aprStr = [NSString  stringWithFormat:@"%@",[item objectForKey:@"apr"]];
                    NSString *amountStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"amount"]];
                    NSString *message = [NSString stringWithFormat:@"会员%@借出¥%@年息%@%%理财%@次",nameStr,amountStr,aprStr,numStr];
                    
                    NSMutableAttributedString *attriMessage=[[NSMutableAttributedString alloc] initWithString:message];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"会员"]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[message rangeOfString:nameStr]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"借出"]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[message rangeOfString:[NSString stringWithFormat:@"¥%@",amountStr]]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"年息"]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[message rangeOfString:[NSString stringWithFormat:@"%@%%",aprStr]]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"理财"]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[message rangeOfString:[NSString stringWithFormat:@"%@次",numStr]]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"次"]];
                    [_arrayTempNewBidMessage addObject:attriMessage];
                }
                [self readMessageData];
                [_adScrollViewLabel changeMessagesContent:_arrayNewBidMessage];
            }
        }
    }else {
        //无缓存有误
        
    }
}

#pragma mark - FocusImageFrameDelegate
- (void)foucusImageFrame:(AdScrollView *)imageFrame didSelectItem:(AdvertiseGallery *)item
{
    if(item.urlStr.length > 0)
    {
        AdWebViewController *adWebView = [[AdWebViewController alloc] init];
        adWebView.urlStr = item.urlStr;
        adWebView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adWebView animated:YES];
    }
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!_scrollContent.mj_header.hidden) {
        [_scrollContent.mj_header endRefreshing];
    }
    
    if (!_scrollContent.mj_footer.hidden) {
        [_scrollContent.mj_footer endRefreshing];
    }
}

//版本更新
-(void)onClickUpdata{
    NSURL *url = [NSURL URLWithString:AppStoreDownLoadUrl];
    [[UIApplication sharedApplication]openURL:url];
}
-(void)onClickUpdataClose{
    [_blockView removeFromSuperview];
}
//字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
        options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        return nil;
    }
    return dic;
}
@end
