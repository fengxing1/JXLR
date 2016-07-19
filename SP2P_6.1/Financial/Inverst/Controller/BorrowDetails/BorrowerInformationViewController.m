//
//  BorrowerInformationViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-3.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  我要投资 -> 借款人信息
#import "BorrowerInformationViewController.h"
#import "ColorTools.h"
#import "TenderOnceViewController.h"
#import "AccountItem.h"
#import "AccountInfo.h"
#define INT_TO_STRING(x)  [NSString stringWithFormat:@"%d", x]
#import "NetWorkConfig.h"

@interface BorrowerInformationViewController ()<HTTPClientDelegate>
{
    NSArray *infoArr;

}
@property (nonatomic ,strong) NSMutableArray *dataArr;


@property (nonatomic, strong) AccountInfo *accountInfo;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation BorrowerInformationViewController

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
    _dataArr  = [[NSMutableArray alloc] init];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //借款人详情接口
    [parameters setObject:@"3" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowerID] forKey:@"id"];
    
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i<[infoArr count]; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SpaceMediumBig+35*i, 100, 30)];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = [infoArr objectAtIndex:i];
        [self.view addSubview:titleLabel];
        
    }
    
    if (AppDelegateInstance.userInfo != nil && _paceNum < 100) {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
    UIButton *tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tenderBtn.frame = CGRectMake(SpaceBig, SpaceSmall,WidthScreen-SpaceBig*2, 44-SpaceSmall*2);
    tenderBtn.backgroundColor = GreenColor;
    [tenderBtn setTitle:@"立即投标" forState:UIControlStateNormal];
    [tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [tenderBtn.layer setMasksToBounds:YES];
    [tenderBtn.layer setCornerRadius:3.0];
    [tenderBtn addTarget:self action:@selector(tenderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tenderBtn];
    }
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"借款人信息";
    
    BarButtonItem *shareItem=[BarButtonItem barItemWithTitle:@"分享" widthImage:[UIImage imageNamed:@"bar_right"] selectedImage:[UIImage imageNamed:@"bar_right_press"] withIsImageLeft:NO target:self action:@selector(ShareClick)];
    [self.navigationItem setRightBarButtonItem:shareItem];
}



// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    //DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if([dics objectForKey:@"realName"]!= nil &&![[dics objectForKey:@"realName"]isEqual:[NSNull null]] )
        {
            NSString *realName = [NSString stringWithFormat:@"真实姓名: %@***",[[dics objectForKey:@"realName"] substringWithRange:NSMakeRange(0, 1)]];
            //        NSString *realName = [NSString stringWithFormat:@"真实姓名: %@",[dics objectForKey:@"realName"]];
            [_dataArr addObject:realName];
        }

        NSString *sex = [NSString stringWithFormat:@"性别: %@",[dics objectForKey:@"sex"]] ;
        [_dataArr addObject:sex];
        

        NSString *year = [NSString stringWithFormat:@"年龄: %@",[dics objectForKey:@"age"]];
        [_dataArr addObject:year];
        
        // 截取局部 用 * 代替
        if([dics objectForKey:@"idNo"]!= nil &&![[dics objectForKey:@"idNo"]isEqual:[NSNull null]] )
        {
            NSMutableString *idNo = [NSMutableString stringWithFormat:@"身份证号: %@",[dics objectForKey:@"idNo"]];
            [idNo replaceCharactersInRange:NSMakeRange(12, 8) withString:@"********"];
            //        NSString *idNo = [NSString stringWithFormat:@"身份证号: %@",[dics objectForKey:@"idNo"]];
            [_dataArr addObject:idNo];
        }
        

        NSInteger registedPlaceProId = [[dics objectForKey:@"registedPlacePro"] intValue] ;
        NSInteger registedPlaceCityId = [[dics objectForKey:@"registedPlaceCity"] intValue] ;
        NSInteger higtestEduId = [[dics objectForKey:@"higtestEdu"] intValue] ;
        NSInteger maritalStatusId = [[dics objectForKey:@"maritalStatus"] intValue] ;
        NSInteger housrseStatusId = [[dics objectForKey:@"housrseStatus"] intValue] ;
        NSInteger CarStatusId = [[dics objectForKey:@"CarStatus"] intValue] ;
        
        
        //    infoArr = @[@"真实姓名:",@"性别:",@"年龄:",@"身份证号:",@"户口所在地:",@"文化程度:",@"婚姻情况:",@"购房情况:",@"购车情况:"];
        NSArray *provinceArr = [dics objectForKey:@"provinceList"];
        if (provinceArr.count)
        {
            for ( NSDictionary *item  in provinceArr) {
                if ([[item objectForKey:@"id"] intValue] == registedPlaceProId ) {
                    
                    NSString *registedPlacePro = [NSString stringWithFormat:@"户口所在省份: %@",[item objectForKey:@"name"]];
                    [_dataArr addObject:registedPlacePro];
                    //DLOG(@"fdufhdfhsdfds %@",[item objectForKey:@"name"]);
                }
            }
        }
        NSArray *cityArr = [dics objectForKey:@"cityList"];
        if (cityArr.count) {
            for ( NSDictionary *item  in cityArr) {
                if ([[item objectForKey:@"id"] intValue] == registedPlaceCityId ) {
                    
                    NSString *registedPlaceCity = [NSString stringWithFormat:@"户口所在地: %@",[item objectForKey:@"name"]];
                    [_dataArr addObject:registedPlaceCity];
                    //DLOG(@"registedPlaceCity  %@",[item objectForKey:@"name"]);
                }
            }
        }
        
        NSArray *educationsArr = [dics objectForKey:@"educationsList"];
        if (educationsArr.count)
        {
            for (NSDictionary *item in educationsArr) {
                if ([[item objectForKey:@"id"] intValue] == higtestEduId ) {
                    
                    NSString *higtestEdu = [NSString stringWithFormat:@"最高学历: %@",[item objectForKey:@"name"]];
                    [_dataArr addObject:higtestEdu];
                    //DLOG(@"higtestEdu is  %@",[item objectForKey:@"name"]);
                }
            }
        }
        
        NSArray *maritalsArr = [dics objectForKey:@"maritalsList"];
        for (NSDictionary *item in maritalsArr) {
            
            if ([[item objectForKey:@"id"] intValue] == maritalStatusId ) {
                
                NSString *maritalStatus = [NSString stringWithFormat:@"婚姻情况: %@",[item objectForKey:@"name"]];
                [_dataArr addObject:maritalStatus];
                //DLOG(@"maritalStatus is  %@",[item objectForKey:@"name"]);
            }
        }
        
        
        NSArray *housesArr = [dics objectForKey:@"housesList"];
        for (NSDictionary *item in housesArr) {
            if ([[item objectForKey:@"id"] intValue] == housrseStatusId ) {
                
                 NSString *housrseStatus =  [NSString stringWithFormat:@"购房情况: %@",[item objectForKey:@"name"]];
                [_dataArr addObject:housrseStatus];
                //DLOG(@"housrseStatus is  %@",[item objectForKey:@"name"]);
            }
        }
        
        

        NSArray *carArr = [dics objectForKey:@"carList"];
        for (NSDictionary *item in carArr) {
            if ([[item objectForKey:@"id"] intValue] == CarStatusId ) {
                
                NSString *CarStatus = [NSString stringWithFormat:@"购车情况: %@",[item objectForKey:@"name"]];
                [_dataArr addObject:CarStatus];
                //DLOG(@"CarStatus is  %@",[item objectForKey:@"name"]);
            }
        }

        for (int i = 0; i<[_dataArr count]; i++) {
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SpaceMediumBig+35*i, 250, 30)];
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.text = [_dataArr objectAtIndex:i];
            [self.view addSubview:titleLabel];
            
        }
    }
    else{
        
        //DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
         [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
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
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
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


#pragma  分享按钮
- (void)ShareClick
{
    //DLOG(@"分享按钮");
    
    if (AppDelegateInstance.userInfo == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
    }else {
        //DLOG(@"分享按钮");
        
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
        
        NSString *shareUrl = [NSString stringWithFormat:@"%@", Baseurl];
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来融金服 我要投资 借款详情%@",shareUrl]
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"logo"]]
                                                    title:@"借款详情"
                                                      url:shareUrl
                                              description:@"这是一条测试信息"
                                                mediaType:SSPublishContentMediaTypeNews];
        
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
        
        TenderOnceViewController *TenderOnceView = [[TenderOnceViewController alloc] init];
        TenderOnceView.borrowId = _borrowId;
        [self.navigationController pushViewController:TenderOnceView animated:YES];
        
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
