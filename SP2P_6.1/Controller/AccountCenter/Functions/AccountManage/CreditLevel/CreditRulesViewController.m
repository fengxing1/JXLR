//
//  CreditRulesViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-7.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 信用等级 -> 积分明细 -> 信用积分规则

#import "CreditRulesViewController.h"
#import "ColorTools.h"

#import "CreditRatingRuleViewController.h"
#import "CreditScoreRuleViewController.h"

@interface CreditRulesViewController ()

@property (nonatomic ,strong) UIViewController *currentVC;

@property (nonatomic ,strong) CreditRatingRuleViewController *creditRatingRuleView;
@property (nonatomic ,strong) CreditScoreRuleViewController * creditScoreRuleView;

@end

@implementation CreditRulesViewController

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
    
    
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];

    UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transferBtn.frame = CGRectMake(0, 0, self.view.frame.size.width*0.5, HeightCheckButton);
    [transferBtn setTitle:@"信用等级规则" forState:UIControlStateNormal];
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
    [assigneeBtn setTitle:@"信用积分规则" forState:UIControlStateNormal];
    assigneeBtn.titleLabel.font =  FontMediumTitle,
    [assigneeBtn setTitleColor:ColorNavTitle forState:UIControlStateNormal];
    [assigneeBtn setTitleColor:ColorWhite forState:UIControlStateSelected];
    assigneeBtn.backgroundColor=ColorCheckButtonGray;
    [assigneeBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateSelected];
    assigneeBtn.tag = 2;
    [assigneeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:assigneeBtn];
    
    _creditRatingRuleView = [[CreditRatingRuleViewController alloc] init];
    //_CreditRatingRuleView.DebtManagementVC = self;
    _creditRatingRuleView.view.frame = CGRectMake(0, CGRectGetMaxY(assigneeBtn.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(assigneeBtn.frame)-HeightNavigationAndStateBar);
    [self addChildViewController:_creditRatingRuleView];
    
    _creditScoreRuleView = [[CreditScoreRuleViewController alloc] init];
    _creditScoreRuleView.view.frame = CGRectMake(0, CGRectGetMaxY(assigneeBtn.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(assigneeBtn.frame)-HeightNavigationAndStateBar);
    [self addChildViewController:_creditScoreRuleView];
    [self.view addSubview:_creditRatingRuleView.view];
    //[self.view addSubview:_collectionObligationsView.view];
    
    self.currentVC =_creditRatingRuleView;
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"信用等级规则";
}


//切换视图控制器
- (void)btnClick:(UIButton *)btn
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    
    
    if ((self.currentVC == _creditRatingRuleView && [btn tag] == 1) || (self.currentVC == _creditScoreRuleView && [btn tag] == 2)) {
        return;
    }
    switch ([btn tag]) {
        case 1:
        {
            [self replaceController:self.currentVC newController:self.creditRatingRuleView];
        }
            break;
        case 2:
        {
            [self replaceController:self.currentVC newController:self.creditScoreRuleView];
            
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
