//
//  ControlImageTitle.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/27.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ControlImageTitle.h"
#define  FontTitle [UIFont systemFontOfSize:13]
@interface  ControlImageTitle()
@property(nonatomic,strong)UILabel *labTitle;
@property(nonatomic,strong)UIButton *btnImage;
@property(nonatomic,strong)UIImageView *imageView;
@end
@implementation ControlImageTitle
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImage:(UIImage *)image withColor:(UIColor *)color addTarget:(id)target action:(SEL)action{
    self=[super initWithFrame:frame];
    if(self){
        [self initViewWithTitle:title withImage:image withColor:color addTarget:target action:action];
    }
    return self;
}
-(void)initViewWithTitle:(NSString *)title withImage:(UIImage *)image withColor:(UIColor *)color addTarget:(id)target action:(SEL)action{
    
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    float whImageView=CGRectGetWidth(self.frame);
    _btnImage=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, whImageView, whImageView)];
    [_btnImage setBackgroundImage:[ImageTools imageWithColor:color] forState:UIControlStateNormal];
    [_btnImage setBackgroundImage:[ImageTools imageWithColor:color withAlpha:0.6] forState:UIControlStateHighlighted];
    _btnImage.layer.cornerRadius=whImageView/2;
    _btnImage.layer.masksToBounds=YES;
    [_btnImage addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnImage];
    
    float spaceImage=7;
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(spaceImage, spaceImage, whImageView-spaceImage*2, whImageView-spaceImage*2)];
    _imageView.image=image;
    _imageView.backgroundColor=[UIColor clearColor];
    _imageView.userInteractionEnabled=NO;
    [self addSubview:_imageView];
    
    float heightTitle=[SizeTools getStringHeight:title Font:FontTitle];
    _labTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnImage.frame)+SpaceSmall, whImageView,heightTitle)];
    _labTitle.textColor=ColorTextVice;
    _labTitle.text=title;
    _labTitle.textAlignment=NSTextAlignmentCenter;
    _labTitle.font=FontTitle;
    [self addSubview:_labTitle];
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(_labTitle.frame));
}
@end
