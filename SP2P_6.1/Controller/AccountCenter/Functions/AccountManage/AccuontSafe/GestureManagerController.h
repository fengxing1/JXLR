//
//  GestureManagerController.h
//  SP2P_6.1
//
//  Created by Jaqen on 16/7/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ViewControllerBasicNotNetwork.h"

@interface GestureManagerController : ViewControllerBasicNotNetwork<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end
