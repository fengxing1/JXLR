//
//  ModelRemoteNotification.h
//  SP2P_6.1
//
//  Created by 邹显 on 16/5/9.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RemoteNotificationType){
    RemoteNotificationTypeURL=0,//推送消息为URL
    RemoteNotificationTypeNewBidOne=1,//新标单标
    RemoteNotificationTypeNewBidTwo=2,//新标双标
    RemoteNotificationTypeActivite=3  //活动
};

//百度推送基础类
@interface ModelRemoteNotification : NSObject

@property(nonatomic,strong)NSString *id;//id编号
@property(nonatomic,assign)RemoteNotificationType remoteNotificationType;//推送消息类型
@property(nonatomic,strong)NSString *url;//链接地址
@property(nonatomic,strong)NSString *title;//标题（不要太长 4-6个字）
@property(nonatomic,strong)NSString *descriptionStr;//提示框中的描述（不要太长 4-6个字）
@property(nonatomic,strong)NSString *newbidtitleone;//第一个标Title
@property(nonatomic,strong)NSString *rateone;//第一个标年利率
@property(nonatomic,strong)NSString *dateone;//第一个标期限
@property(nonatomic,strong)NSString *newbidtitletwo;//第二个标Title
@property(nonatomic,strong)NSString *ratetwo;//第二个标年利率
@property(nonatomic,strong)NSString *datetwo;//第二个标期限
+(id)initWithUserInfo:(NSDictionary *)userInfo;

@end
