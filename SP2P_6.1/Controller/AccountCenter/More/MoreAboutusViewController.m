//
//  MoreAboutusViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-13.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MoreAboutusViewController.h"

#import "CompanyIntroductionViewController.h"
#import "MoreAboutUsDetailViewController.h"
#import "ZhaoXianViewController.h"
#import "ViewControllerPartner.h"
#import "ColorTools.h"

@interface MoreAboutusViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArrays;
}

@property (nonatomic , strong)  UITableView *aboutUsTableView;

@end

@implementation MoreAboutusViewController

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
 初始化数据
 */
- (void)initData
{
    _titleArrays = @[@"公司简介",@"管理团队",@"专家顾问",@"招贤纳士",@"合作伙伴"];
}

/**
 初始化数据
 */
- (void)initView
{
    self.title = @"关于我们";
    
    [self initContent];
}

/**
 * 初始化内容
 */
- (void)initContent
{
    _aboutUsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 285) style:UITableViewStyleGrouped];
    
    _aboutUsTableView.delegate = self;
    _aboutUsTableView.dataSource = self;
    _aboutUsTableView.scrollEnabled = NO;
    _aboutUsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _aboutUsTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_aboutUsTableView];
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _titleArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, cell.frame.size.height)];
        imageView.image=[ImageTools imageWithColor:ColorBtnWhiteHighlight];
        cell.selectedBackgroundView=imageView;
    }
    
    // 设置 cell 右边的箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titleArrays[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DLOG(@"name - %@", _titleArrays[indexPath.section]);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0://公司简介
        {
            CompanyIntroductionViewController *introductionView = [[CompanyIntroductionViewController alloc] init];
            [self.navigationController pushViewController:introductionView animated:YES];
        }
            
            break;
        case 1://管理团队
        {
            MoreAboutUsDetailViewController *aboutusDetail = [[MoreAboutUsDetailViewController alloc] init];
            [aboutusDetail initWithName:@"管理团队" optId:@"78"];
            
            [self.navigationController pushViewController:aboutusDetail animated:YES];
        }
            break;
        case 2://专家顾问
        {
            MoreAboutUsDetailViewController *aboutusDetail = [[MoreAboutUsDetailViewController alloc] init];
            [aboutusDetail initWithName:@"专家顾问" optId:@"79"];
            
            [self.navigationController pushViewController:aboutusDetail animated:YES];
        }
            
            break;
        case 3://招贤纳士
        {
            ZhaoXianViewController *aboutusDetail = [[ZhaoXianViewController alloc] init];
            
            [self.navigationController pushViewController:aboutusDetail animated:YES];
        }
            
            break;
        case 4://合作伙伴
        {
            ViewControllerPartner *aboutusDetail = [[ViewControllerPartner alloc] init];
            
            [self.navigationController pushViewController:aboutusDetail animated:YES];
        }
            
            break;
    }
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end