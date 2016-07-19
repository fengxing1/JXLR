//
//  MyCollectionViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》账户管理--》我的收藏

#import "MyCollectionViewController.h"
#import "MyCollectionObligationsViewController.h"
#import "MyCollectionBorrowsViewController.h"

#import "ColorTools.h"

@interface MyCollectionViewController ()

@property (nonatomic ,strong) UIViewController *currentVC;

@property (nonatomic ,strong) MyCollectionBorrowsViewController *collectionBorrowsView;
@property (nonatomic ,strong) MyCollectionObligationsViewController *collectionObligationsView;

@end

@implementation MyCollectionViewController

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
    self.title = @"我的收藏";

    UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transferBtn.frame = CGRectMake(0, 0, self.view.frame.size.width*0.5, HeightCheckButton);
    [transferBtn setTitle:@"收藏的借款" forState:UIControlStateNormal];
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
    
    
    _collectionBorrowsView = [[MyCollectionBorrowsViewController alloc] init];
    //_CreditRatingRuleView.DebtManagementVC = self;
    _collectionBorrowsView.view.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_collectionBorrowsView];
    
    _collectionObligationsView = [[MyCollectionObligationsViewController alloc] init];
    _collectionObligationsView.view.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_collectionObligationsView];
    
    [self.view addSubview:_collectionBorrowsView.view];
    self.currentVC =_collectionBorrowsView;
}

//切换视图控制器
- (void)btnClick:(UIButton *)btn
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    
    if ((self.currentVC == _collectionBorrowsView && [btn tag] == 1) || (self.currentVC == _collectionObligationsView && [btn tag] == 2)) {
        return;
    }
    switch ([btn tag]) {
        case 1:
        {
            [self replaceController:self.currentVC newController:self.collectionBorrowsView];
        }
            break;
        case 2:
        {
            [self replaceController:self.currentVC newController:self.collectionObligationsView];
            
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

-(void)back{
    _collectionBorrowsView.tableView.editing = UITableViewCellEditingStyleNone;
    _collectionObligationsView.tableView.editing = UITableViewCellEditingStyleNone;
    [super back];
}

@end
