//
//  ButtonBadge.h
//  WeiBo
//
//  Created by tusm on 15/7/10.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ButtonTypeAligm){
    ButtonTypeAligmLeft,
    ButtonTypeAligmCenter,
    ButtonTypeAligmRight
};
typedef NS_ENUM(NSInteger, ButtonTypeBadege){
    ButtonTypeBadegeRedCircle,
    ButtonTypeBadegeRedNumber
};
#define SizeWHRedCircle  8
#define SizeWHNumber  19
@interface ButtonBadge : UIButton
@property(nonatomic,copy)NSString *strBadge;
@property(nonatomic,assign)ButtonTypeAligm buttonTypeAligm;
@property(nonatomic,assign)ButtonTypeBadege buttonTypeBadge;
-(void)setRedCirclePoint:(CGPoint)point;
@end
