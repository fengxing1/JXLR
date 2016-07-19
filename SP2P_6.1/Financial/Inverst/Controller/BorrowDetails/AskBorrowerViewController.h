//
//  AskBorrowerViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  提问
 */
@interface AskBorrowerViewController : ViewControllerBasicNotNetwork
@property (nonatomic ,strong) NSString *borrowId;
@property (nonatomic ,strong) NSString *bidUserIdSign;
@property (nonatomic, assign) float paceNum;
@end
