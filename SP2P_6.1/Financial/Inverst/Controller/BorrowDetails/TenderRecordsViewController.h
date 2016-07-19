//
//  BidRecordsViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  投标记录
 */
@interface TenderRecordsViewController : ViewControllerBasicNotNetwork

@property (nonatomic , strong)NSString *borrowID;
@property (nonatomic,assign) float paceNum;
@end
