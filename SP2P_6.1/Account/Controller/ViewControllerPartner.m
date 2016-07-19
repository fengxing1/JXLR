//
//  ViewControllerPartner.m
//  SP2P_6.1
//
//  Created by 邹显 on 16/5/6.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ViewControllerPartner.h"
#import "CellPartner.h"
#define PartnerNumber  8

@interface ViewControllerPartner ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong)  UITableView *aboutUsTableView;

@end

@implementation ViewControllerPartner

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
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initView
{
    self.title = @"合作伙伴";
    
    [self initContent];
}

/**
 * 初始化内容
 */
- (void)initContent
{
    _aboutUsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightScreen) style:UITableViewStyleGrouped];
    _aboutUsTableView.delegate = self;
    _aboutUsTableView.dataSource = self;
    _aboutUsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _aboutUsTableView.backgroundColor=[UIColor clearColor];
    _aboutUsTableView.contentInset=UIEdgeInsetsMake(0, 0, HeightNavigationAndStateBar+SpaceBig, 0);
    [self.view addSubview:_aboutUsTableView];
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return PartnerNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightImageViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellPartner *cell = [CellPartner cellWithTableView:tableView];
    cell.imageTip=[UIImage imageNamed:[NSString stringWithFormat:@"partner%ld",(long)indexPath.section]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

