//
//  AdWebViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-9-29.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdWebViewController : ViewControllerBasicNotNetwork

@property (nonatomic ,copy) NSString *urlStr;
@property (nonatomic , assign)BOOL isFromeRemote;
@end
