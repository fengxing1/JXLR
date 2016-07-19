//
//  LoanTypeTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "LoanTypeTableViewCell.h"
#import "LoanType.h"
#define WHImageView (HeightCellLoan-SpaceMediumSmall*2)
//#define WidthImageRight 9
//#define HeightImageRight 17
#define FontDigest [UIFont systemFontOfSize:12]
#define SpaceTitleToDigest 2

@interface LoanTypeTableViewCell()

@property (nonatomic , strong) id object;

@property (nonatomic , strong) UIImageView *showImageView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UILabel *digestLabel;

//@property (nonatomic , strong) UIImageView *imageViewRight;

@end

@implementation LoanTypeTableViewCell

+(instancetype)initWithTable:(UITableView *)tableView{
    static NSString *ID=@"LoanTypeTableViewCell";
    LoanTypeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell=[[LoanTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, cell.frame.size.height)];
        imageView.image=[ImageTools imageWithColor:ColorBtnWhiteHighlight];
        cell.selectedBackgroundView=imageView;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceMediumSmall, SpaceMediumSmall, WHImageView, WHImageView)];
        _showImageView.layer.cornerRadius=2.0;
        _showImageView.layer.masksToBounds=YES;
        [self addSubview:_showImageView];
        
//        _imageViewRight=[[UIImageView alloc] initWithFrame:CGRectMake(WidthScreen-SpaceMediumBig-WidthImageRight, (HeightCellLoan-HeightImageRight)/2, WidthImageRight, HeightImageRight)];
//        [_imageViewRight setImage:[UIImage imageNamed:@"menu_arrow"]];
//        [self addSubview:_imageViewRight];
        
        float heightTitle=[SizeTools getStringHeight:@"借款" Font:FontTextContent];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_showImageView.frame)+SpaceMediumSmall, CGRectGetMinY(_showImageView.frame), WidthScreen-CGRectGetMaxX(_showImageView.frame)-SpaceMediumSmall-SpaceMediumBig, heightTitle)];
        _titleLabel.font = FontTextContent;
        _titleLabel.textColor = ColorTextContent;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _digestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _digestLabel.backgroundColor = [UIColor clearColor];
        _digestLabel.textColor = ColorTextVice;
        _digestLabel.numberOfLines = 0;
        _digestLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _digestLabel.font = FontDigest;
        [self addSubview:_digestLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.object) {
        LoanType *object = self.object;
        if (object.imageurl != nil && ![object.imageurl isEqual:[NSNull null]])
        {
            if ([[NSString stringWithFormat:@"%@",object.imageurl] hasPrefix:@"http"]) {
                [_showImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",object.imageurl]]
                  placeholderImage:[UIImage imageNamed:@"news_image_default"]];
            }else{
                [_showImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,object.imageurl]] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
            }
        }
        
        _titleLabel.text = object.name;
        
        //1:需短期流动资金用于 农林牧渔生产物资、 人工、设备等方面的&加工企业、合作社、 农场及种植养殖大户
        //2:农村公共基础建设项目有流动资金需求的& 基础建设参与者
        //3:盖房、装修、嫁娶、 购车、置办家私家电等方面有借款需求的& 农村个人
        
        NSArray *arrDigest=[object.des componentsSeparatedByString:@"&"];
        NSString *strDigest=@"";
        for(int i=0;i<arrDigest.count;i++){
            strDigest=[NSString stringWithFormat:@"%@%@",strDigest,[arrDigest[i] stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
        NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:strDigest];
        [attrStr addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[strDigest rangeOfString:strDigest]];
        if(arrDigest.count>1){
            [attrStr addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[strDigest rangeOfString:[arrDigest[1] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
        }
        _digestLabel.attributedText = attrStr;
        float heightDigest=[SizeTools getStringHeight:strDigest Font:FontDigest constrainedToSize:CGSizeMake(CGRectGetWidth(_titleLabel.frame), HeightCellLoan-CGRectGetMaxY(_titleLabel.frame)-SpaceTitleToDigest-SpaceSmall/2)];
        _digestLabel.frame=CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+SpaceTitleToDigest, CGRectGetWidth(_titleLabel.frame), heightDigest);
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
