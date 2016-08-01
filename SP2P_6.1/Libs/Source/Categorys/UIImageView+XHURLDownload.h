//
//  UIImageView+XHURLDownload.h
//  XHImageViewer
//
//  Created by Jaqen on 16/8/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIImageViewURLDownloadState) {
    UIImageViewURLDownloadStateUnknown = 0,
    UIImageViewURLDownloadStateLoaded,
    UIImageViewURLDownloadStateWaitingForLoad,
    UIImageViewURLDownloadStateNowLoading,
    UIImageViewURLDownloadStateFailed,
};

@interface UIImageView (XHURLDownload)

// url
@property (nonatomic, strong) NSURL *url;

// download state
@property (nonatomic, readonly) UIImageViewURLDownloadState loadingState;

// UI
@property (nonatomic, strong) UIView *loadingView;
// Set UIActivityIndicatorView as loadingView
- (void)setDefaultLoadingView;

// instancetype
+ (id)imageViewWithURL:(NSURL *)url autoLoading:(BOOL)autoLoading;

// Get instance that has UIActivityIndicatorView as loadingView by default
+ (id)indicatorImageView;
+ (id)indicatorImageViewWithURL:(NSURL *)url autoLoading:(BOOL)autoLoading;

// Download
- (void)loadWithURL:(NSURL *)url;
- (void)loadWithURL:(NSURL *)url placeholer:(UIImage *)placeholerImage;
- (void)loadWithURL:(NSURL *)url placeholer:(UIImage *)placeholerImage showActivityIndicatorView:(BOOL)show;
- (void)loadWithURL:(NSURL *)url placeholer:(UIImage *)placeholerImage showActivityIndicatorView:(BOOL)show completionBlock:(void(^)(UIImage *image, NSURL *url, NSError *error))handler;

- (void)setUrl:(NSURL *)url autoLoading:(BOOL)autoLoading;
- (void)load;

@end
