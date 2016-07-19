//
//  InvestmentTableViewCell.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewInvestContent.h"
@protocol InvestmentTableViewCellDelegate<NSObject>
-(void)onInvest:(Investment *)investment;
@end
@interface InvestmentTableViewCell : UITableViewCell
@property(nonatomic,assign)id<InvestmentTableViewCellDelegate> delegate;

+ (instancetype)initWithTableView:(UITableView *)tableView;
- (void)fillCellWithObject:(id)object;

@end
