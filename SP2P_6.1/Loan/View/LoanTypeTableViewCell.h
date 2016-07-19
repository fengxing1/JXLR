//
//  LoanTypeTableViewCell.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HeightCellLoan  (WidthScreen*0.25)
@interface LoanTypeTableViewCell : UITableViewCell
/**
 *  填充cell的对象
 *
 */

- (void)fillCellWithObject:(id)object;

+(instancetype)initWithTable:(UITableView *)tableView;
@end
