//
//  ButtonBadge.m
//  WeiBo
//
//  Created by tusm on 15/7/10.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import "ButtonBadge.h"
#import "UIImage+Yiu.h"
#import "ToolConstant.h"
#define FontBadge   [UIFont systemFontOfSize:11]
@implementation ButtonBadge
-(id)init{
    self=[super init];
    if(self){
        [self Setup];
    }
    return self;
}
-(void)Setup{
    self.buttonTypeBadge=ButtonTypeBadegeRedNumber;
    self.buttonTypeAligm=ButtonTypeAligmCenter;
    self.clipsToBounds=YES;
    self.userInteractionEnabled=NO;
    self.hidden=YES;
    self.titleLabel.font=FontBadge;
}
-(void)setButtonTypeBadge:(ButtonTypeBadege)buttonTypeBadge{
    _buttonTypeBadge=buttonTypeBadge;
    if(buttonTypeBadge==ButtonTypeBadegeRedCircle){
        [self setBackgroundImage:[ImageTools imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        self.frame=CGRectMake(0, 0, SizeWHRedCircle, SizeWHRedCircle);
        self.layer.cornerRadius=SizeWHRedCircle/2;
    }else if (buttonTypeBadge==ButtonTypeBadegeRedNumber){
        [self setBackgroundImage:[UIImage StretchableImageWithName:@"main_badge"] forState:UIControlStateNormal];
        self.frame=CGRectMake(0, 0, SizeWHNumber, SizeWHNumber);
        self.layer.cornerRadius=0;
    }
}
-(void)setRedCirclePoint:(CGPoint)point{
    self.frame=CGRectMake(point.x, point.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
-(void)setStrBadge:(NSString *)strBadge{
    _strBadge=strBadge;
    if(strBadge.length>0){
        self.hidden=NO;
        int value=(int)[strBadge integerValue];
        if([ToolConstant isPureInt:strBadge]&&value==0){
            self.hidden=YES;
        }
        if(value>99){
            strBadge=@"99+";
        }
        CGFloat sizeH=SizeWHNumber;
        CGFloat sizeW=SizeWHNumber;
        CGFloat pointX=self.frame.origin.x;
        if(strBadge.length>1){
            sizeW=[SizeTools getStringWidth:strBadge Font:FontBadge]+10;
        }
        
        if(self.buttonTypeAligm==ButtonTypeAligmCenter){
            pointX=self.center.x-sizeW/2;
        }else if(self.buttonTypeAligm==ButtonTypeAligmRight){
            pointX=CGRectGetMaxX(self.frame)-sizeW;
        }
        
        self.frame=CGRectMake(pointX, self.frame.origin.y, sizeW, sizeH);
        [self setTitle:strBadge forState:UIControlStateNormal];
    }else{
        self.hidden=YES;
    }
}
@end
