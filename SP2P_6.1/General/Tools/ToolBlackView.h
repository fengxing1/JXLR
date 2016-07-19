//
//  ToolBlackView.h
//  SP2P_6.1
//
//  Created by 邹显 on 16/4/16.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ModelRemoteNotification;

@interface ToolBlackView : NSObject
+(UIView *)createBlackView;
+(UIView *)createRemindWithTitle:(NSString *)title withContent:(NSString *)content withLeftText:(NSString *)left withRightText:(NSString  *)right withTarget:(id)target  withActionLeft:(SEL)actionLeft withActionRight:(SEL)actionRight;
+(UIView *)createRemindWithTitle:(NSString *)title withContent:(NSString *)content withButtonText:(NSString *)buttonText withTarget:(id)target  withAction:(SEL)action;
+(UIView *)createRemindWithContent:(NSString *)content withTarget:(id)target  withAction:(SEL)action  withCloseAction:(SEL)actionClose;
+(UIView *)createRemoteNotificationWithModel:(ModelRemoteNotification *)model withButtonText:(NSString *)buttonText withTarget:(id)target  withAction:(SEL)action  withCloseAction:(SEL)actionClose;
@end
