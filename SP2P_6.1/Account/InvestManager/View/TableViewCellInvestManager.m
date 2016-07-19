//
//  TableViewCellInvestManager.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/30.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "TableViewCellInvestManager.h"
#import "ButtonBadge.h"
#define SizeWHImage  23
#define SizeWidthBadge 19
#define WidthMore 8
#define HeightMore 16
@interface TableViewCellInvestManager()
@property(nonatomic,strong)UIImageView *imageViewTip;
@property(nonatomic,strong)UILabel *labelTitle;
@property(nonatomic,strong)ButtonBadge *btnBadge;
@property(nonatomic,strong)UIImageView *imageViewMore;
@end
@implementation TableViewCellInvestManager
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"TableViewCellInvestManager";
    TableViewCellInvestManager *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell=[[TableViewCellInvestManager alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, cell.frame.size.height)];
        imageView.image=[ImageTools imageWithColor:ColorBtnWhiteHighlight];
        cell.selectedBackgroundView=imageView;
    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.backgroundColor=ColorWhite;
    float heightCell=HeightCellInvestManager-SpaceSmall;
    self.imageViewTip=[[UIImageView alloc] initWithFrame:CGRectMake(SpaceMediumSmall, (heightCell-SizeWHImage)/2, SizeWHImage, SizeWHImage)];
    [self.contentView addSubview:self.imageViewTip];
    
    UIImageView *imageViewTo=[[UIImageView alloc]initWithFrame:CGRectMake(WidthScreen-SpaceBig-WidthMore, (heightCell-HeightMore)/2, WidthMore, HeightMore)];
    [imageViewTo setImage:[UIImage imageNamed:@"bar_right_press"]];
    [self.contentView addSubview:imageViewTo];
    
    self.btnBadge=[[ButtonBadge alloc] init];
    self.btnBadge.frame=CGRectMake(CGRectGetMinX(imageViewTo.frame)-SpaceMediumSmall-SizeWidthBadge, (heightCell-SizeWidthBadge)/2, SizeWidthBadge, SizeWidthBadge);
    self.btnBadge.buttonTypeAligm=ButtonTypeAligmCenter;
    self.btnBadge.strBadge=@"";
    [self.contentView addSubview:self.btnBadge];
    
    self.labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageViewTip.frame)+SpaceMediumSmall, 0,CGRectGetMinX(self.btnBadge.frame)-CGRectGetMaxX(self.imageViewTip.frame)-SpaceMediumSmall*2, heightCell)];
    self.labelTitle.font=FontMedium;
    self.labelTitle.textAlignment=NSTextAlignmentLeft;
    self.labelTitle.textColor=ColorNavTitle;
    self.labelTitle.text=_textTitle;
    [self.contentView addSubview:self.labelTitle];
}
-(void)setFrame:(CGRect)frame{
    frame.size.height-=SpaceSmall;
    [super setFrame:frame];
}
-(void)setImageTip:(UIImage *)imageTip{
    _imageTip=imageTip;
    [self.imageViewTip setImage:imageTip];
}
-(void)setTextTitle:(NSString *)textTitle{
    _textTitle=textTitle;
    self.labelTitle.text=_textTitle;
}
-(void)setTextNumber:(NSString *)textNumber{
    _textNumber=textNumber;
    
    self.btnBadge.strBadge=_textNumber;
}
@end
