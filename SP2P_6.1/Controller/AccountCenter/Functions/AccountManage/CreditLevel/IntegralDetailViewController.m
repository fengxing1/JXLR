//
//  IntegralDetailViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//积分明细
#import "IntegralDetailViewController.h"
#import "ColorTools.h"

#import "IntegralDetailAuditInformationViewController.h"
#import "NormalIntegralReimbursementDetailViewController.h"
#import "SuccessfulBorrowingIntegralDetailViewController.h"
#import "SuccessfulTenderIntegralSubsidiaryViewController.h"
#import "BillOverdueIntegralDetailViewController.h"
#import "CreditRulesViewController.h"

@interface IntegralDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
   NSArray *dataArr;

}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation IntegralDetailViewController

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
     dataArr = @[@"审核资料积分",@"正常还款积分",@"成功借款积分",@"成功投标积分",@"账单逾期积分"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-HeightNavigationAndStateBar) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"积分明细";
    
    // 导航条返回按钮
    BarButtonItem *RightItem=[BarButtonItem barItemRightDefaultWithTitle:@"查看规则"target:self action:@selector(RightItemClick)];
    [self.navigationItem setRightBarButtonItem:RightItem];
}

#pragma mark UItableview代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArr count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, cell.frame.size.height)];
        imageView.image=[ImageTools imageWithColor:ColorBtnWhiteHighlight];
        cell.selectedBackgroundView=imageView;
    }
    cell.textLabel.text = [dataArr objectAtIndex:indexPath.section];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 3.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
        
    return 2.0f;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0://审核资料积分
             {
                 IntegralDetailAuditInformationViewController *integralDetailAuditInformationView = [[IntegralDetailAuditInformationViewController alloc] init];
                 
                 [self.navigationController pushViewController:integralDetailAuditInformationView animated:YES];
             }
            break;
        case 1://正常还款积分
             {
                 NormalIntegralReimbursementDetailViewController *normalIntegralReimbursementDetailView = [[NormalIntegralReimbursementDetailViewController alloc] init];
                 
                 [self.navigationController pushViewController:normalIntegralReimbursementDetailView animated:YES];
             }
            break;
        case 2://成功借款积分
             {
                 SuccessfulBorrowingIntegralDetailViewController *successfulBorrowingIntegralDetailView = [[SuccessfulBorrowingIntegralDetailViewController alloc] init];
                 
                 [self.navigationController pushViewController:successfulBorrowingIntegralDetailView animated:YES];
             }
            break;
        case 3://成功投标积分
             {
                 SuccessfulTenderIntegralSubsidiaryViewController *successfulTenderIntegralSubsidiaryView = [[SuccessfulTenderIntegralSubsidiaryViewController alloc] init];
                 
                 [self.navigationController pushViewController:successfulTenderIntegralSubsidiaryView animated:YES];
             }
            break;
        case 4://账单逾期积分
              {
                  BillOverdueIntegralDetailViewController *billOverdueIntegralDetailView = [[BillOverdueIntegralDetailViewController alloc] init];
                  
                  [self.navigationController pushViewController:billOverdueIntegralDetailView animated:YES];
              }
            break;
    }
}
#pragma 查看规则
- (void)RightItemClick
{
    CreditRulesViewController *CreditRuleView = [[CreditRulesViewController alloc] init];
    [self.navigationController pushViewController:CreditRuleView animated:YES];
    
    
}

@end
