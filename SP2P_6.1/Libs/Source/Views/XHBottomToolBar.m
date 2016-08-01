//
//  XHBottomToolBar.m
//  XHImageViewer
//
//  Created by Jaqen on 16/8/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "XHBottomToolBar.h"

@interface XHBottomToolBar ()

@end

@implementation XHBottomToolBar

- (UILabel *)pageLabel{
    if(!_pageLabel){
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(WidthScreen -80-SpaceSmall, 0, 80, CGRectGetHeight(self.bounds))];
        [self addSubview:_pageLabel];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pageLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80+SpaceSmall*2, 0, WidthScreen-80*2-SpaceSmall*4, CGRectGetHeight(self.bounds))];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"保存" forState:UIControlStateNormal];
        _shareButton.frame = CGRectMake(SpaceSmall, 0, 80, CGRectGetHeight(self.bounds));
        [self addSubview:_shareButton];
    }
    return _shareButton;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

@end
