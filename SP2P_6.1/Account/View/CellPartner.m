//
//  CellPartner.m
//  SP2P_6.1
//
//  Created by 邹显 on 16/5/6.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "CellPartner.h"
@interface CellPartner()
@property(nonatomic,strong)UIImageView *imageViewTip;
@end
@implementation CellPartner
+(id)cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"CellPartner";
    CellPartner *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell=[[CellPartner alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, cell.frame.size.height)];
        imageView.image=[ImageTools imageWithColor:ColorBtnWhiteHighlight];
        cell.selectedBackgroundView=imageView;
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}
-(void)setup{
    _imageViewTip=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightImageViewCell)];
    [self.contentView addSubview:_imageViewTip];
}
-(void)setImageTip:(UIImage *)imageTip{
    _imageTip=imageTip;
    [self.imageViewTip setImage:imageTip];
}
@end
