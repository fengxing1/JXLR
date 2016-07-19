//
//  ReviewCourseDetailsViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiteratureAudit.h"
/**
 *  审核资料详情
 */
@interface ReviewCourseDetailsViewController : ViewControllerBasicNotNetwork

@property(nonatomic, strong) LiteratureAudit *literatureAudit;

@end
