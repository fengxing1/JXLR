//
//  BorrowDetailsCell.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  借款详情中cell
 */
@interface BorrowDetailsCell : UITableViewCell

@property (nonatomic,strong)UIImageView *HeadimgView;
@property (nonatomic,strong)UIImageView *LevelimgView;
@property (nonatomic,strong)UIButton *attentionBtn;
@property (nonatomic,strong)UIButton *CalculateBtn;
@property (nonatomic,strong)UILabel *BorrowsucceedLabel;
@property (nonatomic,strong)UILabel *BorrowfailLabel;
@property (nonatomic,strong)UILabel *repaymentnormalLabel;
@property (nonatomic,strong)UILabel *repaymentabnormalLabel;
@property (nonatomic,strong)UILabel *NameLabel;
@end
