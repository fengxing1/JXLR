//
//  CreditorTransferTableViewCell.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewTransferContent.h"
@protocol CreditorTransferTableViewCellDelegate<NSObject>
-(void)onInvest:(CreditorTransfer *)createTransfer;
@end
@interface CreditorTransferTableViewCell : UITableViewCell
@property(nonatomic,assign)id<CreditorTransferTableViewCellDelegate> delegate;
/**
 *  填充cell的对象
 *
 */
- (void)fillCellWithObject:(id)object;
+ (instancetype)initWithTableView:(UITableView *)tableView;
@end
