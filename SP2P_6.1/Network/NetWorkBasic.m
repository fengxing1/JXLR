//
//  NetWorkBasic.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/26.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "NetWorkBasic.h"

@implementation NetWorkBasic

- (instancetype)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:Baseurl]];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    }
    return self;
}

//-判断当前网络是否可用
-(BOOL) isNetworkEnabled
{
    BOOL bEnabled = FALSE;
    NSString *url = @"www.baidu.com";
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    SCNetworkReachabilityFlags flags;
    
    bEnabled = SCNetworkReachabilityGetFlags(ref, &flags);
    
    CFRelease(ref);
    if (bEnabled) {
        BOOL flagsReachable = ((flags & kSCNetworkFlagsReachable) != 0);
        BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
        BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
        bEnabled = ((flagsReachable && !connectionRequired) || nonWiFi) ? YES : NO;
    }
    
    return bEnabled;
}

-(void)cancel
{
    if (_dataTask != nil) {
        [_dataTask cancel];
    }
}
@end
