//
//  ViewControllerAccountManager.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/30.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ViewControllerAccountManager.h"
#import "TableViewCellInvestManager.h"
#import "AccountInfoViewController.h"
#import "AccuontSafeViewController.h"
#import "CreditLevelViewController.h"
#import "MyCollectionViewController.h"

@interface ViewControllerAccountManager()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *arrayItem;
@property(nonatomic,strong)NSArray *arrayItemPicture;
@end

@implementation ViewControllerAccountManager

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

-(void)initData{
    self.arrayItem=@[@"帐户信息",@"信用等级",@"帐户安全",@"我的收藏"];
    self.arrayItemPicture=@[@"menu_account_1",@"menu_account_2",
                            @"menu_account_3"
                            ,@"menu_account_4"];
}
-(void)initView{
    self.title=@"帐户管理";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCellInvestManager *cell=[TableViewCellInvestManager cellWithTableView:tableView];
    cell.imageTip=[UIImage imageNamed:self.arrayItemPicture[indexPath.row]];
    cell.textTitle=self.arrayItem[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0://帐户信息
        {
            AccountInfoViewController *vc=[[AccountInfoViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 1://信用等级
        {
            CreditLevelViewController *vc=[[CreditLevelViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 2://帐户安全
        {
            AccuontSafeViewController *vc=[[AccuontSafeViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 3://我的收藏
        {
            MyCollectionViewController *vc=[[MyCollectionViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HeightCellInvestManager;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SpaceSmall;
}
@end