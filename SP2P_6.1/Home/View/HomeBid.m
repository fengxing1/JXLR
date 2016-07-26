//
//  HomeBid.m
//  SP2P_6.1
//
//  Created by Jaqen on 16/7/25.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "HomeBid.h"
#import "ViewBidHot.h"
#import "HKPieChartView.h"

#define HeightViewIHeader  (HeightViewInvestContent*0.10)//上部
#define HeightViewICenter (HeightViewInvestContent*0.75)//中部
#define HeightViewIBottom (HeightViewInvestContent*0.15)//下部
#define SpaceContent SpaceMediumSmall //右边距
#define SpaceBtnBib  SpaceBig  //投标按钮到右边的距离
#define WidthBtnBid (WidthScreen-SpaceBtnBib*2)  //投标按钮的宽度
#define HeightBtnBid (HeightViewIBottom-SpaceSmall*2) //投标按钮的高度
#define WidthAprAndPeriod ((WidthScreen-SpaceContent*2)*0.3) //利率和期限的宽度
#define WidthAmount ((WidthScreen-SpaceContent*2)*0.4) // 金额的宽度

#define HeightPieChart (HeightViewICenter*0.82) //环形进度条的高度
#define HeightAprAndPeriodAndAmount (HeightViewICenter*0.12) //利率 期限 金额的高度
#define HeightTextBottom (HeightViewICenter*0.06)  //年化、借款、期限的文字高度

#define FontContentSmall [UIFont systemFontOfSize:14]
@interface HomeBid()
@property(nonatomic,strong)UIImageView *imageViewLevel;
@property(nonatomic,strong)UILabel *labTitle;
@property(nonatomic,strong)ViewBidHot *viewBidHot;
@property(nonatomic,strong)UILabel *labAprNum;
@property(nonatomic,strong)UILabel *labAmountNum;
@property(nonatomic,strong)UILabel *labPeriod;
@property(nonatomic,strong)HKPieChartView *pieChartView;

@end
@implementation HomeBid

-(instancetype)init{
    self=[super init];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.btnContent = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnContent.frame = CGRectMake(0, 0, WidthScreen, HeightViewInvestContent);
    [self addSubview:self.btnContent];
    
    //等级
    float heightImageLevel=(HeightViewIHeader*0.625);
    self.imageViewLevel=[[UIImageView alloc] initWithFrame:CGRectMake(SpaceMediumSmall, (HeightViewIHeader-heightImageLevel)/2, heightImageLevel, heightImageLevel)];
    self.imageViewLevel.layer.masksToBounds=YES;
    self.imageViewLevel.contentMode=UIViewContentModeScaleAspectFill;
    self.imageViewLevel.layer.cornerRadius=heightImageLevel/2.0;
    [self addSubview:self.imageViewLevel];
    
    //标题
    self.labTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageViewLevel.frame)+SpaceSmall, 0, WidthScreen-CGRectGetMaxX(self.imageViewLevel.frame)-SpaceSmall-SpaceBig-HeightViewIHeader, HeightViewIHeader)];
    self.labTitle.font=FontTextContent;
    self.labTitle.textColor=ColorTextContent;
    [self addSubview:self.labTitle];
    
    //火标
    _viewBidHot=[[ViewBidHot alloc] initWithFrame:CGRectMake(WidthScreen-HeightViewIHeader, 0, HeightViewIHeader, HeightViewIHeader)];
    [self addSubview:_viewBidHot];
    
    UIImageView *viewLineOne=[[UIImageView alloc] initWithFrame:CGRectMake(0, HeightViewIHeader, WidthScreen, HeightLine)];
    [viewLineOne setImage:[ImageTools imageWithColor:ColorLine]];
    [self addSubview:viewLineOne];
    
    //投标进度
    _pieChartView = [[HKPieChartView alloc] initWithFrame:CGRectMake((WidthScreen-HeightViewICenter)/2, CGRectGetMaxY(viewLineOne.frame),HeightViewICenter, HeightViewICenter*0.82)];
        [self addSubview:_pieChartView];
    _pieChartView.userInteractionEnabled = NO;
    
    //年化利率
    _labAprNum=[[UILabel alloc] initWithFrame:CGRectMake(SpaceContent, CGRectGetMaxY(_pieChartView.frame),WidthAprAndPeriod, HeightAprAndPeriodAndAmount)];
    _labAprNum.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_labAprNum];
    
    //金额
    _labAmountNum=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labAprNum.frame), CGRectGetMinY(_labAprNum.frame),WidthAmount,  HeightAprAndPeriodAndAmount)];
    _labAmountNum.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_labAmountNum];
    
    //期限
    _labPeriod=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labAmountNum.frame), CGRectGetMinY(_labAprNum.frame),WidthAprAndPeriod,  HeightAprAndPeriodAndAmount)];
    _labPeriod.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_labPeriod];
    
    UILabel *labAprText=[[UILabel alloc] initWithFrame:CGRectMake(SpaceContent, CGRectGetMaxY(_labAprNum.frame),WidthAprAndPeriod,HeightTextBottom)];
    labAprText.textAlignment=NSTextAlignmentCenter;
    labAprText.text=@"年化利率";
    labAprText.font=FontTextSmall;
    labAprText.textColor=ColorTextVice;
    [self addSubview:labAprText];
    
    UILabel *labAmountText=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labAprText.frame), CGRectGetMinY(labAprText.frame),WidthAmount,HeightTextBottom)];
    labAmountText.textAlignment=NSTextAlignmentCenter;
    labAmountText.font=FontTextSmall;
    labAmountText.textColor=ColorTextVice;
    labAmountText.text=@"借款金额";
    [self addSubview:labAmountText];
    
    UILabel *labPeriodText=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labAmountText.frame), CGRectGetMinY(labAprText.frame),WidthAprAndPeriod,HeightTextBottom)];
    labPeriodText.textAlignment=NSTextAlignmentCenter;
    labPeriodText.font=FontTextSmall;
    labPeriodText.textColor=ColorTextVice;
    labPeriodText.text=@"借款期限";
    [self addSubview:labPeriodText];
    
    
    //投标
    _btnInvest=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnInvest.frame=CGRectMake(SpaceBtnBib, HeightViewIHeader+HeightViewICenter+SpaceSmall, WidthBtnBid, HeightBtnBid);
    [_btnInvest.layer setCornerRadius:3.5f];
    _btnInvest.layer.masksToBounds=YES;
    [self addSubview:_btnInvest];
    
}

-(void)initContentBackground{
    [_btnContent setBackgroundImage:[ImageTools imageWithColor:ColorWhite] forState:UIControlStateNormal];
    [_btnContent setBackgroundImage:[ImageTools imageWithColor:ColorBtnWhiteHighlight] forState:UIControlStateHighlighted];
}

-(void)setInvestment:(Investment *)investment{
    _investment=investment;
    if(_investment!=nil){
        //等级
        NSArray *strArray = [_investment.levelStr componentsSeparatedByString:@"/"];
        NSArray *strImageName=[strArray[strArray.count-1] componentsSeparatedByString:@"."];
        if(([strImageName[0] length])>0){
            [_imageViewLevel setImage:[UIImage imageNamed:strImageName[0]]];
        }else{
            if ([[NSString stringWithFormat:@"%@",_investment.levelStr] hasPrefix:@"http"]) {
                
                [_imageViewLevel sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_investment.levelStr]]];
            }else{
                
                [_imageViewLevel sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,_investment.levelStr]]];
            }
        }
        //火标
        if (_investment.isQuality)
        {
            _viewBidHot.hidden=NO;
        }else{
            _viewBidHot.hidden=YES;
        }
        
        //标题
        _labTitle.text = _investment.title;
        
        //刷新进度条
        [_pieChartView updatePercent:_investment.progress animation:YES];
        
        //年化利率
        NSString *strApr = [NSString stringWithFormat:@"%0.1f%%",_investment.rate];
        int numberApr=(int)strApr.length-1;
        NSMutableAttributedString *attrStrAprNum=[[NSMutableAttributedString alloc] initWithString:strApr];
        [attrStrAprNum addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, numberApr)];
        [attrStrAprNum addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:NSMakeRange(numberApr, 1)];
        [attrStrAprNum addAttribute:NSFontAttributeName value:FontTextBigNumber range:NSMakeRange(0, numberApr)];
        [attrStrAprNum addAttribute:NSFontAttributeName value:FontContentSmall range:NSMakeRange(numberApr, 1)];
        _labAprNum.attributedText=attrStrAprNum;
        
        float amount=(_investment.amount/10000.0);
        NSString *strAmount=[NSString stringWithFormat:@"%.1f万",amount];
        int numberAmount=(int)strAmount.length-1;
        NSMutableAttributedString *attrStrAmountNum=[[NSMutableAttributedString alloc] initWithString:strAmount];
        [attrStrAmountNum addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, numberAmount)];
        [attrStrAmountNum addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:NSMakeRange(numberAmount, 1)];
        [attrStrAmountNum addAttribute:NSFontAttributeName value:FontTextBigNumber range:NSMakeRange(0, numberAmount)];
        [attrStrAmountNum addAttribute:NSFontAttributeName value:FontContentSmall range:NSMakeRange(numberAmount, 1)];
        _labAmountNum.attributedText=attrStrAmountNum;
        
        NSString *strPeriod;
        int numberPeriod=1;
        int lenghtPeriod=1;//单位长度
        if([_investment.unitstr isEqualToString:@"0"]){
            strPeriod = [NSString stringWithFormat:@"%@个月",_investment.time];
            numberAmount=(int)strPeriod.length-2;
            lenghtPeriod=2;
        }  else if([_investment.unitstr isEqualToString:@"-1"]){
            strPeriod = [NSString stringWithFormat:@"%@年",_investment.time];
            numberAmount=(int)strPeriod.length-1;
        }
        else{
            strPeriod = [NSString stringWithFormat:@"%@天",_investment.time];
            numberAmount=(int)strPeriod.length-1;
        }
        NSMutableAttributedString *attrStrPeriod=[[NSMutableAttributedString alloc] initWithString:strPeriod];
        [attrStrPeriod addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:NSMakeRange(0, numberPeriod)];
        [attrStrPeriod addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:NSMakeRange(numberPeriod, lenghtPeriod)];
        [attrStrPeriod addAttribute:NSFontAttributeName value:FontTextBigNumber range:NSMakeRange(0, numberPeriod)];
        [attrStrPeriod addAttribute:NSFontAttributeName value:FontContentSmall range:NSMakeRange(numberPeriod, lenghtPeriod)];
        _labPeriod.attributedText=attrStrPeriod;
        
        
        
        if(_investment.status==1||_investment.status==2||_investment.status==3){
            if(_investment.progress<100.0){
                [_btnInvest setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:1.0] forState:UIControlStateNormal];
                [_btnInvest setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:0.6] forState:UIControlStateHighlighted];
                [_btnInvest setTitle:@"投标" forState:UIControlStateNormal];
                _btnInvest.userInteractionEnabled=YES;
            }else{
                [_btnInvest setBackgroundImage:[ImageTools imageWithColor:ColorBigContentText] forState:UIControlStateNormal];
                [_btnInvest setTitle:@"满标" forState:UIControlStateNormal];
                _btnInvest.userInteractionEnabled=NO;
            }
        }else if(_investment.status==4){
            [_btnInvest setBackgroundImage:[ImageTools imageWithColor:ColorBigContentText] forState:UIControlStateNormal];
            [_btnInvest setTitle:@"还款中" forState:UIControlStateNormal];
            _btnInvest.userInteractionEnabled=NO;
        }else if(_investment.status==5){
            [_btnInvest setBackgroundImage:[ImageTools imageWithColor:ColorBigContentText] forState:UIControlStateNormal];
            [_btnInvest setTitle:@"已还款" forState:UIControlStateNormal];
            _btnInvest.userInteractionEnabled=NO;
        }else if (_investment.status<0){
            [_btnInvest setBackgroundImage:[ImageTools imageWithColor:ColorBigContentText] forState:UIControlStateNormal];
            [_btnInvest setTitle:@"流标" forState:UIControlStateNormal];
            _btnInvest.userInteractionEnabled=NO;
        }
        
    }
}

-(void)onClickBid{
    NSLog(@"=========");
}


@end
