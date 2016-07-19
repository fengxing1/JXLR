//
//  FinancialViewController.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/25.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "FinancialViewController.h"
#import "ColorTools.h"
#import "TransferViewController.h"
#import "InvestmentViewController.h"
#import "BarButtonItem.h"
#import "ScreenViewOneController.h"

@interface FinancialViewController ()
@property (nonatomic ,strong) InvestmentViewController *transferDebtView;
@property (nonatomic ,strong) TransferViewController *assigneeDebtView;
@property (nonatomic ,strong) UIViewController *currentVC;
@end

@implementation FinancialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navgationState=NavgationStateHide;
    [super viewWillAppear:animated];
}
- (void)initData
{
    
}
- (void)initView
{
    [self initNavigationBar];
    self.view.backgroundColor = ColorBGGray;
    
    UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transferBtn.frame = CGRectMake(0, 0, self.view.frame.size.width*0.5, HeightCheckButton);
    [transferBtn setTitle:@"我要投资" forState:UIControlStateNormal];
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
    [assigneeBtn setTitle:@"债权转让" forState:UIControlStateNormal];
    assigneeBtn.titleLabel.font =  FontMediumTitle,
    [assigneeBtn setTitleColor:ColorNavTitle forState:UIControlStateNormal];
    [assigneeBtn setTitleColor:ColorWhite forState:UIControlStateSelected];
    assigneeBtn.backgroundColor=ColorCheckButtonGray;
    [assigneeBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateSelected];
    assigneeBtn.tag = 2;
    [assigneeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:assigneeBtn];
    
    _transferDebtView = [[InvestmentViewController alloc] init];
    _transferDebtView.view.frame = CGRectMake(0, HeightCheckButton, self.view.frame.size.width, self.view.frame.size.height-HeightNavigationAndStateBar-HeightCheckButton);
    [self addChildViewController:_transferDebtView];
    
    _assigneeDebtView = [[TransferViewController alloc] init];
    _assigneeDebtView.view.frame = CGRectMake(0, HeightCheckButton, self.view.frame.size.width, self.view.frame.size.height-HeightNavigationAndStateBar-HeightCheckButton);
    [self addChildViewController:_assigneeDebtView];
    
    [self.view addSubview:_transferDebtView.view];
    
    self.currentVC =_transferDebtView;
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = NSLocalizedString(@"Tab_Financial", nil);
    BarButtonItem *rightButton = [BarButtonItem barItemWithImage:[UIImage imageNamed:@"right_menu"] selectedImage:[UIImage imageNamed:@"right_menu_press"] target:self action:@selector(leftClick)];
    [self.navigationItem setRightBarButtonItem:rightButton];// 左边导航按钮

    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:ColorNavTitle, NSForegroundColorAttributeName,FontNavTitle, NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:ColorWhite];
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
            self.navigationItem.rightBarButtonItem.customView.hidden=NO;
            [self replaceController:self.currentVC newController:self.transferDebtView];
        }
            break;
        case 2:
        {
            self.navigationItem.rightBarButtonItem.customView.hidden=YES;
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

-(void)leftClick{
    ScreenViewOneController *controller = [[ScreenViewOneController alloc] init];
    controller.leftMargin = 60;
    
    UINavigationController *rightNavigationController =  [[UINavigationController alloc] initWithRootViewController:controller];
    [self performSelector:@selector(changeRightMenuViewController:) withObject:rightNavigationController];
    [self performSelector:@selector(presentRightMenuViewController:) withObject:self];
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