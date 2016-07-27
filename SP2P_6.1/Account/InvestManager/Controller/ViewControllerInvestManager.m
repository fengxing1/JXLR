//
//  ViewControllerInvestManager.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/30.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ViewControllerInvestManager.h"
#import "TableViewCellInvestManager.h"
#import "BidRecordsViewController.h"
#import "CollectionViewController.h"
#import "CompletedViewController.h"
#import "FinancialStatisticsViewController.h"
#import "FullScaleViewController.h"
@interface ViewControllerInvestManager()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *arrayItem;
@property(nonatomic,strong)NSArray *arrayItemPicture;
@end

@implementation ViewControllerInvestManager

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self initView];
}


-(void)initData{
    self.arrayItem=@[@"投资记录",@"等待满标",@"收款中",@"已完成",@"理财统计"];
    self.arrayItemPicture=@[@"menu_invest_1",@"menu_invest_2",@"menu_invest_3"
                          ,@"menu_invest_4",@"menu_invest_5"];
}
-(void)initView{
    self.title=@"投资管理";
    
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
        case 0://投标记录
        {
            BidRecordsViewController *vc=[[BidRecordsViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 1://等待满标
        {
            FullScaleViewController *vc=[[FullScaleViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 2://收款中
        {
            CollectionViewController *vc=[[CollectionViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 3://已完成
        {
            CompletedViewController *vc=[[CompletedViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 4://理财统计
        {
            FinancialStatisticsViewController *vc=[[FinancialStatisticsViewController alloc] init];
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
