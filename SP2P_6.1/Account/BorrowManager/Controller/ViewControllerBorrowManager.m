//
//  ViewControllerBorrowManager.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/30.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ViewControllerBorrowManager.h"
#import "TableViewCellInvestManager.h"
#import "PaymentViewController.h"
#import "AuditingViewController.h"
#import "LiteratureAuditViewController.h"
#import "SuccessfullyViewController.h"
#import "TenderViewController.h"
@interface ViewControllerBorrowManager()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *arrayItem;
@property(nonatomic,strong)NSArray *arrayItemPicture;
@end

@implementation ViewControllerBorrowManager

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

-(void)initData{
    self.arrayItem=@[@"审核中",@"招标中",@"还款中",@"已还款",@"资料审核"];
    self.arrayItemPicture=@[@"menu_borrow_1",@"menu_borrow_2",
                            @"menu_borrow_3"
                            ,@"menu_borrow_4",@"menu_borrow_5"];
}
-(void)initView{
    self.title=@"借款管理";
    
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
        case 0://审核中
        {
            AuditingViewController *vc=[[AuditingViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 1://招标中
        {
            TenderViewController *vc=[[TenderViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 2://还款中
        {
            PaymentViewController *vc=[[PaymentViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 3://已还款
        {
            SuccessfullyViewController *vc=[[SuccessfullyViewController alloc] init];
            [self presentViewOrPushController:vc animated:YES completion:nil];
        }
            break;
        case 4://资料审核
        {
            LiteratureAuditViewController *vc=[[LiteratureAuditViewController alloc] init];
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