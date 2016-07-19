//
//  AdScrollViewLabel.h
//  SP2P_6.1
//
//  Created by tusm on 16/3/23.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdScrollViewLabel;

#pragma mark - FocusImageFrameDelegate
@protocol FocusMessageFrameDelegate <NSObject>
@optional
- (void)foucusMessageFrame:(AdScrollViewLabel *)imageFrame currentItem:(int)index;
@end

@interface AdScrollViewLabel : UIView<UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    BOOL _isAutoPlay;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<FocusMessageFrameDelegate>)delegate messages:(NSArray *)items isAuto:(BOOL)isAuto;

- (id)initWithFrame:(CGRect)frame delegate:(id<FocusMessageFrameDelegate>)delegate messages:(NSArray *)items;
- (void)scrollToIndex:(int)aIndex;

#pragma mark 改变添加label内容
-(void)changeMessagesContent:(NSArray *)aArray;

@property (nonatomic, assign) id<FocusMessageFrameDelegate> delegate;

@end

