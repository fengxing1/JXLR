//
//  CustomTextField.m
//  P2P
//
//  Created by Cindy on 15/12/23.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "CustomTextField.h"
#define WidthLeftIcon  20

@implementation CustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = ColorTextContent;
        self.font = FontTextContent;
        
        self.viewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, HeightLine)];
        self.viewOne.backgroundColor = KlayerBorder;
        [self addSubview:self.viewOne];
        
        self.viewTwo = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, HeightLine)];
        self.viewTwo.backgroundColor = KlayerBorder;
        [self addSubview:self.viewTwo];
        
        _leftIconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, self.frame.size.height)];
        _leftIconView.backgroundColor = [UIColor clearColor];
        self.leftView = _leftIconView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (void) setLeftImage:(NSString *)leftIcon rightImage:(NSString *)rightIcon placeName:(NSString *)placeName
{
    self.placeholder = placeName;
    
    if (leftIcon.length > 0)
    {
        _leftIconView.frame = CGRectMake(0, 0, WidthLeftIcon+SpaceMediumSmall*2, self.frame.size.height);
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(SpaceMediumSmall, (self.frame.size.height-25)*0.5, WidthLeftIcon, 25)];
        _leftImage.image = [UIImage imageNamed:leftIcon];
        _leftImage.contentMode = UIViewContentModeScaleAspectFit;
        [_leftIconView addSubview:_leftImage];
    }
    
    if (rightIcon.length > 0)
    {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 28)];
        [_rightBtn setImage:[UIImage imageNamed:rightIcon] forState:UIControlStateNormal];
        _rightBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_rightBtn addTarget:self action:@selector(shiftAction) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = _rightBtn;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (void) setLeftText:(NSString *)leftTitle rightImage:(NSString *)rightIcon placeName:(NSString *)placeName
{
    self.placeholder = placeName;
    
    if (leftTitle.length > 0)
    {
        float widthTitle=[SizeTools getStringWidth:leftTitle Font:FontTextTitle];
        _leftIconView.frame = CGRectMake(SpaceMediumSmall, 0, widthTitle+SpaceMediumSmall*2, self.frame.size.height);
        _labLeftTitle = [[UILabel alloc]initWithFrame:CGRectMake(SpaceMediumSmall, 0, widthTitle, self.frame.size.height)];
        _labLeftTitle.text=leftTitle;
        _labLeftTitle.textColor=ColorTextContent;
        _labLeftTitle.font=FontTextTitle;
        _labLeftTitle.textAlignment=NSTextAlignmentLeft;
        [_leftIconView addSubview:_labLeftTitle];
    }
    
    if (rightIcon.length > 0)
    {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 28)];
        [_rightBtn setImage:[UIImage imageNamed:rightIcon] forState:UIControlStateNormal];
        _rightBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_rightBtn addTarget:self action:@selector(shiftAction) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = _rightBtn;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (void)shiftAction
{
    if(self.tapActionBlock)
    {
        self.tapActionBlock();
        return;
    }
}

@end
