//
//  ViewBidHot.m
//  SP2P_6.1
//
//  Created by 邹显 on 16/3/22.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ViewBidHot.h"

@implementation ViewBidHot
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}
-(void)initView{
//    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.54, self.frame.size.width*0.06, self.frame.size.width*0.4, self.frame.size.height*0.4)];
//    imageView.image=[UIImage imageNamed:@"bid_hot"];
//    [self addSubview:imageView];
//    self.backgroundColor=[UIColor clearColor];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image=[UIImage imageNamed:@"fire"];
    [self addSubview:imageView];
    self.backgroundColor=[UIColor clearColor];
}
//- (void)drawRect:(CGRect)rect
//{
//    //设置背景颜色
//    [[UIColor clearColor]set];
//    UIRectFill([self bounds]);
//    //拿到当前视图准备好的画板
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //利用path进行绘制三角形
//    CGContextBeginPath(context);//标记
//    CGContextMoveToPoint(context,0, 0);//设置起点
//    CGContextAddLineToPoint(context,self.frame.size.width, 0);
//    CGContextAddLineToPoint(context,self.frame.size.width, self.frame.size.height);
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//    [ColorRedMain setFill];
//    //设置填充色
//    [ColorRedMain setStroke];
//    //设置边框颜色
//    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
//}
@end
