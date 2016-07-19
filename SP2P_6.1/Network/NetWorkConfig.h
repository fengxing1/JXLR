//
//  NetWorkConfig.h
//  Shove
//
//  Created by 李小斌 on 14-9-22.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#ifndef Shove_NetWorkConfig_h
#define Shove_NetWorkConfig_h

#import "AFNetworking.h"

#import "ShoveGeneralRestGateway.h"
#import <ShareSDK/ShareSDK.h>
#import "NSString+encryptDES.h"

// 升级版本标识符
#define codeNum 3

// app端传输 key
#define MD5key  @"CF5SzNMvCeOoUeYt"
// 加密 key
#define DESkey  @"fU4WhuDn8hAOGHmF"

#define Baseurl   @"http://t.lai.cn"

//#define Baseurl   @"http://www.lai.cn"

//#define Baseurl   @"http://192.168.3.53:8088/sp2p_jxlr"//测试服务器

//#define Baseurl   @"http://p2p-2.test13.shovesoft.com"

//#define Baseurl   @"http://p2p-1.test2.shovesoft.com/sp2p_jxlr"

#endif
