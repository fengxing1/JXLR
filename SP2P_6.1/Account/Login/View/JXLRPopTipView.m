//
//  JXLRPopTipView.m
//  LX-UI模板
//
//  Created by eims1 on 16/2/20.
//  Copyright (c) 2016年 sky. All rights reserved.
//

#import "JXLRPopTipView.h"
#define WidthContent (WidthScreen-SpaceBig*2)
#define HeightContent (WidthContent/1.74)
#define HeightHeader (HeightContent*0.26)
#define HeightCenter (HeightContent*0.34)
#define HeightBottom (HeightContent*0.40)
#define HeightButton (HeightBottom*0.65)
#define WHImage 20
@interface JXLRPopTipView()
@property (nonatomic,strong) UIView *rectView;//内容背景
@property (nonatomic,strong) UIImageView *imageView;//顶部信息图片
@property (nonatomic,strong) UILabel *labTitle;//内容标题
@property (nonatomic,strong) UILabel  *labContent;//中间内容
@end
@implementation JXLRPopTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0, 0, WidthScreen, HeightScreen);
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    self.clipsToBounds=YES;
    
    _rectView = [[UIView alloc] init];
    _rectView.backgroundColor = [UIColor whiteColor];
    _rectView.frame = CGRectMake((WidthScreen-WidthContent)/2, (HeightScreen-HeightContent-HeightNavigationAndStateBar)/2, WidthContent, HeightContent);
    _rectView.layer.cornerRadius = 3.0;
    _rectView.clipsToBounds=YES;
    [self addSubview:_rectView];
    
    UIView *viewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WidthContent, HeightHeader)];
    viewHeader.backgroundColor=ColorBGGray;
    [_rectView addSubview:viewHeader];
    
    _imageView=[[UIImageView alloc] init];
    [viewHeader addSubview:_imageView];
    
    _labTitle = [[UILabel alloc] init];
    _labTitle.textColor=ColorNavTitle;
    _labTitle.font=FontNavTitle;
    [viewHeader addSubview:_labTitle];
    
    _labContent = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewHeader.frame), WidthContent, HeightCenter)];
    _labContent.textAlignment = NSTextAlignmentCenter;
    _labContent.font = FontMedium;
    _labContent.numberOfLines = 0;
    _labContent.lineBreakMode = NSLineBreakByClipping;
    _labContent.textColor = ColorTextVice;
    [_rectView addSubview:_labContent];
    
    UIView *viewLine=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_labContent.frame), WidthContent, HeightLine)];
    viewLine.backgroundColor=ColorLine;
    [_rectView addSubview:viewLine];
    
    _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBig, CGRectGetMaxY(viewLine.frame)+(HeightBottom-HeightButton)/2, WidthContent-SpaceBig*2, HeightButton)];
    [_bottomBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [_bottomBtn setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    _bottomBtn.layer.masksToBounds=YES;
    _bottomBtn.layer.cornerRadius = 3.0;
    _bottomBtn.titleLabel.font = FontTextTitle;
    [_bottomBtn setTitle:@"" forState:UIControlStateNormal];//返回登录
    [_rectView addSubview:_bottomBtn];

}
-(void)setTipViewWithTopImage:(NSString *)imageName withTitle:(NSString *)title withContent:(NSString *)content withButtonTitle:(NSString *)buttonTitle{
    float lengthTitle=[SizeTools getStringWidth:title Font:FontNavTitle];
    float pointXTitle=(WidthContent-lengthTitle)/2;
    if(imageName.length>0){
        _imageView.frame=CGRectMake((WidthContent-lengthTitle-WHImage-SpaceSmall)/2, (HeightHeader-WHImage)/2, WHImage, WHImage);
        _imageView.image=[UIImage imageNamed:imageName];
        pointXTitle=CGRectGetMaxX(_imageView.frame)+SpaceSmall;
    }
    
    _labTitle.frame=CGRectMake(pointXTitle, 0, lengthTitle, HeightHeader);
    _labTitle.text=title;
    
    _labContent.text=content;
    
    [_bottomBtn setTitle:buttonTitle forState:UIControlStateNormal];
}
@end

