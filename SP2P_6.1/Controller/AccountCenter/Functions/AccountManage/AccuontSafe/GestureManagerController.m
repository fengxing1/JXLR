//
//  GestureManagerController.m
//  SP2P_6.1
//
//  Created by Jaqen on 16/7/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "GestureManagerController.h"
#import "CLLockVC.h"

@implementation GestureManagerController

-(void)viewDidLoad{
    [self initData];
    [self initView];
}

#pragma mark 初始化数据和视图
-(void)initData{
    if ([[AppDefaultUtil sharedInstance] getGesturesPasswordStatus]) {
        _dataArr = [NSMutableArray arrayWithObjects:@"启用手势密码",@"修改手势密码", nil];
    }else{
        _dataArr = [NSMutableArray arrayWithObjects:@"启用手势密码", nil];
    }
}

-(void)initView{
    self.title = @"手势密码";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark tableView datasource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [_dataArr count];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4.0f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 4.0f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    cell.textLabel.text = [_dataArr objectAtIndex:indexPath.section];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.5f];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    switch (indexPath.section) {
        case 0:
        {
            UIControl *switchView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 40, 21)];
            if ([[AppDefaultUtil sharedInstance] getGesturesPasswordStatus]) {
                switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ON"]];
            }else{
                switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OFF"]];
            }
            [switchView addTarget:self action:@selector(useGesturePwd:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.accessoryView = switchView;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
            [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                //隐藏所有模态视图控制器
                UIViewController *rootVC = lockVC;
                while (rootVC.presentingViewController) {
                    rootVC = rootVC.presentingViewController;
                }
                [rootVC dismissViewControllerAnimated:YES completion:nil];
            }];
        }
            break;
        default:
            break;
    }
}


#pragma mark 是否启用手势密码开关
-(void)useGesturePwd:(id)sender{
    if ([[AppDefaultUtil sharedInstance] getGesturesPasswordStatus]) {
        
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            //忘记密码
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            //密码正确
            
            [[AppDefaultUtil sharedInstance] setGesturesPasswordStatusWithFlag:NO];
            [_dataArr removeObject:@"修改手势密码"];
            
            [_tableView reloadData];
            
            //隐藏所有模态视图控制器
            UIViewController *rootVC = lockVC;
            while (rootVC.presentingViewController) {
                rootVC = rootVC.presentingViewController;
            }
            [rootVC dismissViewControllerAnimated:YES completion:nil];
        }];

    }else{
        
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            NSLog(@"密码设置成功");
            
            //设置启用手势密码
            [[AppDefaultUtil sharedInstance] setGesturesPasswordStatusWithFlag:YES];
            [_dataArr addObject:@"修改手势密码"];
            [_tableView reloadData];
            
            //隐藏所有模态视图控制器
            UIViewController *rootVC = lockVC;
            while (rootVC.presentingViewController) {
                rootVC = rootVC.presentingViewController;
            }
            [rootVC dismissViewControllerAnimated:YES completion:nil];
            
            [_dataArr addObject:@"修改手势密码"];
        }];
        
    }
}

@end
