//
//  CustomTextField.h
//  P2P
//
//  Created by Cindy on 15/12/23.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapAction)(void);

@interface CustomTextField : UITextField

@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, strong) UIView *leftIconView;
@property (nonatomic, strong) UILabel *labLeftTitle;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *viewOne;
@property (nonatomic, strong) UIView *viewTwo;
@property (nonatomic,copy) TapAction tapActionBlock;

@property (nonatomic,strong) NSArray *userLists;


- (void)setLeftImage:(NSString *)leftIcon rightImage:(NSString *)rightIcon placeName:(NSString *)placeName;
- (void) setLeftText:(NSString *)leftTitle rightImage:(NSString *)rightIcon placeName:(NSString *)placeName;

@end
