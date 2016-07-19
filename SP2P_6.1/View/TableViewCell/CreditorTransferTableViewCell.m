//
//  CreditorTransferTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CreditorTransferTableViewCell.h"
#import "CreditorTransfer.h"
#import "ColorTools.h"

@interface CreditorTransferTableViewCell ()

@property (nonatomic, strong) id object;
@property (nonatomic, strong) ViewTransferContent *viewTransferContent;
@end

@implementation CreditorTransferTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView{
    static NSString *ID=@"CreditorTransferTableViewCell";
    CreditorTransferTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell=[[CreditorTransferTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor=[UIColor whiteColor];
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
        self.viewTransferContent=[[ViewTransferContent alloc] init];
        self.viewTransferContent.frame=CGRectMake(0, 0, WidthScreen, HeightViewTransferContent);
        [self.viewTransferContent.btnInvest addTarget:self action:@selector(onClickInvest) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.viewTransferContent];
    }
    return self;
}

-(void)onClickInvest{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(onInvest:)]){
        [self.delegate onInvest:self.viewTransferContent.creditorTransfer];
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
    self.viewTransferContent.creditorTransfer=self.object;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
