//
//  TableViewCellPersonItem.m
//  YiuBook
//
//  Created by tusm on 15/9/29.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import "TableViewCellPersonItem.h"
#import "ButtonBadge.h"
#define SpaceLineToLR SpaceBig
#define SizeWHImage  30
#define SizeWidthBadge 19
#define MarginLR  (SizeHeightItem/2-SizeWHImage/2)
#define WidthMore 8
#define HeightMore 16

@interface TableViewCellPersonItem()
@property(nonatomic,strong)UIImageView *imageViewTip;
@property(nonatomic,strong)UILabel *labTitle;
@property(nonatomic,strong)UIImageView *viewLineBottom;
@property(nonatomic,strong)ButtonBadge *btnBadge;
@end

@implementation TableViewCellPersonItem

+(id)cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"TableViewCellPersonItem";
    TableViewCellPersonItem *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell=[[TableViewCellPersonItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, cell.frame.size.height)];
        imageView.image=[ImageTools imageWithColor:ColorBtnWhiteHighlight];
        cell.selectedBackgroundView=imageView;
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _isLineHide=NO;
        [self setup];
    }
    return self;
}
-(void)setup{
    self.imageViewTip=[[UIImageView alloc] initWithFrame:CGRectMake(SpaceLineToLR+SpaceSmall, MarginLR, SizeWHImage, SizeWHImage)];
    [self.contentView addSubview:self.imageViewTip];
    
    UIImageView *imageViewTo=[[UIImageView alloc]initWithFrame:CGRectMake(WidthScreen-SpaceSmall-WidthMore-SpaceLineToLR, (SizeHeightItem-HeightMore)/2, WidthMore, HeightMore)];
    [imageViewTo setImage:[UIImage imageNamed:@"bar_right_press"]];
    [self.contentView addSubview:imageViewTo];
    
    self.btnBadge=[[ButtonBadge alloc] init];
    self.btnBadge.frame=CGRectMake(CGRectGetMinX(imageViewTo.frame)-SpaceMediumSmall-SizeWidthBadge, SizeHeightItem/2-SizeWidthBadge/2, SizeWidthBadge, SizeWidthBadge);
    self.btnBadge.buttonTypeAligm=ButtonTypeAligmCenter;
    self.btnBadge.strBadge=@"";
    [self.contentView addSubview:self.btnBadge];
    
    self.labTitle=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageViewTip.frame)+MarginLR, 0,WidthScreen-CGRectGetMaxX(self.imageViewTip.frame)*2+MarginLR*2, SizeHeightItem)];
    self.labTitle.font=FontTextContent;
    self.labTitle.textAlignment=NSTextAlignmentLeft;
    self.labTitle.textColor=ColorNavTitle;
    self.labTitle.text=_textTitle;
    [self.contentView addSubview:self.labTitle];

    self.viewLineBottom=[[UIImageView alloc]initWithFrame:CGRectMake(SpaceBig, SizeHeightItem-HeightLine, WidthScreen-SpaceBig*2, HeightLine)];
    self.viewLineBottom.image=[ImageTools imageWithColor:ColorLine];
    [self.contentView addSubview:self.viewLineBottom];
}
-(void)setImageTip:(UIImage *)imageTip{
    _imageTip=imageTip;
    [self.imageViewTip setImage:imageTip];
}
-(void)setTextTitle:(NSString *)textTitle{
    _textTitle=textTitle;
    self.labTitle.text=_textTitle;
}
-(void)setNumberMessage:(NSString *)numberMessage{
    _numberMessage=numberMessage;
    
    self.btnBadge.strBadge=_numberMessage;
}
-(void)setIsLineHide:(BOOL)isLineHide{
    _isLineHide=isLineHide;
    
    if(_isLineHide){
        self.viewLineBottom.hidden=YES;
    }else{
        self.viewLineBottom.hidden=NO;
    }
}
@end
