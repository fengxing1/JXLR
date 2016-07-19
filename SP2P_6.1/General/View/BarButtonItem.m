//
//  BarButtonItem.m
//  QYGW
//
//  Created by 李小斌 on 14-4-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BarButtonItem.h"

@interface BarButtonItem ()
@end

@implementation BarButtonItem


-(id) initWithImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self = [[BarButtonItem alloc] initWithCustomView:btn];
    if(self){
        _customButton = btn;
        _customTarget=target;
        [self setNormalImage:normalImage];
        [self setSelectedImage:selectedImage];
        [self setCustomAction:action];
    }
    return  self;
}

-(id) initWithTitle:(NSString *)title widthImage:(UIImage *)image withIsImageLeft:(BOOL)isImageLeft target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitleColor:ColorNavTitle forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font=FontTextContent;
    float widthTitle=[SizeTools getStringWidth:title Font:FontTextContent];
    btn.frame=CGRectMake(0, 0, image.size.width+SpaceMediumSmall+widthTitle, 30);
    if(isImageLeft){
        btn.imageEdgeInsets=UIEdgeInsetsMake(0, -SpaceMediumSmall, 0, 0);
    }else{
        btn.imageEdgeInsets=UIEdgeInsetsMake(0, SpaceMediumSmall+widthTitle, 0, 0);
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, -image.size.width-SpaceMediumSmall, 0, 0);
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self = [[BarButtonItem alloc] initWithCustomView:btn];
    if(self){
        _customButton = btn;
        _customTarget=target;
        [self setNormalImage:image];
        [self setCustomAction:action];
    }
    return  self;
}

-(id) initWithTitle:(NSString *)title widthImage:(UIImage *)image selectedImage:(UIImage *)selectedImage withIsImageLeft:(BOOL)isImageLeft target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateHighlighted];
    [btn setTitleColor:ColorNavTitle forState:UIControlStateNormal];
    [btn setTitleColor:ColorTextVice forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font=FontTextContent;
    float widthTitle=[SizeTools getStringWidth:title Font:FontTextContent];
    btn.frame=CGRectMake(0, 0, image.size.width+SpaceMediumSmall+widthTitle, 30);
    if(isImageLeft){
        btn.imageEdgeInsets=UIEdgeInsetsMake(0, -SpaceMediumSmall, 0, 0);
    }else{
        btn.imageEdgeInsets=UIEdgeInsetsMake(0, SpaceMediumSmall+widthTitle, 0, 0);
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, -image.size.width-SpaceMediumSmall, 0, 0);
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self = [[BarButtonItem alloc] initWithCustomView:btn];
    if(self){
        _customButton = btn;
        _customTarget=target;
        [self setNormalImage:image];
        [self setCustomAction:action];
    }
    return  self;
}

+(BarButtonItem *)barItemWithTitle:(NSString *)title widthImage:(UIImage *)image withIsImageLeft:(BOOL)isImageLeft target:(id)target action:(SEL)action{
    return [[BarButtonItem alloc] initWithTitle:title widthImage:image withIsImageLeft:isImageLeft target:target action:action];
}

+(BarButtonItem *)barItemRightDefaultWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    return [[BarButtonItem alloc] initWithTitle:title widthImage:[UIImage imageNamed:@"bar_right"] selectedImage:[UIImage imageNamed:@"bar_right_press"] withIsImageLeft:NO target:target action:action];
}

+(BarButtonItem *)barItemLeftDefaultWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    return [[BarButtonItem alloc] initWithTitle:title widthImage:[UIImage imageNamed:@"bar_left"] selectedImage:[UIImage imageNamed:@"bar_left_press"] withIsImageLeft:YES target:target action:action];
}
+(BarButtonItem *)barItemWithTitle:(NSString *)title widthImage:(UIImage *)image selectedImage:(UIImage *)selectedImage withIsImageLeft:(BOOL)isImageLeft target:(id)target action:(SEL)action{
    return [[BarButtonItem alloc] initWithTitle:title widthImage:image selectedImage:selectedImage withIsImageLeft:isImageLeft target:target action:action];
}

+(BarButtonItem *)barItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action{
    return [[BarButtonItem alloc] initWithImage:image selectedImage:selectedImage target:target action:action];
}


- (void)setNormalImage:(UIImage *)image {
    _normalImage = image;
    [_customButton setImage:image forState:UIControlStateNormal];
}

- (void)setSelectedImage:(UIImage *)image {
    _selectedImage = image;
    [_customButton setImage:image forState:UIControlStateHighlighted];
}

- (void)setCustomAction:(SEL)action {
    _customAction = action;
    [_customButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [_customButton addTarget:_customTarget action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
