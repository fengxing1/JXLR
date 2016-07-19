//
//  TableViewCellPersonItem.h
//  YiuBook
//
//  Created by tusm on 15/9/29.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SizeHeightItem (WidthScreen*0.165)
@interface TableViewCellPersonItem : UITableViewCell
+(id)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)UIImage *imageTip;
@property(nonatomic,copy)NSString *textTitle;
@property(nonatomic,copy)NSString *numberMessage;
@property(nonatomic)BOOL isLineHide;
@end
