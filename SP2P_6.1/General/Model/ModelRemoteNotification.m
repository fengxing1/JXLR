//
//  ModelRemoteNotification.m
//  SP2P_6.1
//
//  Created by 邹显 on 16/5/9.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ModelRemoteNotification.h"

@interface ModelRemoteNotification()

@end
//百度推送基础类
@implementation ModelRemoteNotification

+(id)initWithUserInfo:(NSDictionary *)userInfo{
    ModelRemoteNotification *model=[[ModelRemoteNotification alloc] init];
    
    model.id = [userInfo objectForKey:@"id"];
    model.remoteNotificationType = [[userInfo objectForKey:@"remoteNotificationType"] integerValue];
    model.descriptionStr = [userInfo objectForKey:@"descriptionStr"];
    model.newbidtitleone = [userInfo objectForKey:@"newbidtitleone"];
    model.rateone = [userInfo objectForKey:@"rateone"];
    model.dateone = [userInfo objectForKey:@"dateone"];
    model.newbidtitletwo = [userInfo objectForKey:@"newbidtitletwo"];
    model.ratetwo = [userInfo objectForKey:@"ratetwo"];
    model.datetwo = [userInfo objectForKey:@"datetwo"];
    model.title = [userInfo objectForKey:@"title"];
    model.url = [userInfo objectForKey:@"url"];
    
    return model;
}

@end
