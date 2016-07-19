//
//  DebtManagementViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
#import "DebtManagementViewController.h"
#import "ColorTools.h"
#import "TransferDebtViewController.h"
#import "AssigneeDebtViewController.h"


@interface DebtManagementViewController ()

@property (nonatomic ,strong) TransferDebtViewController *transferDebtView;
@property (nonatomic ,strong) AssigneeDebtViewController *assigneeDebtView;

@property (nonatomic ,strong) UIViewController *currentVC;

@end

@implementation DebtManagementViewController

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

}

/**
 初始化数据
 */
- (void)initView
{
    self.title = @"债权管理";

    UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transferBtn.frame = CGRectMake(0, 0, self.view.frame.size.width*0.5, HeightCheckButton);
    [transferBtn setTitle:@"受让债权管理" forState:UIControlStateNormal];
    transferBtn.titleLabel.font =  FontMediumTitle,
    [transferBtn setTitleColor:ColorNavTitle forState:UIControlStateNormal];
    [transferBtn setTitleColor:ColorWhite forState:UIControlStateSelected];
    transferBtn.selected = YES;
    transferBtn.backgroundColor=ColorCheckButtonGray;
    [transferBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateSelected];
    transferBtn.tag = 1;
    [transferBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:transferBtn];
    
    UIButton *assigneeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    assigneeBtn.frame = CGRectMake( self.view.frame.size.width*0.5, 0, self.view.frame.size.width*0.5, HeightCheckButton);
    [assigneeBtn setTitle:@"收藏的债权" forState:UIControlStateNormal];
    assigneeBtn.titleLabel.font =  FontMediumTitle,
    [assigneeBtn setTitleColor:ColorNavTitle forState:UIControlStateNormal];
    [assigneeBtn setTitleColor:ColorWhite forState:UIControlStateSelected];
    assigneeBtn.backgroundColor=ColorCheckButtonGray;
    [assigneeBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateSelected];
    assigneeBtn.tag = 2;
    [assigneeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:assigneeBtn];
    
    _transferDebtView = [[TransferDebtViewController alloc] init];
    //_CreditRatingRuleView.DebtManagementVC = self;
    _transferDebtView.view.frame = CGRectMake(0, CGRectGetMaxY(assigneeBtn.frame), self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_transferDebtView];
    
    _assigneeDebtView = [[AssigneeDebtViewController alloc] init];
    _assigneeDebtView.view.frame = CGRectMake(0, CGRectGetMaxY(assigneeBtn.frame), self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_assigneeDebtView];
    
    [self.view addSubview:_transferDebtView.view];
    //[self.view addSubview:_collectionObligationsView.view];
    
    self.currentVC =_transferDebtView;
}

//切换视图控制器
- (void)btnClick:(UIButton *)btn
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    
    if ((self.currentVC == _transferDebtView && [btn tag] == 1) || (self.currentVC == _assigneeDebtView && [btn tag] == 2)) {
        return;
    }
    switch ([btn tag]) {
        case 1:
        {
            [self replaceController:self.currentVC newController:self.transferDebtView];
        }
            break;
        case 2:
        {
            [self replaceController:self.currentVC newController:self.assigneeDebtView];
        }
            break;
    }
    
    if (btn1.selected) {
        btn1.selected = !btn1.selected;
        btn2.selected = YES;
    }
    else
    {
        btn1.selected = !btn1.selected;
        btn2.selected = NO;
    }
}


- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    
    [self addChildViewController:newController];
    
    [self transitionFromViewController:oldController toViewController:newController duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished)
     {
         if (finished) {
             
             [newController didMoveToParentViewController:self];
             
             if(oldController !=nil){
                 [oldController willMoveToParentViewController:nil];
                 [oldController removeFromParentViewController];
             }
             
             self.currentVC = newController;
             
         }else{
             self.currentVC = oldController;
         }
     }];
    
}
@end
