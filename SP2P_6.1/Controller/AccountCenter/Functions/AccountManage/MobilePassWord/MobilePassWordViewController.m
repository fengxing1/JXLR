//
//  MobilePassWordViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》账户管理--》手机密码
#import "MobilePassWordViewController.h"

#import "ColorTools.h"
#import "SetNewDealPassWordViewController.h"

@interface MobilePassWordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UISwitch *switchView;
@end

@implementation MobilePassWordViewController

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
    
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"手机密码";
    [self.navigationController.navigationBar setBarTintColor:ColorWhite];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      ColorNavTitle, NSForegroundColorAttributeName,
                                                                      FontNavTitle, NSFontAttributeName, nil]];

    // 导航条返回按钮
    BarButtonItem *barButtonLeft=[BarButtonItem barItemWithTitle:@"返回" widthImage:[UIImage imageNamed:@"bar_left"] withIsImageLeft:YES target:self action:@selector(backClick)];
    [self.navigationItem setLeftBarButtonItem:barButtonLeft];
}

#pragma mark UItableview代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
  
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cellid%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                if (AppDelegateInstance.userInfo.isPayPasswordStatus) {
                    cell.textLabel.text = @"修改交易密码";
                }else {
                    cell.textLabel.text = @"设置交易密码";
                }
                
                 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"手势密码";
                _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(250, 5, 30, 30)];
                [cell  addSubview:_switchView];
                
            }
            break;

        }
   
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        SetNewDealPassWordViewController *dealPass = [[SetNewDealPassWordViewController alloc] init];
        dealPass.ispayPasswordStatus = AppDelegateInstance.userInfo.isPayPasswordStatus;
        dealPass.statuStr = @"正常设置";
        [self.navigationController pushViewController:dealPass animated:YES];
    }
}
#pragma 返回按钮触发方法
- (void)backClick
{
    // //DLOG(@"返回按钮");
    //[self.navigationController popToRootViewControllerAnimated:NO];
      [self dismissViewControllerAnimated:YES completion:^(){}];
    
}


@end
