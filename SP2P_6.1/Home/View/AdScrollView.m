//
//  AdScrollView.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AdScrollView.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

#define ITEM_WIDTH self.frame.size.width

@interface AdScrollView () {
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

- (void)setupViews;
- (void)switchFocusImageItems;
@end

static NSString *FOCUS_ITEM_ASS_KEY = @"loopScrollview";
static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 5.0; //switch interval time
@implementation AdScrollView

- (id)initWithFrame:(CGRect)frame delegate:(id<FocusImageFrameDelegate>)delegate focusImageItems:(AdvertiseGallery *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];
        AdvertiseGallery *eachItem;
        va_list argumentList;
        if (firstItem)
        {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);
            while((eachItem = va_arg(argumentList, AdvertiseGallery *)))
            {
                [imageItems addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY), imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = YES;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<FocusImageFrameDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto
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
- (id)initWithFrame:(CGRect)frame delegate:(id<FocusImageFrameDelegate>)delegate imageItems:(NSArray *)items
{
    return [self initWithFrame:frame delegate:delegate imageItems:items isAuto:YES];
}

#pragma mark - private methods
- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY));
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-SpaceSmall-SpaceMediumSmall, self.frame.size.width, SpaceMediumSmall)];
    _pageControl.userInteractionEnabled = YES;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pageControl.currentPageIndicatorTintColor = ColorRedMain;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];

    [self addImageViews:imageItems];
}

#pragma mark 添加视图
-(void)addImageViews:(NSArray *)aImageItems{
    //移除子视图
    for (UIView *lView in _scrollView.subviews) {
        [lView removeFromSuperview];
    }
    
    float space = 0;
    CGSize size = CGSizeMake(self.frame.size.width, 0);
    for (int i = 0; i < aImageItems.count; i++) {
        AdvertiseGallery *item = [aImageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width+space, space, _scrollView.frame.size.width-space*2, _scrollView.frame.size.height-2*space-size.height)];

        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        //加载图片
        imageView.backgroundColor = [UIColor clearColor];
        if([item.image length]>0){
            [imageView sd_setImageWithURL:[NSURL URLWithString:item.image]
                        placeholderImage:[UIImage imageNamed:@"default_image"]];
        }else{
            [imageView setImage:[UIImage imageNamed:@"default_image"]];
        }
        imageView.contentMode = UIViewContentModeScaleToFill;
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * aImageItems.count, _scrollView.frame.size.height);
    _pageControl.numberOfPages = aImageItems.count>1?aImageItems.count -2:aImageItems.count;
    _pageControl.currentPage = 0;
    
    
    if ([aImageItems count]>1)
    {
        if (_isAutoPlay)
        {
            [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
        }
    }
}

#pragma mark 改变添加视图内容
-(void)changeImageViewsContent:(NSArray *)aArray{
    NSMutableArray *imageItems = [NSMutableArray arrayWithArray:aArray];
    objc_setAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY), imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addImageViews:imageItems];
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY));
    targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
    [self moveToTargetPosition:targetX];
    
    if ([imageItems count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    }
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY));
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count) {
        AdvertiseGallery *item = [imageItems objectAtIndex:page];
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [self.delegate foucusImageFrame:self didSelectItem:item];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    BOOL animated = YES;
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(FOCUS_ITEM_ASS_KEY));
    if ([imageItems count]>=3)
    {
        if (targetX >= ITEM_WIDTH * ([imageItems count] -1)) {
            targetX = ITEM_WIDTH;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = ITEM_WIDTH *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    int page = (_scrollView.contentOffset.x+ITEM_WIDTH/2.0) / ITEM_WIDTH;
    if ([imageItems count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = (int)_pageControl.numberOfPages -1;
        }
    }
    if (page!= _pageControl.currentPage)
    {
//        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:currentItem:)])
//        {
//            [self.delegate foucusImageFrame:self currentItem:page];
//        }
    }
    _pageControl.currentPage = page;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        [self moveToTargetPosition:targetX];
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
        [self moveToTargetPosition:ITEM_WIDTH*(aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
}
@end