//
//  AskBorrowerViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//借款详情 =======》》向借款人提问
#import "AskBorrowerViewController.h"
#import "ColorTools.h"
#import "TenderOnceViewController.h"
#import "AskQuestionViewController.h"
#import "AskBorrowerCell.h"
#import "Questions.h"

#define IS_IOS7                (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)
@interface AskBorrowerViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPClientDelegate>

@property(nonatomic ,strong) NSMutableArray *listDataArr;
@property(nonatomic ,strong) UITableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AskBorrowerViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"askListUpdate" object:nil];
    
    // 初始化视图
    [self initView];
    
    // 初始化数据
    [self initData];
}

/**
 * 初始化数据
 */
- (void)initData
{
    _listDataArr = [[NSMutableArray alloc] init];
}

/**
 初始化视图
 */
- (void)initView
{
    [self initNavigationBar];

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIButton *askBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    askBtn.frame = CGRectMake(SpaceBig, SpaceSmall,WidthScreen-SpaceBig*2, 40-SpaceSmall*2);
    [askBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [askBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    [askBtn setTitle:@"提问" forState:UIControlStateNormal];
    [askBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    askBtn.titleLabel.font = FontTextContent;
    [askBtn.layer setMasksToBounds:YES];
    [askBtn.layer setCornerRadius:3.0];
    [askBtn addTarget:self action:@selector(askBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:askBtn];
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, HeightScreen-40) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.scrollEnabled = YES;
    _listView.dataSource = self;
    [_listView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, SpaceBig+HeightNavigationAndStateBar, 0)];
    [_listView setContentInset:UIEdgeInsetsMake(0, 0, SpaceBig+HeightNavigationAndStateBar, 0)];
    [self.view  addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [self.listView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //    [self.listView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestData];
}

#pragma mark 请求数据
- (void)requestData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //借款提问问题列表
    [dic setObject:@"13" forKey:@"OPT"];
    [dic setObject:@"" forKey:@"body"];
    [dic setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"borrowId"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:dic];
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"向借款人提问";
}


// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    //DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSArray *dataArr = [dics objectForKey:@"questionList"];
        
        [_listDataArr removeAllObjects];
        if (![dataArr isEqual:[NSNull null]]) {
            
            for (NSDictionary *dic in dataArr) {
                
                Questions *Datamodel = [[Questions alloc] init];
                Datamodel.question =  [dic objectForKey:@"content"];
                
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                UIFont *font = [UIFont boldSystemFontOfSize:12.f];
                NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
                CGSize contentSize = [Datamodel.question boundingRectWithSize:CGSizeMake(WidthScreen-50, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                Datamodel.contentHeight = contentSize.height;
                
                
                if(![[dic objectForKey:@"bidAnswerList"] count])
                {
                    Datamodel.answerStr = @"暂无回复";
                }
                else
                {
                    Datamodel.answerStr = [[[dic objectForKey:@"bidAnswerList"] objectAtIndex:0] objectForKey:@"content"];
                }
                
                CGSize answerSize = [Datamodel.answerStr boundingRectWithSize:CGSizeMake(WidthScreen-50, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                Datamodel.answerSize = answerSize.height;
                
                
                Datamodel.answerName = [dic objectForKey:@"name"];
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[dic objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                Datamodel.answerTime  = [dateFormat stringFromDate: date];
                
                [_listDataArr addObject:Datamodel];
            }
        
            [_listView reloadData];
        }
    }else {
        //DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    [self hiddenRefreshView];
}

// 无可用的网络
-(void) networkError
{
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    [self hiddenRefreshView];
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!self.listView.isHeaderHidden) {
        [self.listView headerEndRefreshing];
    }
    if (!self.listView.isFooterHidden) {
        [self.listView footerEndRefreshing];
    }
}

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listDataArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SpaceSmall;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SpaceSmall;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Questions *model = [_listDataArr objectAtIndex:indexPath.section];
    return model.contentHeight+model.answerSize+45;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    AskBorrowerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[AskBorrowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (IS_IOS7) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
    }
    
    
    Questions *model = [_listDataArr objectAtIndex:indexPath.section];
    [cell fillCellWithObject:model];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section+1];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 提问
- (void)askBtnClick
{
    //DLOG(@"提问按钮!!!!!!!!");
    
    if (AppDelegateInstance.userInfo == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
    }else {
        
        AskQuestionViewController *AskQuestionView = [[AskQuestionViewController alloc] init];
        AskQuestionView.bidUserIdSign =_bidUserIdSign;
        AskQuestionView.borrowId = _borrowId;
        [self.navigationController pushViewController:AskQuestionView animated:YES];
        
    }
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
