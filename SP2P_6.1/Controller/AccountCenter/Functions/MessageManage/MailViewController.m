//
//  MailViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心---》信箱
#import "MailViewController.h"
#import "ColorTools.h"
#import "SystemMessageViewController.h"
#import "InBoxViewController.h"
#import "OutBoxViewController.h"
#import "BorrowimgQuestionsViewController.h"

@interface MailViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray *titileArr;
    NSArray  *imgNameArr;
    SystemMessageViewController *systemMessageView;
    InBoxViewController *inBoxView;
    OutBoxViewController *outBoxView;
    BorrowimgQuestionsViewController *bQuestion;
}

@property (nonatomic,strong) UITableView *TableView;
@end


@implementation MailViewController

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
    titileArr = [NSMutableArray arrayWithObjects:@"系统消息", @"收件箱",@"发件箱",@"借款提问",nil];
    imgNameArr = @[@"system_img",@"in_box_img",@"out_box_img",@"question_img"];
}

/**
 初始化数据
 */
- (void)initView
{
    self.title = @"站内信";
    //列表视图
    
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.bounces=NO;
    _TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_TableView];

    //子视图初始化
    systemMessageView = [[SystemMessageViewController alloc] init];
    inBoxView = [[InBoxViewController alloc] init];
    outBoxView = [[OutBoxViewController alloc] init];
    bQuestion = [[BorrowimgQuestionsViewController alloc] init];
}
#pragma mark - 表视图协议代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return titileArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 5.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 5.0f;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50.0f;


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellId];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, cell.frame.size.height)];
        imageView.image=[ImageTools imageWithColor:ColorBtnWhiteHighlight];
        cell.selectedBackgroundView=imageView;
    }
    cell.imageView.image = [UIImage imageNamed:[imgNameArr objectAtIndex:indexPath.section]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [titileArr objectAtIndex:indexPath.section];
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0://系统消息
        {
            [self presentViewOrPushController:systemMessageView animated:YES completion:nil];
        }
            break;
        case 1://收信箱
        {
            [self presentViewOrPushController:inBoxView animated:YES completion:nil];
        }
            break;
        case 2://发信箱
        {
            [self presentViewOrPushController:outBoxView animated:YES completion:nil];
        }
            break;
        case 3://借款提问
        {
            [self presentViewOrPushController:bQuestion animated:YES completion:nil];
        }
            break;
    }
}
@end
