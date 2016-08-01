//
//  HJImageView.h
//  SP2P_6.1
//
//  Created by Jaqen on 16/8/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHImageViewer.h"
#import "XHBottomToolBar.h"

@interface HJImageView : UIView<XHImageViewerDelegate>

@property (nonatomic,strong) NSMutableArray *imageViews;
@property (nonatomic,strong) NSMutableArray *imageTitles;
@property (nonatomic, strong) XHImageViewer *imageViewer;
@property (nonatomic, strong) XHBottomToolBar *bottomToolBar;

-(void)initViewWithUrls:(NSArray *)imageUrls andTitles:(NSArray *)imageTitles;

@end
