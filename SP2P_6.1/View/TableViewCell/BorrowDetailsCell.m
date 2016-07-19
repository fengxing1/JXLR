//
//  BorrowDetailsCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BorrowDetailsCell.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>
@implementation BorrowDetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _HeadimgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        _HeadimgView.layer.cornerRadius = 30;
        _HeadimgView.userInteractionEnabled = NO;
        _HeadimgView.layer.masksToBounds = YES;
        [self addSubview:_HeadimgView];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.frame = CGRectMake(5, 70, 60, 18);
        [_attentionBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
        [_attentionBtn setTitle:@"+加关注" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _attentionBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.0];
        [_attentionBtn.layer setMasksToBounds:YES];
        [_attentionBtn.layer setCornerRadius:3.0];
        [self addSubview:_attentionBtn];
        
        // 用户名
        _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 50, 34)];
        _NameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
        _NameLabel.numberOfLines = 0;
        _NameLabel.adjustsFontSizeToFitWidth = YES;
        _NameLabel.textColor = ColorRedMain;
        [self addSubview:_NameLabel];
        
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(80,35, 100, 30)];
        titleLabel1.text = @"借贷记录:";
        titleLabel1.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel1];
        
        _BorrowsucceedLabel = [[UILabel alloc] initWithFrame:CGRectMake(140,35, 50, 30)];
        _BorrowsucceedLabel.font = [UIFont systemFontOfSize:12.0f];
        _BorrowsucceedLabel.textColor = ColorRedMain;
        [self addSubview:_BorrowsucceedLabel];
        
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(155,35, 100, 30)];
        titleLabel2.text = @"次成功,";
        titleLabel2.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel2];
        
        _BorrowfailLabel = [[UILabel alloc] initWithFrame:CGRectMake(200,35, 200, 30)];
        _BorrowfailLabel.font = [UIFont systemFontOfSize:12.0f];
        _BorrowfailLabel.textColor = ColorRedMain;
        [self addSubview:_BorrowfailLabel];
        
        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(215,35, 100, 30)];
        titleLabel3.text = @"次流标";
        titleLabel3.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel3];
        
        
        UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(80,60, 100, 30)];
        titleLabel4.text = @"还款记录:";
        titleLabel4.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel4];
        
        _repaymentnormalLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 60, 50, 30)];
        _repaymentnormalLabel.textColor = ColorRedMain;
        _repaymentnormalLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_repaymentnormalLabel];
        
        UILabel *titleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(155,60, 100, 30)];
        titleLabel5.text = @"次正常,";
        titleLabel5.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel5];
        
        
        _repaymentabnormalLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 60, 50, 30)];
        _repaymentabnormalLabel.font = [UIFont systemFontOfSize:12.0f];
        _repaymentabnormalLabel.textColor = ColorRedMain;
        [self addSubview:_repaymentabnormalLabel];
        
        
        UILabel *titleLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(210,60, 100, 30)];
        titleLabel6.text = @"次逾期已还";
        titleLabel6.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel6];
        
        
        _LevelimgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_NameLabel.frame)+SpaceSmall, 10, 20, 20)];
        _LevelimgView.layer.cornerRadius=10.0;
        _LevelimgView.layer.masksToBounds=YES;
        [self addSubview:_LevelimgView];
        
        
        _CalculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _CalculateBtn.frame = CGRectMake(CGRectGetMaxX(_NameLabel.frame)+SpaceSmall+SpaceMediumBig*2, 5, 30, 30);
        [self addSubview:_CalculateBtn];
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end