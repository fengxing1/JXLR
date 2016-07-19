//
//  TabViewController.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "TabViewController.h"

#import "HomeViewController.h"
#import "InvestmentViewController.h"
#import "FinancialViewController.h"
#import "LoanViewController.h"
#import "TransferViewController.h"
#import "BarButtonItem.h"
#import "ViewControllerAccount.h"
#import "JXLRLoginViewController.h"

@interface TabViewController ()
@property (nonatomic,strong)UIImageView *tabBarView;
@property (nonatomic,assign)BOOL isFromeAccount;
@property (nonatomic,assign)NSUInteger selectIndex;
@end

@implementation TabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.hidden = NO;
    _selectIndex=0;
    _isFromeAccount=NO;
    
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    
    FinancialViewController *financialVC = [[FinancialViewController alloc] init];
    
    LoanViewController *loanVc = [[LoanViewController alloc] init];
    
    ViewControllerAccount *accountVC = [[ViewControllerAccount alloc] init];
    
    UINavigationController *homeNV= [[UINavigationController alloc] initWithRootViewController:homeVc];
    UINavigationController *financialNV = [[UINavigationController alloc] initWithRootViewController:financialVC];
    UINavigationController *loanVN= [[UINavigationController alloc] initWithRootViewController:loanVc];
    UINavigationController *accountVN = [[UINavigationController alloc] initWithRootViewController:accountVC];
    
    [self initNavigationBar:homeNV];
    [self initNavigationBar:financialNV];
    [self initNavigationBar:loanVN];
    [self initNavigationBar:accountVN];
    
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    [controllers addObject:homeNV];
    [controllers addObject:financialNV];
    [controllers addObject:loanVN];
    [controllers addObject:accountVN];
    
    self.tabBar.tintColor = ColorRedMain;
    self.viewControllers = controllers;
    self.selectedIndex = 0;
    UIView *viewBG=[[UIView alloc] initWithFrame:self.tabBar.bounds];
    viewBG.backgroundColor=[UIColor whiteColor];
    [self.tabBar insertSubview:viewBG atIndex:0];
    self.tabBar.opaque=YES;
    
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:3];
    tabBarItem3.tag=3;
    
    tabBarItem0.title = NSLocalizedString(@"Tab_Home", nil);
    tabBarItem1.title = NSLocalizedString(@"Tab_Financial", nil);
    tabBarItem2.title = NSLocalizedString(@"Tab_Loan", nil);
    tabBarItem3.title = NSLocalizedString(@"tab_Me", nil);
    
    [tabBarItem0 setImage:[UIImage imageNamed:@"tab_home"]];
    [tabBarItem1 setImage:[UIImage imageNamed:@"tab_financial"]];
    [tabBarItem2 setImage:[UIImage imageNamed:@"tab_loan"]];
    [tabBarItem3 setImage:[UIImage imageNamed:@"tab_me"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectedIndex=_selectIndex;
    if(![self checkUserIsNil]&&_isFromeAccount){
        self.selectedIndex=3;
    }else if([self checkUserIsNil]&&self.selectedIndex==3){
        self.selectedIndex=0;
    }
}
-(BOOL)checkUserIsNil{
    if(AppDelegateInstance.userInfo==nil){
        return YES;
    }else if(AppDelegateInstance.userInfo.userName==nil){
        return YES;
    }
    return NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _selectIndex=self.selectedIndex;
}
- (void)initNavigationBar:(UINavigationController *)navigationController
{
    [navigationController.navigationBar setBarTintColor:ColorWhite];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    _selectIndex=self.selectedIndex;
    if(item.tag==3&&[self checkUserIsNil]){
        JXLRLoginViewController *VC = [[JXLRLoginViewController alloc] init];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:VC];
        //Jaqen-start:登陆跳转方式
        
        [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        //Jaqen-end
        
        [self presentViewController:nav animated:YES completion:nil];
        _isFromeAccount=YES;
        self.selectedIndex=_selectIndex;
    }else{
        _isFromeAccount=NO;
    }
}
@end
