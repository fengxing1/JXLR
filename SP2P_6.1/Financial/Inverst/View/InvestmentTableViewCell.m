//
//  InvestmentTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "InvestmentTableViewCell.h"
#import "LDProgressView.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

#import "Investment.h"

@interface InvestmentTableViewCell()
@property (nonatomic, strong) ViewInvestContent *viewInvestContent;
@property (nonatomic , strong) id object;
@end

@implementation InvestmentTableViewCell
+ (instancetype)initWithTableView:(UITableView *)tableView{
    static NSString *ID=@"InvestmentTableViewCell";
    InvestmentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell=[[InvestmentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        self.viewInvestContent=[[ViewInvestContent alloc] init];
        self.viewInvestContent.frame=CGRectMake(0, 0, WidthScreen, HeightViewInvestContent);
        self.viewInvestContent.btnContent.hidden=YES;
        [self.viewInvestContent.btnInvest addTarget:self action:@selector(onClickInvest) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.viewInvestContent];
    }
    return self;
}
-(void)onClickInvest{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(onInvest:)]){
        [self.delegate onInvest:self.object];
    }
}
- (void)fillCellWithObject:(id)object
{
    self.object = object;
    self.viewInvestContent.investment=self.object;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
