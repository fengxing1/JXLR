//
//  XHImageURLDataSource.h
//  XHImageViewer
//
//  Created by Jaqen on 16/8/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XHImageURLDataSource <NSObject>

- (NSString *)largePhotoURLString;

- (NSString *)thnumbnailPhotoURLString;

@end
