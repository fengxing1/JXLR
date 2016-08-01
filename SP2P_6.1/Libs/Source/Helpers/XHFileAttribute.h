//
//  XHFileAttribute.h
//  XHImageViewer
//
//  Created by Jaqen on 16/8/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHFileAttribute : NSObject

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSDictionary *fileAttributes;
@property (nonatomic, readonly) NSDate *fileModificationDate;
- (id)initWithPath:(NSString *)filePath attributes:(NSDictionary *)attributes;

@end
