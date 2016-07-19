//
//  TableViewCellInvestManager.h
//  SP2P_6.1
//
//  Created by tusm on 16/3/30.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HeightCellInvestManager  (WidthScreen*0.135+SpaceSmall)
/**
 *  投资管理 借款管理 帐户管理 cell
 */
@interface TableViewCellInvestManager : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)UIImage *imageTip;
@property(nonatomic,strong)NSString *textTitle;
@property(nonatomic,strong)NSString *textNumber;
@end
