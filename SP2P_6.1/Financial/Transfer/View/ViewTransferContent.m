//
//  ViewTransferContent.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/24.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ViewTransferContent.h"

#define HeightViewIHeader  (HeightViewTransferContent*0.26)//上部
#define HeightViewICenter (HeightViewTransferContent*0.48)//中部
#define HeightViewIBottom (HeightViewTransferContent*0.26)//下部
#define WHImageLevel (HeightViewIHeader*0.625) //等级图片的WH
#define WidthLabelTitle (WidthScreen*0.55-WHImageLevel-SpaceMediumSmall*2)//标题的宽度
#define WidthLabelTime (WidthScreen*0.45-SpaceMediumSmall*2)//时间的宽度
#define SpaceBtnBibToLeft  SpaceBig  //投标按钮到右边的距离
#define SpaceBtnBibToRightContent SpaceMediumSmall  //投标按钮到最左边内容的距离
#define SpaceContentRight SpaceMediumSmall //右边距
#define WidthBtnBid (WidthScreen*0.23)  //投标按钮的宽度
#define HeightBtnBid (HeightViewTransferContent*0.23) //投标按钮的高度
#define WidthApr ((WidthScreen-SpaceContentRight-SpaceBtnBibToRightContent-WidthBtnBid-SpaceBtnBibToLeft)*0.35) //利率和期限的宽度
#define HeightAprAndAmount (HeightViewICenter*0.7) //利率 期限 金额的高度
#define WidthAmount (((WidthScreen-SpaceContentRight-SpaceBtnBibToRightContent-WidthBtnBid-SpaceBtnBibToLeft)*0.65)) // 金额的宽度
#define HeightTextBottom (HeightViewICenter*0.5)  //中间底部小文字高度

#define FontContentSmall [UIFont systemFontOfSize:14]
@interface ViewTransferContent()
//header
@property(nonatomic,strong)UIImageView *imageViewLevel;
@property(nonatomic,strong)UILabel *labTitle;
@property(nonatomic,strong)UILabel *labTime;

//center
@property(nonatomic,strong)UILabel *labAprNum;
@property(nonatomic,strong)UILabel *labAmountNum;

//bottom
@property(nonatomic,strong)UILabel *labMinAmount;
@property(nonatomic,strong)UILabel *labCurrentBid;

@property (nonatomic)NSTimeInterval time;//相差时间
@property (nonatomic)NSTimer *scheduledTimer;
@end
@implementation ViewTransferContent

-(instancetype)init{
    self=[super init];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    //等级
    self.imageViewLevel=[[UIImageView alloc] initWithFrame:CGRectMake(SpaceMediumSmall, (HeightViewIHeader-WHImageLevel)/2, WHImageLevel, WHImageLevel)];
    self.imageViewLevel.layer.masksToBounds=YES;
    self.imageViewLevel.contentMode=UIViewContentModeScaleAspectFill;
    self.imageViewLevel.layer.cornerRadius=WHImageLevel/2.0;
    [self addSubview:self.imageViewLevel];
    
    //标题
    self.labTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageViewLevel.frame)+SpaceSmall, 0, WidthLabelTitle, HeightViewIHeader)];
    self.labTitle.font=FontTextContent;
    self.labTitle.textColor=ColorTextContent;
    [self addSubview:self.labTitle];
    
    float heightTime=[SizeTools getStringHeight:@"时间" Font:FontTextSmall];
    UILabel *labTextTime=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.labTitle.frame)+SpaceMediumSmall, HeightViewIHeader/2-heightTime, WidthLabelTime, HeightViewIHeader/2-SpaceSmall/2)];
    labTextTime.textColor=ColorTextVice;
    labTextTime.font=FontTextSmallSmall;
    labTextTime.text=@"剩余时间:";
    [self addSubview:labTextTime];
    
    self.labTime=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(labTextTime.frame), CGRectGetMaxY(labTextTime.frame), WidthLabelTime, heightTime)];
    self.labTime.textColor=ColorRedMain;
    self.labTime.font=FontTextSmallSmall;
    [self addSubview:self.labTime];
    
    UIImageView *viewLineOne=[[UIImageView alloc] initWithFrame:CGRectMake(0, HeightViewIHeader, WidthScreen, HeightLine)];
    [viewLineOne setImage:[ImageTools imageWithColor:ColorLine]];
    [self addSubview:viewLineOne];
    
    //中间内容 content
    //年化利率
    _labAprNum=[[UILabel alloc] initWithFrame:CGRectMake(SpaceContentRight, CGRectGetMaxY(viewLineOne.frame),WidthApr, HeightAprAndAmount)];
    _labAprNum.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_labAprNum];
    
    //金额
    _labAmountNum=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labAprNum.frame), CGRectGetMaxY(viewLineOne.frame),WidthAmount,  HeightAprAndAmount)];
    _labAmountNum.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_labAmountNum];
    
    UILabel *labAprText=[[UILabel alloc] initWithFrame:CGRectMake(SpaceContentRight, HeightViewIHeader+HeightViewICenter-HeightTextBottom,WidthApr,HeightTextBottom)];
    labAprText.textAlignment=NSTextAlignmentCenter;
    labAprText.text=@"年化利率";
    labAprText.font=FontTextSmall;
    labAprText.textColor=ColorTextVice;
    [self addSubview:labAprText];
    
    UILabel *labAmountText=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labAprText.frame), CGRectGetMinY(labAprText.frame),WidthAmount,HeightTextBottom)];
    labAmountText.textAlignment=NSTextAlignmentCenter;
    labAmountText.font=FontTextSmall;
    labAmountText.textColor=ColorTextVice;
    labAmountText.text=@"待收本息";
    [self addSubview:labAmountText];
    
    //投标
    _btnInvest=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnInvest.frame=CGRectMake(WidthScreen-WidthBtnBid-SpaceBtnBibToLeft, HeightViewIHeader+(HeightViewICenter-HeightBtnBid)/2, WidthBtnBid, HeightBtnBid);
    [_btnInvest.layer setCornerRadius:3.5f];
    _btnInvest.layer.masksToBounds=YES;
    [self addSubview:_btnInvest];
    
    UIImageView *viewLineTwo=[[UIImageView alloc] initWithFrame:CGRectMake(0, HeightViewIHeader+HeightViewICenter, WidthScreen, HeightLine)];
    [viewLineTwo setImage:[ImageTools imageWithColor:ColorLine]];
    [self addSubview:viewLineTwo];
    
    NSString *strMinAmount=@"拍卖底价:";
    UILabel *labTextMinAmount=[[UILabel alloc] initWithFrame:CGRectMake(SpaceMediumSmall, CGRectGetMaxY(viewLineTwo.frame), [SizeTools getStringWidth:strMinAmount Font:FontTextSmall], HeightViewIBottom)];
    labTextMinAmount.font=FontTextSmall;
    labTextMinAmount.text=strMinAmount;
    labTextMinAmount.textColor=ColorTextVice;
    [self addSubview:labTextMinAmount];
    
    self.labMinAmount=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labTextMinAmount.frame)+SpaceSmall, CGRectGetMinY(labTextMinAmount.frame), WidthScreen*0.47-CGRectGetMaxX(labTextMinAmount.frame)+SpaceSmall, HeightViewIBottom)];
    self.labMinAmount.font=FontTextSmall;
    self.labMinAmount.textColor=ColorRedMain;
    [self addSubview:self.labMinAmount];
    
    NSString *strAmount=@"目前拍价:";
    UILabel *labTextAmount=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.labMinAmount.frame)+SpaceMediumSmall, CGRectGetMaxY(viewLineTwo.frame), [SizeTools getStringWidth:strAmount Font:FontTextSmall], HeightViewIBottom)];
    labTextAmount.font=FontTextSmall;
    labTextAmount.text=strAmount;
    labTextAmount.textColor=ColorTextVice;
    [self addSubview:labTextAmount];
    
    self.labCurrentBid=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labTextAmount.frame)+SpaceSmall, CGRectGetMinY(labTextMinAmount.frame), WidthScreen-CGRectGetMaxX(labTextAmount.frame)-SpaceSmall*2, HeightViewIBottom)];
    self.labCurrentBid.font=FontTextSmall;
    self.labCurrentBid.textColor=GreenColor;
    [self addSubview:self.labCurrentBid];
}

-(void)setCreditorTransfer:(CreditorTransfer *)creditorTransfer{
    _creditorTransfer=creditorTransfer;
    if(_creditorTransfer!=nil){
        //等级
        NSArray *strArray = [_creditorTransfer.creditorImg componentsSeparatedByString:@"/"];
        NSArray *strImageName=[strArray[strArray.count-1] componentsSeparatedByString:@"."];
        if(([strImageName[0] length])>0){
            [_imageViewLevel setImage:[UIImage imageNamed:strImageName[0]]];
        }else{
            if ([[NSString stringWithFormat:@"%@",_creditorTransfer.creditorImg] hasPrefix:@"http"]) {
                [_imageViewLevel sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_creditorTransfer.creditorImg]]];
            }else{
                [_imageViewLevel sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,_creditorTransfer.creditorImg]]];
            }
        }
        _labTitle.text = _creditorTransfer.title;
        
        [self timeDown:_creditorTransfer.remainTime];
        
        //年化利率
        NSString *strApr = [NSString stringWithFormat:@"%@%%",_creditorTransfer.apr];
        int numberApr=(int)strApr.length-1;
        NSMutableAttributedString *attrStrAprNum=[[NSMutableAttributedString alloc] initWithString:strApr];
        [attrStrAprNum addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, numberApr)];
        [attrStrAprNum addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:NSMakeRange(numberApr, 1)];
        [attrStrAprNum addAttribute:NSFontAttributeName value:FontTextBigNumber range:NSMakeRange(0, numberApr)];
        [attrStrAprNum addAttribute:NSFontAttributeName value:FontContentSmall range:NSMakeRange(numberApr, 1)];
        _labAprNum.attributedText=attrStrAprNum;
        
        
        NSString *strAmount=strAmount = [NSString stringWithFormat:@"%.1f万",_creditorTransfer.principal / 10000.0];
        int numberAmount=(int)strAmount.length-1;
        NSMutableAttributedString *attrStrAmountNum=[[NSMutableAttributedString alloc] initWithString:strAmount];
        [attrStrAmountNum addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, numberAmount)];
        [attrStrAmountNum addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:NSMakeRange(numberAmount, 1)];
        [attrStrAmountNum addAttribute:NSFontAttributeName value:FontTextBigNumber range:NSMakeRange(0, numberAmount)];
        [attrStrAmountNum addAttribute:NSFontAttributeName value:FontContentSmall range:NSMakeRange(numberAmount, 1)];
        _labAmountNum.attributedText=attrStrAmountNum;
        
        NSString *strMinAmount=[NSString stringWithFormat:@"%0.1f元", _creditorTransfer.minPrincipal];
        int numberMinAmount=(int)strMinAmount.length-1;
        NSMutableAttributedString *attrStrMinAmountNum=[[NSMutableAttributedString alloc] initWithString:strMinAmount];
        [attrStrMinAmountNum addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, numberMinAmount)];
        [attrStrMinAmountNum addAttribute:NSForegroundColorAttributeName value:ColorTextVice range:NSMakeRange(numberMinAmount, 1)];
        _labMinAmount.attributedText=attrStrMinAmountNum;
        
        NSString *strCurrentBid=[NSString stringWithFormat:@"%0.1f元", _creditorTransfer.currentPrincipal];
        int numberCurrentBid=(int)strCurrentBid.length-1;
        NSMutableAttributedString *attrStrCurrentBid=[[NSMutableAttributedString alloc] initWithString:strCurrentBid];
        [attrStrCurrentBid addAttribute:NSForegroundColorAttributeName value:GreenColor range:NSMakeRange(0, numberCurrentBid)];
        [attrStrCurrentBid addAttribute:NSForegroundColorAttributeName value:ColorTextVice range:NSMakeRange(numberCurrentBid, 1)];
        _labCurrentBid.attributedText =  attrStrCurrentBid;
    }
}

-(void)onOverDue{
    [_btnInvest setBackgroundImage:[ImageTools imageWithColor:ColorBigContentText] forState:UIControlStateNormal];
    [_btnInvest setTitle:@"已完成" forState:UIControlStateNormal];
    _btnInvest.userInteractionEnabled=NO;
}
-(void)onNotOverDue{
    [_btnInvest setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:1.0] forState:UIControlStateNormal];
    [_btnInvest setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:0.6] forState:UIControlStateHighlighted];
    [_btnInvest setTitle:@"竞拍" forState:UIControlStateNormal];
    _btnInvest.userInteractionEnabled=YES;
}
#pragma mark 倒计时
- (void)timeDown:(int )repaytime
{
    //剩余时间
    _time=repaytime;
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0)
    {
        _labTime.text =@"已过期";
        [self onOverDue];
    }
    else
    {
        if ([_scheduledTimer isValid] == YES) {
            [_scheduledTimer invalidate];
            _scheduledTimer = nil;
        }
        _scheduledTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        _labTime.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
        [self onNotOverDue];
    }
}

//剩余时间倒计时(每秒钟调用一次)
- (void)timerFireMethod
{
    _time--;
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0)
    {
        _labTime.text =@"已过期";
        [self onOverDue];
    }
    else
    {
        _labTime.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
        [self onNotOverDue];
    }
}
@end
