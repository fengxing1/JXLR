//
//  ViewControllerAccount.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/27.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ViewControllerAccount.h"
#import "CreditLevelViewController.h"
#import "MyRechargeViewController.h"
#import "WithdrawalViewController.h"
#import "JXLRLoginViewController.h"
#import "ChangeIconViewController.h"
#import "TwoCodeViewController.h"
#import "ControlImageTitle.h"
#import "TableViewCellPersonItem.h"
#import "ToolAlertMessage.h"
#import "PaymentViewController.h"
#import "ViewControllerInvestManager.h"
#import "ViewControllerBorrowManager.h"
#import "DebtManagementViewController.h"
#import "FundRecordViewController.h"
#import "MailViewController.h"
#import "ViewControllerAccountManager.h"
#import "BankCardManageViewController.h"
#import "ChangeIconViewController.h"
#import "MoreViewController.h"
#import "TwoCodeViewController.h"
#define strTextCumulative @"累计收益:"
#define HeightContentHeader (WidthScreen*0.40)//不包括StateBar
#define HeightContentCenter (WidthScreen*0.22)//中间数据界面
#define HeightContentNumber (WidthScreen*0.25)//底部三个按钮容器高度
#define HeightHeaderTable (HeightContentHeader+HeightContentCenter+HeightStateBar)
#define WHHeader 65
#define FontNameAndAumu FontTextContent
#define FontUserName [UIFont boldSystemFontOfSize:16]
#define FontAccount FontTextContent
#define HeightTextNameAndAumu [SizeTools getStringHeight:@"Name" Font:FontNameAndAumu]
#define HeightTextAccount [SizeTools getStringHeight:@"Name" Font:FontAccount]
#define WHImageLevel  20
#define WidthCenterButton (WidthScreen*0.4/3)

#define ColorReturn [ColorTools colorWithHexString:@"#fbcb5a"]
#define ColorTopup  [ColorTools colorWithHexString:@"#fb4e53"]
#define ColorWitdrawal [ColorTools colorWithHexString:@"#78c550"]
#define WidthBtnNotLogin 110
#define HeightBtnNotLogin  35
#define WHCodeAndSetting 19 //二维码和设置按钮WH

@interface ViewControllerAccount ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
//帐户
@property(nonatomic,strong)UIButton *btnCode;//二维码
@property(nonatomic,strong)UIButton *btnSetting;//设置
@property(nonatomic,strong)UserInfo *userInfo;
@property(nonatomic,strong)UIView *viewTableHeader;//顶部的View
@property(nonatomic,strong)UIView *viewOnLogin;//登录情况的View
@property(nonatomic,strong)UIView *viewOnNotLogin;//未登录情况的View
@property(nonatomic,strong)UIButton *btnNotLoginHeader; //未登录状态的头像
@property(nonatomic,strong)UIButton *btnNotLoginLogin;//点击登录按钮
@property(nonatomic,strong)UIButton *btnNotLoginRegister;//点击注册
@property(nonatomic,strong)UIImageView *imageViewBG;//背景图片
@property(nonatomic,strong)UIButton *btnHeader;//头像
@property(nonatomic,strong)UILabel *labUserName;//用户名
@property(nonatomic,strong)UIImageView *imageViewLevel;//用户等级
@property(nonatomic,strong)UILabel *labTextCumulativeEarn;//累计收益
/**
 *  累计收益
 */
@property(nonatomic,strong)UILabel *labCumulativeEarn;
/**
 *  总额
 */
@property(nonatomic,strong)UILabel *labSumAccount;
/**
 *  余额
 */
@property(nonatomic,strong)UILabel *labBalance;
/**
 *  冻结
 */
@property(nonatomic,strong)UILabel *labFreezeAccount;
/**
 *  待收
 */
@property(nonatomic,strong)UILabel *labWaitAccount;
@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,strong)ControlImageTitle *controlReturn;
@property(nonatomic,strong)ControlImageTitle *controlTopup;
@property(nonatomic,strong)ControlImageTitle *controlWithdrawal;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *arrayPicture;
@property(nonatomic,strong)NSArray *arrayTitle;
@end
@implementation ViewControllerAccount

- (void)viewDidLoad
{
    [super viewDidLoad];
    //通知检测对象
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(update) name:Update object:nil];
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestData) name:@"rechargeUpdate" object:nil];
    [self initData];//初始化数据
    
    [self initView];//初始化视图
    
    if (AppDelegateInstance.userInfo != nil) {
        [self update];
    }else{
        [self onNotLogin];
    }
}

#pragma mark 导航栏动画消失或显示
//Jaqen-start:导航栏消失随动画

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//Jaqen-end;

/**
 * 初始化数据
 */
- (void)initData
{
     self.arrayPicture=@[@"item_invest",@"item_borrow",@"item_transfer",
                     @"item_money",@"Item_message",@"Item_account",@"Item_card"];
     self.arrayTitle=@[@"投资管理",@"借款管理",@"债权管理",
                       @"资金流水",@"站内信息",@"帐户管理",@"我的银行卡"];
    self.userInfo=[[UserInfo alloc] init];
}

/**
 初始化视图
 */
- (void)initView
{
    _viewTableHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen,HeightHeaderTable)];
    _viewTableHeader.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_viewTableHeader];
    
    _imageViewBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightContentHeader+HeightContentCenter+HeightStateBar)];
    _imageViewBG.image=[UIImage imageNamed:@"accountbg"];
    [_viewTableHeader addSubview:_imageViewBG];
    
//    _btnCode=[UIButton buttonWithType:UIButtonTypeCustom];
//    _btnCode.frame=CGRectMake(SpaceMediumSmall, HeightStateBar+SpaceSmall, WHCodeAndSetting+SpaceMediumSmall, WHCodeAndSetting+SpaceMediumSmall);
//    [_btnCode setImage:[UIImage imageNamed:@"code"] forState:UIControlStateNormal];
//    [_btnCode setImage:[UIImage imageNamed:@"code_press"] forState:UIControlStateHighlighted];
//    [_btnCode addTarget:self action:@selector(clickCode) forControlEvents:UIControlEventTouchUpInside];
//    [_btnCode setContentEdgeInsets:UIEdgeInsetsMake(SpaceSmall, SpaceSmall, SpaceSmall, SpaceSmall)];
//    [_viewTableHeader addSubview:_btnCode];
    
    _btnSetting=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnSetting.frame=CGRectMake(WidthScreen-WHCodeAndSetting-SpaceMediumSmall*2, HeightStateBar+SpaceSmall, WHCodeAndSetting+SpaceMediumSmall, WHCodeAndSetting+SpaceMediumSmall);
    [_btnSetting setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [_btnSetting setImage:[UIImage imageNamed:@"setting_press"] forState:UIControlStateHighlighted];
    [_btnSetting addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
    [_btnSetting setContentEdgeInsets:UIEdgeInsetsMake(SpaceSmall, SpaceSmall, SpaceSmall, SpaceSmall)];
    [_viewTableHeader addSubview:_btnSetting];
    
    //未登录界面
    _viewOnNotLogin=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnSetting.frame), WidthScreen, HeightContentHeader+HeightContentCenter+HeightStateBar-CGRectGetMaxY(_btnSetting.frame))];
    _viewOnNotLogin.backgroundColor=[UIColor clearColor];
    [_viewTableHeader addSubview:_viewOnNotLogin];
    
    _btnNotLoginHeader=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnNotLoginHeader.frame=CGRectMake((WidthScreen-WHHeader)/2, SpaceSmall, WHHeader, WHHeader);
    [_btnNotLoginHeader setImage:[UIImage imageNamed:@"header"] forState:UIControlStateNormal];
    _btnNotLoginHeader.layer.cornerRadius=WHHeader/2;
    _btnNotLoginHeader.layer.masksToBounds=YES;
    [_viewOnNotLogin addSubview:_btnNotLoginHeader];
    
    _btnNotLoginLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnNotLoginLogin.frame=CGRectMake((WidthScreen-WidthBtnNotLogin)/2,CGRectGetMaxY(_btnNotLoginHeader.frame)+SpaceMediumBig, WidthBtnNotLogin, HeightBtnNotLogin);
    _btnNotLoginLogin.layer.borderColor=ColorWhite.CGColor;
    _btnNotLoginLogin.layer.borderWidth=HeightLine;
    _btnNotLoginLogin.layer.cornerRadius=4.0;
    _btnNotLoginLogin.layer.masksToBounds=YES;
    [_btnNotLoginLogin setTitle:@"点击登录" forState:UIControlStateNormal];
    [_btnNotLoginLogin setTitleColor:ColorWhite forState:UIControlStateNormal];
    [_btnNotLoginLogin setBackgroundImage:[ImageTools imageWithColor:ColorWhite withAlpha:0.1] forState:UIControlStateNormal];
    [_btnNotLoginLogin setBackgroundImage:[ImageTools imageWithColor:ColorWhite withAlpha:0.3] forState:UIControlStateHighlighted];
    _btnNotLoginLogin.titleLabel.font=FontTextContent;
    [_btnNotLoginLogin addTarget:self action:@selector(ClickLogin) forControlEvents:UIControlEventTouchUpInside];
    [_viewOnNotLogin addSubview:_btnNotLoginLogin];
    
    _btnNotLoginRegister=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnNotLoginRegister.frame=CGRectMake((WidthScreen-WidthBtnNotLogin)/2,CGRectGetMaxY(_btnNotLoginLogin.frame)+SpaceSmall, WidthBtnNotLogin, HeightBtnNotLogin);
    [_btnNotLoginRegister setTitle:@"新用户注册" forState:UIControlStateNormal];
    [_btnNotLoginRegister setTitleColor:ColorWhite forState:UIControlStateNormal];
    [_btnNotLoginLogin setTitleColor:ColorBGGray forState:UIControlStateHighlighted];
    [_btnNotLoginLogin setBackgroundColor:[UIColor clearColor]];
    _btnNotLoginRegister.titleLabel.font=FontTextContent;
    [_btnNotLoginRegister addTarget:self action:@selector(ClickRegister) forControlEvents:UIControlEventTouchUpInside];
    [_viewOnNotLogin addSubview:_btnNotLoginRegister];
    
    
    //已登录界面
    _viewOnLogin=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnSetting.frame), WidthScreen, HeightContentHeader+HeightContentCenter+HeightStateBar-CGRectGetMaxY(_btnSetting.frame))];
    _viewOnLogin.backgroundColor=[UIColor clearColor];
    [_viewTableHeader addSubview:_viewOnLogin];
    
    _btnHeader=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnHeader.frame=CGRectMake(SpaceBig+SpaceSmall, SpaceSmall, WHHeader, WHHeader);
    _btnHeader.layer.cornerRadius=WHHeader/2;
    _btnHeader.layer.masksToBounds=YES;
    [_btnHeader addTarget:self action:@selector(changeHeader) forControlEvents:UIControlEventTouchUpInside];
    [_viewOnLogin addSubview:_btnHeader];
    
//    NSString *strTextUserName=@"尊敬的:";
//    float widthTextUserName=[SizeTools getStringWidth:strTextUserName Font:FontNameAndAumu];
//    _labTextUserName=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnHeader.frame)+SpaceMediumBig, CGRectGetMinY(_btnHeader.frame)+WHHeader/2-SpaceSmall-HeightTextNameAndAumu, widthTextUserName, HeightTextNameAndAumu)];
//    _labTextUserName.text=strTextUserName;
//    _labTextUserName.textColor=ColorWhite;
//    _labTextUserName.font=FontNameAndAumu;
//    [_viewOnLogin addSubview:_labTextUserName];
    
    _labUserName=[[UILabel alloc] init];
    _labUserName.textColor=ColorWhite;
    _labUserName.font=FontUserName;
    [_viewOnLogin addSubview:_labUserName];
    
    _imageViewLevel=[[UIImageView alloc] init];
    [_viewOnLogin addSubview:_imageViewLevel];
    
    _labTextCumulativeEarn=[[UILabel alloc] init];
    _labTextCumulativeEarn.text=strTextCumulative;
    _labTextCumulativeEarn.textColor=ColorWhite;
    _labTextCumulativeEarn.font=FontNameAndAumu;
    [_viewOnLogin addSubview:_labTextCumulativeEarn];
    
    _labCumulativeEarn=[[UILabel alloc] init];
    _labCumulativeEarn.textColor=ColorWhite;
    _labCumulativeEarn.font=FontNameAndAumu;
    [_viewOnLogin addSubview:_labCumulativeEarn];
    
    UIView *viewLineOne=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_viewOnLogin.frame)-HeightContentCenter,WidthScreen, HeightLine)];
    viewLineOne.backgroundColor=ColorLine;
    [_viewOnLogin addSubview:viewLineOne];
    
    UIView *viewLineTwo=[[UIView alloc] initWithFrame:CGRectMake(WidthScreen/2-HeightLine/2, CGRectGetMaxY(viewLineOne.frame), HeightLine, HeightContentCenter-HeightLine)];
    viewLineTwo.backgroundColor=ColorLine;
    [_viewOnLogin addSubview:viewLineTwo];
    
    float heightAccount=HeightTextAccount;
    float widthAccount=CGRectGetMinX(viewLineTwo.frame)-SpaceMediumBig*2;
    _labSumAccount=[self createLabel:@"总额:" withFrame:CGRectMake(SpaceMediumBig, CGRectGetMaxY(viewLineOne.frame)+SpaceMediumSmall, widthAccount, heightAccount)];
    
    _labFreezeAccount=[self createLabel:@"冻结:" withFrame:CGRectMake(SpaceMediumBig, CGRectGetMaxY(_labSumAccount.frame)+SpaceMediumSmall,widthAccount, heightAccount)];
    
    _labBalance=[self createLabel:@"余额:" withFrame:CGRectMake(CGRectGetMaxX(viewLineTwo.frame)+SpaceMediumBig, CGRectGetMinY(_labSumAccount.frame), widthAccount, heightAccount)];
    
    _labWaitAccount=[self createLabel:@"待收:" withFrame:CGRectMake(CGRectGetMaxX(viewLineTwo.frame)+SpaceMediumBig, CGRectGetMinY(_labFreezeAccount.frame), widthAccount, heightAccount)];
    
    UIView *viewBottom=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageViewBG.frame), WidthScreen, HeightContentNumber)];
    viewBottom.backgroundColor=ColorWhite;
    //[_viewTableHeader addSubview:viewBottom];
    
    float spaceButton=(WidthScreen-WidthCenterButton*3)/6;
    _controlReturn=[[ControlImageTitle alloc] initWithFrame:CGRectMake(spaceButton, SpaceMediumSmall, WidthCenterButton, WidthCenterButton) withTitle:@"还款" withImage:[UIImage imageNamed:@"return"] withColor:ColorReturn addTarget:self action:@selector(returnClick)];
    [viewBottom addSubview:_controlReturn];
    
    _controlTopup=[[ControlImageTitle alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_controlReturn.frame)+spaceButton*2, CGRectGetMinY(_controlReturn.frame), WidthCenterButton, WidthCenterButton) withTitle:@"充值" withImage:[UIImage imageNamed:@"topup"] withColor:ColorTopup addTarget:self action:@selector(rechargeClick)];
    [viewBottom addSubview:_controlTopup];
    
    _controlWithdrawal=[[ControlImageTitle alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_controlTopup.frame)+spaceButton*2, CGRectGetMinY(_controlReturn.frame), WidthCenterButton, WidthCenterButton) withTitle:@"提现" withImage:[UIImage imageNamed:@"withdrawal"] withColor:ColorWitdrawal addTarget:self action:@selector(withdrawClick)];
    [viewBottom addSubview:_controlWithdrawal];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewTableHeader.frame), WidthScreen, HeightScreen-CGRectGetMaxY(_viewTableHeader.frame)) style:UITableViewStyleGrouped];
    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, HeightTabBar, 0)];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, HeightTabBar, 0)];
    _tableView.contentSize=CGSizeMake(WidthScreen, CGRectGetHeight(self.view.frame));
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView=viewBottom;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces=NO;
    [self.view addSubview:_tableView];
}
/**
 *  创建一个Label （冻结、总额、余额、待收）
 *
 *  @param accountTitle <#accountTitle description#>
 *  @param frame        <#frame description#>
 *
 *  @return <#return value description#>
 */
-(UILabel *)createLabel:(NSString *)accountTitle withFrame:(CGRect)frame{
    float widthText=[SizeTools getStringWidth:accountTitle Font:FontAccount];
    UILabel *labText=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame),CGRectGetMinY(frame), widthText, CGRectGetHeight(frame))];
    labText.text=accountTitle;
    labText.textColor=ColorWhite;
    labText.font=FontAccount;
    [_viewOnLogin addSubview:labText];
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame)+widthText+SpaceSmall, CGRectGetMinY(frame), CGRectGetWidth(frame)-widthText-SpaceSmall, CGRectGetHeight(frame))];
    lab.textColor=ColorWhite;
    lab.font=FontAccount;
    lab.text=@"¥0.00";
    [_viewOnLogin addSubview:lab];
    return lab;
}

/**
 *  通知中心触发方法
 */
-(void)update
{
    _userInfo.userName = AppDelegateInstance.userInfo.userName;
    _userInfo.userImg = AppDelegateInstance.userInfo.userImg;
    _userInfo.userCreditRating= AppDelegateInstance.userInfo.userCreditRating;
    _userInfo.accountAmount = [NSString stringWithFormat:@"%@", AppDelegateInstance.userInfo.accountAmount];
    _userInfo.availableBalance = [NSString stringWithFormat:@"%@", AppDelegateInstance.userInfo.availableBalance];
    _userInfo.freeze = [NSString stringWithFormat:@"%@", AppDelegateInstance.userInfo.freeze];
    _userInfo.totalIncome = [NSString stringWithFormat:@"%@", AppDelegateInstance.userInfo.totalIncome];
    _userInfo.receivingAmount = [NSString stringWithFormat:@"%@", AppDelegateInstance.userInfo.receivingAmount];
    [self refreshAccountView];
}

/**
 *  根据UserInfo更新帐户信息
 */
-(void)refreshAccountView{
    _isLogin = [AppDelegateInstance.userInfo.isLogin boolValue];
    if(_isLogin){
        [self onLogin];
        
        [_btnHeader sd_setBackgroundImageWithURL:[NSURL URLWithString:_userInfo.userImg]forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"header"]];
        
        float widthUserName=[SizeTools getStringWidth:_userInfo.userName Font:FontUserName];
        _labUserName.frame=CGRectMake(CGRectGetMaxX(_btnHeader.frame)+SpaceMediumBig, CGRectGetMinY(_btnHeader.frame)+WHHeader/2-SpaceSmall-HeightTextNameAndAumu, widthUserName, HeightTextNameAndAumu);
        _labUserName.text=_userInfo.userName;
        
        _imageViewLevel.frame=CGRectMake(CGRectGetMaxX(_labUserName.frame)+SpaceSmall, CGRectGetMinY(_labUserName.frame)-SpaceSmall/2, WHImageLevel, WHImageLevel);
        [_imageViewLevel sd_setImageWithURL:[NSURL URLWithString:_userInfo.userCreditRating]];
        
        float widthTextCumulative=[SizeTools getStringWidth:strTextCumulative Font:FontNameAndAumu];
        _labTextCumulativeEarn.frame=CGRectMake(CGRectGetMinX(_labUserName.frame), CGRectGetMaxY(_labUserName.frame)+SpaceMediumSmall, widthTextCumulative, HeightTextNameAndAumu);
        
        NSString *cumulative=[NSString stringWithFormat:@"¥%@",_userInfo.totalIncome];
        float widthCumulative=[SizeTools getStringWidth:cumulative Font:FontNameAndAumu];
        _labCumulativeEarn.frame=CGRectMake(CGRectGetMaxX(_labTextCumulativeEarn.frame)+SpaceSmall, CGRectGetMinY(_labTextCumulativeEarn.frame), widthCumulative, HeightTextNameAndAumu);
        _labCumulativeEarn.text=cumulative;
       
        _labSumAccount.text=[NSString stringWithFormat:@"¥%@",_userInfo.accountAmount];
        
        self.labBalance.text=[NSString stringWithFormat:@"¥%@",_userInfo.availableBalance];
        
        self.labFreezeAccount.text=[NSString stringWithFormat:@"¥%@",_userInfo.freeze];
        
        self.labWaitAccount.text=[NSString stringWithFormat:@"¥%@",_userInfo.receivingAmount];
    }else{
        [self onNotLogin];
    }
}
/**
 *  点击二维码
 */
-(void)clickCode{
    if(AppDelegateInstance.userInfo!=nil){
        TwoCodeViewController *vc=[[TwoCodeViewController alloc] init];
        [self presentViewOrPushController:vc animated:YES completion:nil withNewNavgation:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }
}
/**
 *  点击设置
 */
-(void)clickSetting{
    MoreViewController *vc=[[MoreViewController alloc] init];
    [self presentViewOrPushController:vc animated:YES completion:nil withNewNavgation:YES];
}
/**
 *  已登录
 */
-(void)onLogin{
    _viewOnNotLogin.hidden=YES;
    _viewOnLogin.hidden=NO;
}
/**
 *  未登录
 */
-(void)onNotLogin{
    _viewOnNotLogin.hidden=NO;
    _viewOnLogin.hidden=YES;
}
/**
 *  点击登录
 */
-(void)ClickLogin{
    JXLRLoginViewController *VC = [[JXLRLoginViewController alloc] init];
    [self presentViewOrPushController:VC animated:YES completion:nil withNewNavgation:YES];
}
/**
 *  注册
 */
-(void)ClickRegister{
    
}
/**
 *  更改头像
 */
-(void)changeHeader{
    ChangeIconViewController *VC = [[ChangeIconViewController alloc] init];
    [self presentViewOrPushController:VC animated:YES completion:nil withNewNavgation:YES];
}
#pragma mark - 信用额度
- (void)creditRatingClick {
    CreditLevelViewController *CreditLevelView = [[CreditLevelViewController alloc] init];
    UINavigationController *NaVController22 = [[UINavigationController alloc] initWithRootViewController:CreditLevelView];
    [self presentViewController:NaVController22 animated:YES completion:nil];
}
/**
 *  还款
 */
-(void)returnClick{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }else{
        PaymentViewController *payVC=[[PaymentViewController alloc] init];
        [self presentViewOrPushController:payVC animated:YES completion:nil withNewNavgation:YES];
    }
}
/**
 *  充值
 */
- (void)rechargeClick {
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }else{
        MyRechargeViewController *RechargeView = [[MyRechargeViewController alloc] init];
        [self presentViewOrPushController:RechargeView animated:YES completion:nil withNewNavgation:YES];
    }
}

/**
 *  提现
 */
- (void)withdrawClick {
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }else{
        WithdrawalViewController *WithdrawalView = [[WithdrawalViewController alloc] init];
        [self presentViewOrPushController:WithdrawalView animated:YES completion:nil   withNewNavgation:YES];
    }
}
/**
 *  头像点击事件
 *
 *  @param sender <#sender description#>
 */
- (void)login:(id)sender
{
    if(_isLogin)
    {
        ChangeIconViewController *calculatorVC = [[ChangeIconViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:calculatorVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }else {
        [self ClickLogin];
    }
}

- (void)requestData {
    if (AppDelegateInstance.userInfo == nil) {
        [ToolAlertMessage ShowAlertMessage:@"请登陆"];
    }else {
        NSString *name = [[AppDefaultUtil sharedInstance] getDefaultAccount];
        NSString *password = [[AppDefaultUtil sharedInstance] getDefaultUserNoPassword];
        [self.netWorkRM requestLoginWithAccount:name withPassword:password withDeviceType:@"2"];
    }
}
#pragma mark TableDelegate DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayTitle.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCellPersonItem *cell=[TableViewCellPersonItem cellWithTableView:tableView];
    cell.imageTip=[UIImage imageNamed:self.arrayPicture[indexPath.row]];
    cell.textTitle=self.arrayTitle[indexPath.row];
    if(indexPath.row==(self.arrayPicture.count-1))
        cell.isLineHide=YES;
    else
        cell.isLineHide=NO;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }else{
        switch (indexPath.row) {
            case 0://投资管理
            {
                ViewControllerInvestManager *vc=[[ViewControllerInvestManager alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                //[self presentViewOrPushController:vc animated:YES completion:nil withNewNavgation:YES];
            }
                break;
            case 1://借款管理
            {
                ViewControllerBorrowManager *vc=[[ViewControllerBorrowManager alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                //[self presentViewOrPushController:vc animated:YES completion:nil withNewNavgation:YES];
            }
                break;
            case 2://债权管理
            {
                DebtManagementViewController *vc=[[DebtManagementViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                //[self presentViewOrPushController:vc animated:YES completion:nil withNewNavgation:YES];
            }
                break;
            case 3://资金流水
            {
                FundRecordViewController *vc=[[FundRecordViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                //[self presentViewOrPushController:vc animated:YES completion:nil withNewNavgation:YES];
            }
                break;
            case 4://站内信息
            {
                MailViewController *vc=[[MailViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                //[self presentViewOrPushController:vc animated:YES completion:nil withNewNavgation:YES];
                break;
            }
            case 5://帐户管理
            {
                ViewControllerAccountManager *vc=[[ViewControllerAccountManager alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                //[self presentViewOrPushController:vc animated:YES completion:nil withNewNavgation:YES];
                break;
            }
            case 6://我的银行卡
            {
                BankCardManageViewController *vc=[[BankCardManageViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                //[self presentViewOrPushController:vc animated:YES completion:nil withNewNavgation:YES];
            }
                break;
            default:
                break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SpaceBig;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeightItem;
}
#pragma mark NetWork
-(void)startRequestLogin{
    
}

-(void)responseSuccessLogin:(UserInfo *)userInfo withMessage:(NSString *)message{
    if(userInfo!=nil){
        if (_isRefresh) {
            [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
            _isRefresh = NO;
        }
        
        AppDelegateInstance.userInfo = userInfo;
        // 通知全局广播 LeftMenuController 修改UI操作
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"update" object:userInfo.userName];
    }else{
        [SVProgressHUD showErrorWithStatus:message];
    }
}
@end

