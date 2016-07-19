//
//  AdScrollViewLabel.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/23.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AdScrollViewLabel.h"
#import <objc/runtime.h>

#define ITEM_HEIGHT self.frame.size.height

@interface AdScrollViewLabel () {
    UIScrollView *_scrollView;
}
@end

static NSString *FOCUS_ITEM_ASS_KEY = @"loopMessageScrollview";
static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 5.0; //switch interval time

@implementation AdScrollViewLabel

- (id)initWithFrame:(CGRect)frame delegate:(id<FocusMessageFrameDelegate>)delegate messages:(NSArray *)items isAuto:(BOOL)isAuto
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSMutableArray *imageItems = [NSMutableArray arrayWithArray:items];
        objc_setAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY), imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = isAuto;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<FocusMessageFrameDelegate>)delegate messages:(NSArray *)items
{
    return [self initWithFrame:frame delegate:delegate messages:items isAuto:YES];
}

#pragma mark - private methods
- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY));
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;
    
    [self addSubview:_scrollView];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
    [self addMessages:imageItems];
}

#pragma mark 添加视图
-(void)addMessages:(NSArray *)aImageItems{
    //移除子视图
    for (UIView *lView in _scrollView.subviews) {
        [lView removeFromSuperview];
    }
    
    float space = 0;
    CGSize size = CGSizeMake(self.frame.size.width, 0);
    for (int i = 0; i < aImageItems.count; i++) {
        NSAttributedString *item = [aImageItems objectAtIndex:i];
        UILabel *labelMessage = [[UILabel alloc] initWithFrame:CGRectMake(space,i * _scrollView.frame.size.height+space,  _scrollView.frame.size.width-space*2, _scrollView.frame.size.height-2*space-size.height)];
        labelMessage.attributedText=item;
        labelMessage.font=FontTextSmall;
        labelMessage.textAlignment=NSTextAlignmentLeft;
        //加载图片
        labelMessage.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:labelMessage];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height* aImageItems.count);
    
    
    if ([aImageItems count]>1)
    {
        if (_isAutoPlay)
        {
            [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
        }
    }
}

#pragma mark 改变添加视图内容
-(void)changeMessagesContent:(NSArray *)aArray{
    NSMutableArray *imageItems = [NSMutableArray arrayWithArray:aArray];
    objc_setAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY), imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addMessages:imageItems];
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetY = _scrollView.contentOffset.y + _scrollView.frame.size.height;
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY));
    targetY = (int)(targetY/ITEM_HEIGHT) * ITEM_HEIGHT;
    [self moveToTargetPosition:targetY];
    
    if ([imageItems count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    }
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //DLOG(@"%s", __FUNCTION__);
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY));
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count) {
        if ([self.delegate respondsToSelector:@selector(foucusMessageFrame:currentItem:)]) {
            [self.delegate foucusMessageFrame:self currentItem:page];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetY
{
    BOOL animated = YES;
    [_scrollView setContentOffset:CGPointMake(0, targetY) animated:animated];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetY = scrollView.contentOffset.y;
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY));
    if ([imageItems count]>=3)
    {
        if (targetY >= ITEM_HEIGHT * ([imageItems count] -1)) {
            targetY = ITEM_HEIGHT;
            [_scrollView setContentOffset:CGPointMake(0,targetY) animated:NO];
        }
        else if(targetY <= 0)
        {
            targetY = ITEM_HEIGHT *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(0,targetY) animated:NO];
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat targetY = _scrollView.contentOffset.y + _scrollView.frame.size.height;
        targetY = (int)(targetY/ITEM_HEIGHT) * ITEM_HEIGHT;
        [self moveToTargetPosition:targetY];
    }
}

- (void)scrollToIndex:(int)aIndex
{
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY));
    if ([imageItems count]>1)
    {
        if (aIndex >= ([imageItems count]-2))
        {
            aIndex = (int)[imageItems count]-3;
        }
        [self moveToTargetPosition:ITEM_HEIGHT*(aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
    
}
@end