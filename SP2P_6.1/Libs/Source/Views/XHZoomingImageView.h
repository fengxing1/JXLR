//
//  XHZoomingImageView.h
//  XHImageViewer
//
//  Created by Jaqen on 16/8/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHZoomingImageView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) BOOL isViewing;

@end
