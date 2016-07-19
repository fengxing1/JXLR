//
//  CellPartner.h
//  SP2P_6.1
//
//  Created by 邹显 on 16/5/6.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HeightImageViewCell  (WidthScreen*0.4)
@interface CellPartner : UITableViewCell
+(id)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)UIImage *imageTip;
@end
