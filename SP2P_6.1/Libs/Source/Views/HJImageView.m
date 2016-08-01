//
//  HJImageView.m
//  SP2P_6.1
//
//  Created by Jaqen on 16/8/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "HJImageView.h"
#import "UIImageView+WebCache.h"
#import "SizeTools.h"
#import "SVProgressHUD.h"

#define MaxShowImgs 5  //最多显示的图片数
#define WidthImage (WidthScreen-SpaceMediumBig*2-SpaceMediumSmall*(MaxShowImgs-1))/MaxShowImgs   //图片宽度

@implementation HJImageView

-(instancetype)init{
    if ( self = [super init]) {
        _imageViews = [NSMutableArray array];
    }
    return self;
}

- (XHBottomToolBar *)bottomToolBar {
    if (!_bottomToolBar) {
        _bottomToolBar = [[XHBottomToolBar alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, 44)];
        [_bottomToolBar.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _bottomToolBar.pageLabel.text = @"1/7";
        _bottomToolBar.titleLabel.text = @"aaaaaaaaa";
    }
    return _bottomToolBar;
}

- (void)shareButtonClicked:(UIButton *)sender {
    UIImage *currentImage = [_imageViewer currentImage];
    if (currentImage) {
        UIImageWriteToSavedPhotosAlbum(currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
//图片保存成功后的回调函数
- (void) image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        [SVProgressHUD showErrorWithStatus:msg];
    }else{
        msg = @"保存图片成功" ;
        [SVProgressHUD showSuccessWithStatus:msg];
    }
}

-(void)initDataWithUrls:(NSArray *)imageUrls andTitles:(NSArray *)imageTitles{
    for (NSString *url in imageUrls) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(SpaceMediumBig+(WidthImage+SpaceMediumSmall)*(MaxShowImgs-1), SpaceBig, 0, 0);
        if ([[NSString stringWithFormat:@"%@",url] hasPrefix:@"http"]) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
        }else{
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,url]]];
        }
        
        [_imageViews addObject:imageView];
    }
    
    _imageTitles = [NSMutableArray arrayWithArray:imageTitles];
}

-(void)initViewWithUrls:(NSArray *)imageUrls andTitles:(NSArray *)imageTitles
{
    [self initDataWithUrls:imageUrls andTitles:(NSArray *)imageTitles];
    
   
    
    
    
    if (_imageViews.count>MaxShowImgs) {
        for (int i=0; i<MaxShowImgs-1; i++) {
            
             UIImageView *imageView = [_imageViews objectAtIndex:i];
            imageView.frame = CGRectMake(SpaceMediumBig+(WidthImage+SpaceMediumSmall)*i, SpaceBig, WidthImage, WidthImage);
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            UITapGestureRecognizer *gesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapHandle:)];
            [imageView addGestureRecognizer:gesture];
            
            [self addSubview:imageView];
            
        }
        
        //更多图片
        UIImageView *placeImg = [[UIImageView alloc] init];
        placeImg.frame = CGRectMake(SpaceMediumBig+(WidthImage+SpaceMediumSmall)*(MaxShowImgs-1), SpaceBig, WidthImage, WidthImage);
        placeImg.userInteractionEnabled = YES;
        placeImg.contentMode = UIViewContentModeScaleAspectFill;
        placeImg.clipsToBounds = YES;
        
        UITapGestureRecognizer *gesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tapHandle:)];
        [placeImg addGestureRecognizer:gesture];

        placeImg.image = [UIImage imageNamed:@"financial_expand_normal"];
        [self addSubview:placeImg];
        
    }else{
        for (int i=0; i<_imageViews.count; i++) {
            
            
            UIImageView *imageView = [_imageViews objectAtIndex:i];
             imageView.frame = CGRectMake(SpaceMediumBig+(WidthImage+SpaceMediumSmall)*i, SpaceBig, WidthImage, WidthImage);
            
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            UITapGestureRecognizer *gesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapHandle:)];
            [imageView addGestureRecognizer:gesture];
            
            [self addSubview:imageView];
        }
    }
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    _imageViewer = [[XHImageViewer alloc]
                    initWithImageViewerWillDismissWithSelectedViewBlock:
                    ^(XHImageViewer *imageViewer, UIImageView *selectedView) {
                        NSInteger index = [_imageViews indexOfObject:selectedView];
                    }
                    didDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer,
                                                      UIImageView *selectedView) {
                        NSInteger index = [_imageViews indexOfObject:selectedView];
                    }
                    didChangeToImageViewBlock:^(XHImageViewer *imageViewer,
                                                UIImageView *selectedView) {
                        NSInteger index = [_imageViews indexOfObject:selectedView];
                        self.bottomToolBar.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu", index + 1, (unsigned long)_imageViews.count];
                        self.bottomToolBar.titleLabel.text = [NSString stringWithFormat:@"%@",_imageTitles[index]];
                        
                    }];
    _imageViewer.delegate = self;
    _imageViewer.disableTouchDismiss = NO;
    [_imageViewer showWithImageViews:_imageViews
                        selectedView:(UIImageView *)tap.view];
    
    int index = (int)[_imageViews indexOfObject:(UIImageView *)tap.view];
    if (index<0) {
        index = 0;
    }
    self.bottomToolBar.pageLabel.text = [NSString stringWithFormat:@"%d/%lu", index + 1, (unsigned long)_imageViews.count];
    self.bottomToolBar.titleLabel.text = [NSString stringWithFormat:@"%@",_imageTitles[index]];
}



#pragma mark - XHImageViewerDelegate

- (UIView *)customBottomToolBarOfImageViewer:(XHImageViewer *)imageViewer {
    return self.bottomToolBar;
}


@end
