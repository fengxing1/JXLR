//
//  NetWorkRequestManager.m
//  SP2P_6.1
//
//  Created by tusm on 16/3/26.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "NetWorkRequestManager.h"
#import "NetWorkBasic.h"
#import "AdvertiseGallery.h"
#import "Investment.h"
#define URLString @"app/services"
@implementation NetWorkRequestManager
/**
 *  初始化网络管理类
 */
+(id)instanceRequest{
    static NetWorkRequestManager *request;
    if(request==nil){
        request=[[NetWorkRequestManager alloc]init];
    }
    return request;
}

/**
 *  OPT=1  登录
 *
 *  @param account    <#account description#>
 *  @param password   <#password description#>
 *  @param deviceType <#deviceType description#>
 */
-(void)requestLoginWithAccount:(NSString *)account  withPassword:(NSString *)password withDeviceType:(NSString *)deviceType{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *passwordNew = [NSString encrypt3DES:password key:DESkey];
    [parameters setObject:@"1" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:account forKey:@"name"];
    [parameters setObject:passwordNew forKey:@"pwd"];
    if(AppDelegateInstance.userId !=nil && AppDelegateInstance.channelId != nil)
    {
        [parameters setObject:AppDelegateInstance.userId forKey:@"userId"];
        [parameters setObject:AppDelegateInstance.channelId forKey:@"channelId"];
    }else{
        [parameters setObject:@"" forKey:@"userId"];
        [parameters setObject:@"" forKey:@"channelId"];
    }
    [parameters setObject:deviceType forKey:@"deviceType"];
    
    NetWorkBasic *netWorkBasic=[[NetWorkBasic alloc] init];
    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    if (![netWorkBasic isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequestLogin)]) {
            [self.delegate startRequestLogin];
        }
        netWorkBasic.dataTask = [netWorkBasic GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self responseSuccessLogin:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(responseFailure:)]) {
                [self.delegate responseFailure:error];
            }
        }];
    }
}
/**
 {
 accountAmount = 0;
 availableBalance = 0;
 creditLimit = 42000;
 creditRating = "/public/images/xy_hr.png";
 error = "-1";
 freeze = 0;
 headImg = "/images?uuid=7499ba91-8307-4ad2-a974-8a0437bbdf46";
 id = 72C7578F74596816A85B00585425A2570FB8CF464C77CFEFC6BF34380FF33492db8c3a51;
 isAddBaseInfo = 1;
 isEmailVerified = 1;
 msg = "\U767b\U5f55\U6210\U529f";
 receivingAmount = "102.25";
 totalIncome = "2.25";
 username = lairongziv;
 vipStatus = 0;
 }
 */
-(void)responseSuccessLogin:(id)obj{
    NSDictionary *dics = obj;
    DLOG(@"OPT=1  登录:%@",dics);
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        UserInfo *usermodel = [[UserInfo alloc] init];
        usermodel.userName = [obj objectForKey:@"username"];
        
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"headImg"]] hasPrefix:@"http"]) {
            
            usermodel.userImg = [NSString stringWithFormat:@"%@",[obj objectForKey:@"headImg"]];
        }
        else
        {
            usermodel.userImg = [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]];
        }
        
        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"creditRating"]] hasPrefix:@"http"])
        {
            usermodel.userCreditRating = [obj objectForKey:@"creditRating"];
        }else{
            usermodel.userCreditRating =  [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"creditRating"]];
        }
        
        usermodel.userLimit = [obj objectForKey:@"creditLimit"];
        usermodel.isVipStatus = [obj objectForKey:@"vipStatus"];
        usermodel.userId = [obj objectForKey:@"id"];
        usermodel.isLogin = @"1";
        usermodel.deviceType = @"2";
        usermodel.accountAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"accountAmount"] doubleValue]];
        usermodel.availableBalance = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"availableBalance"] doubleValue]];
        usermodel.freeze = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"freeze"] doubleValue]];
        usermodel.totalIncome = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"totalIncome"] doubleValue]];
        usermodel.receivingAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"receivingAmount"] doubleValue]];
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessLogin:withMessage:)]) {
            [self.delegate responseSuccessLogin:usermodel withMessage:nil];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessLogin:withMessage:)]) {
            [self.delegate responseSuccessLogin:nil withMessage:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
    }
}
/**
 *  OPT=2  注册信息
 *
 *  @param userName   <#userName description#>
 *  @param password   <#password description#>
 *  @param phone      <#phone description#>
 *  @param verify     <#verify description#>
 *  @param refereeNum <#refereeNum description#>
 */
-(void)requestRegisterMessage:(NSString *)userName withPassword:(NSString *)password widthPhone:(NSString *)phone withVerify:(NSString *)verify withRefereeNum:(NSString *)refereeNum{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *passwordNew = [NSString encrypt3DES:password key:DESkey];
    [parameters setObject:@"2" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:userName forKey:@"name"];
    [parameters setObject:passwordNew forKey:@"pwd"];
    [parameters setObject:phone forKey:@"cellPhone"];
    [parameters setObject:verify forKey:@"code"];
    [parameters setObject:refereeNum forKey:@"refereeNum"];
    
    NetWorkBasic *netWorkBasic=[[NetWorkBasic alloc] init];
    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    
    if (![netWorkBasic isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequestRegisterMessage)]) {
            [self.delegate startRequestRegisterMessage];
        }
        netWorkBasic.dataTask = [netWorkBasic GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self responseSuccessRegisterMessage:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(responseFailure:)]) {
                [self.delegate responseFailure:error];
            }
        }];
    }
}
-(void)responseSuccessRegisterMessage:(id)obj{
    NSDictionary *dics = obj;
    DLOG(@"OPT=2  注册信息:%@",dics);
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessRegisterMessageUserID:withMessage:)]) {
            [self.delegate responseSuccessRegisterMessageUserID:[NSString stringWithFormat:@"%@",[obj objectForKey:@"id"]] withMessage:nil];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessRegisterMessageUserID:withMessage:)]) {
            [self.delegate responseSuccessRegisterMessageUserID:nil withMessage:[obj objectForKey:@"msg"]];
        }
    }
}
/**
 *  OPT=4  获取验证码
 *
 *  @param phone 电话号码
 */
-(void)requestGetVerification:(NSString *)phone{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"4" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:phone forKey:@"cellPhone"];
    
    NetWorkBasic *netWorkBasic=[[NetWorkBasic alloc] init];
    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    
    if (![netWorkBasic isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequestGetVerification)]) {
            [self.delegate startRequestGetVerification];
        }
        netWorkBasic.dataTask = [netWorkBasic GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self responseSuccessVerification:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(responseFailure:)]) {
                [self.delegate responseFailure:error];
            }
        }];
    }
}
-(void)responseSuccessVerification:(id)obj{
    NSDictionary *dics = obj;
    DLOG(@"OPT=4  获取验证码:%@",dics);
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessGetVerification:withMessage:)]) {
            [self.delegate responseSuccessGetVerification:YES withMessage:nil];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessGetVerification:withMessage:)]) {
            [self.delegate responseSuccessGetVerification:NO withMessage:[obj objectForKey:@"msg"]];
        }
    }
}
/**
 *  OPT=5 校验验证码
 *
 *  @param phone
 */
-(void)requestVerificationIsTrue:(NSString *)phone withVerification:(NSString *)verification{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"5" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:phone forKey:@"cellPhone"];
    [parameters setObject:verification forKey:@"randomCode"];
    [parameters setObject:verification forKey:@"code"];
    
    NetWorkBasic *netWorkBasic=[[NetWorkBasic alloc] init];
    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    
    if (![netWorkBasic isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequestVerificationIsTrue)]) {
            [self.delegate startRequestVerificationIsTrue];
        }
        netWorkBasic.dataTask = [netWorkBasic GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self responseSuccessVerificationIsTrue:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(responseFailure:)]) {
                [self.delegate responseFailure:error];
            }
        }];
    }
}
-(void)responseSuccessVerificationIsTrue:(id)obj{
    NSDictionary *dics = obj;
    DLOG(@"OPT=5 校验验证码:%@",dics);
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessVerificationIsTrue:withMessage:)]) {
            [self.delegate responseSuccessVerificationIsTrue:[NSString stringWithFormat:@"%@",[obj objectForKey:@"id"]] withMessage:nil];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessVerificationIsTrue:withMessage:)]) {
            [self.delegate responseSuccessVerificationIsTrue:nil withMessage:[obj objectForKey:@"msg"]];
        }
    }
}
/**
 *  OPT=6 重置密码
 *
 *  @param password
 *  @param phone
 */
-(void)requestChangePassword:(NSString *)password withPhone:(NSString *)phone{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"6" forKey:@"OPT"];// 客户端修改登录密码接口
    [parameters setObject:@"" forKey:@"body"];
    NSString *newPwd = [NSString encrypt3DES:password key:DESkey];
    [parameters setObject:newPwd forKey:@"newpwd"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    [parameters setObject:phone forKey:@"cellPhone"];
    
    NetWorkBasic *netWorkBasic=[[NetWorkBasic alloc] init];
    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    
    if (![netWorkBasic isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequestChangePassword)]) {
            [self.delegate startRequestChangePassword];
        }
        netWorkBasic.dataTask = [netWorkBasic GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self responseSuccessChangePassword:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(responseFailure:)]) {
                [self.delegate responseFailure:error];
            }
        }];
    }
}
-(void)responseSuccessChangePassword:(id)obj{
    NSDictionary *dics = obj;
    DLOG(@"OPT=6 重置密码:%@",dics);
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessChangePassword:withMessage:)]) {
            [self.delegate responseSuccessChangePassword:YES withMessage:nil];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessChangePassword:withMessage:)]) {
            [self.delegate responseSuccessChangePassword:NO withMessage:[obj objectForKey:@"msg"]];
        }
    }
}
/**
 *  OPT＝10 获取新标数据
 *
 *  @param apr    <#apr description#>
 *  @param amount <#amount description#>
 *  @param page   <#page description#>
 */
-(void)requestNewBidWithApr:(NSString *)apr withAmount:(NSString *)amount withPage:(int)page{
    if(apr==nil||[apr length]==0)
        apr=@"0";
    if(amount==nil||[amount length]==0)
        amount=@"0";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"10" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:apr forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:amount forKey:@"amount"]; //借款金额
    [parameters setObject:@"0" forKey:@"loanSchedule"]; //投标进度
    [parameters setObject:@"" forKey:@"startDate"]; //开始日期
    [parameters setObject:@"" forKey:@"endDate"]; //结束日期
    [parameters setObject:@"-1" forKey:@"loanType"]; //借款类型
    [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
    [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
    [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    [parameters setObject:[NSString stringWithFormat:@"%d",page] forKey:@"currPage"];  //当前页数
    
    NetWorkBasic *netWorkBasic=[[NetWorkBasic alloc] init];
    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    
    if (![netWorkBasic isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequestNewBid)]) {
            [self.delegate startRequestNewBid];
        }
        netWorkBasic.dataTask = [netWorkBasic GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self responseSuccessNewBid:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(responseFailure:)]) {
                [self.delegate responseFailure:error];
            }
        }];
    }
}
-(void)responseSuccessNewBid:(id)obj{
    NSDictionary *dataDics = obj;
//    NSLog(@"OPT＝10 获取新标数据:%@",dataDics);
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSMutableArray *arrayNewBid=[NSMutableArray array];
        
        NSArray *dataArr = [dataDics objectForKey:@"list"];
        for(int i=0;i<dataArr.count;i++){
            NSDictionary *item =dataArr[i];
            Investment *bean = [[Investment alloc] init];
            if ([item objectForKey:@"title"] != nil && ![[item objectForKey:@"title"] isEqual:[NSNull null]]) {
                
                bean.title = [item objectForKey:@"title"];
            }
            if ([item objectForKey:@"bid_image_filename"] != nil && ![[item objectForKey:@"bid_image_filename"] isEqual:[NSNull null]]) {
                
                bean.imgurl = [item objectForKey:@"bid_image_filename"];
            }
            
            if ([item objectForKey:@"creditLevel"]  != nil && ![[item objectForKey:@"creditLevel"]  isEqual:[NSNull null]]) {
                
                bean.levelStr = [[item objectForKey:@"creditLevel"] objectForKey:@"image_filename"];
                
            }else{
                bean.levelStr  = @"";
            }
            
            bean.progress = [[item objectForKey:@"loan_schedule"] floatValue];
            bean.amount = [[item objectForKey:@"amount"] floatValue];
            bean.rate = [[item objectForKey:@"apr"] floatValue];
            bean.time = [NSString stringWithFormat:@"%@", [item objectForKey:@"period"]];
            
            bean.deadperiodUnit = [[item objectForKey:@"period_unit"] intValue]; // 期限类型
            bean.repayType = [[item objectForKey:@"repayment_type_id"] intValue];    // 还款方式
            bean.deadType = [[item objectForKey:@"bonus_type"] intValue];     // 投标奖励类型
            bean.bonus = [[item objectForKey:@"bonus"] intValue];
            bean.awardScale = [[item objectForKey:@"award_scale"] intValue];
            bean.status=[[item objectForKey:@"status"] intValue];
            
            //还款时间
            if ([item objectForKey:@"repayment_time"]  != nil && ![[item objectForKey:@"repayment_time"]  isEqual:[NSNull null]]) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"repayment_time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
                NSDate *senddate=[NSDate date];
                //结束时间
                NSDate *endDate =  [dateFormat dateFromString:[dateFormat stringFromDate:date]];
                //当前时间
                NSDate *senderDate = [dateFormat dateFromString:[dateFormat stringFromDate:senddate]];
                //得到相差秒数
                bean.repaytime = (int)[endDate timeIntervalSinceDate:senderDate];
            }else{
                
                bean.repaytime = 0;
            }
            
            //优质债权
            bean.isQuality = [[item objectForKey:@"is_hot"] boolValue];
            bean.unitstr = [NSString stringWithFormat:@"%@",[item objectForKey:@"period_unit"]];
            bean.borrowId = [item objectForKey:@"id"]; //借款标ID
            [arrayNewBid addObject:bean];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessNewBid:withMessge:)]) {
            [self.delegate responseSuccessNewBid:arrayNewBid withMessge:nil];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessNewBid:withMessge:)]) {
            [self.delegate responseSuccessNewBid:nil withMessge:nil];
        }

    }
}
/**
 *  OPT＝11 借款详情
 *
 *  @param borrowId 借款标ID
 */
-(void)requestBorrowDetails:(NSString *)borrowId{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.2借款详情接口[借款详情详细信息]
    [parameters setObject:@"11" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",borrowId] forKey:@"borrowId"];
    if (AppDelegateInstance.userInfo != nil) {
        [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"userId"];
    }
    
    NetWorkBasic *netWorkBasic=[[NetWorkBasic alloc] init];
    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    
    if (![netWorkBasic isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequestBorrowDetail)]) {
            [self.delegate startRequestBorrowDetail];
        }
        netWorkBasic.dataTask = [netWorkBasic GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self responseSuccessBorrowDetail:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(responseFailure:)]) {
                [self.delegate responseFailure:error];
            }
        }];
    }
}
-(void)responseSuccessBorrowDetail:(id)obj{
    NSDictionary *dataDics = obj;
    DLOG(@"OPT＝11 借款详情:%@",dataDics);
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        
    }else {
        
    }
}
/**
 *  OPT＝122 获取首页数据(滚动栏和公告栏)
 */
-(void)requestHomeMessage{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"122" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"" forKey:@"id"]; //栏目id
    
    NetWorkBasic *netWorkBasic=[[NetWorkBasic alloc] init];
    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    
    if (![netWorkBasic isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequestHomeMessage)]) {
            [self.delegate startRequestHomeMessage];
        }
        netWorkBasic.dataTask = [netWorkBasic GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self responseSuccessHomeMessage:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(responseFailure:)]) {
                [self.delegate responseFailure:error];
            }
        }];
    }
}

-(void)responseSuccessHomeMessage:(id)obj{
    NSDictionary *dataDics = obj;
    DLOG(@"OPT＝122 获取首页数据(滚动栏和公告栏):%@",dataDics);
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
        NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cachePath = [path stringByAppendingPathComponent:CacheFileHomeMessage];// 合成归档保存的完整路径
        [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
        
        NSMutableArray *arrayAdMessage=[NSMutableArray array];
        NSMutableArray *arrayAnnuMessage=[NSMutableArray array];
        
        if (![[dataDics objectForKey:@"homeAds"] isEqual:[NSNull null]]) {
            NSArray *dataArr = [dataDics objectForKey:@"homeAds"];
            if ([dataArr count]!=0) {
                for (NSDictionary *item in dataArr)
                {
                    AdvertiseGallery *bean = [[AdvertiseGallery alloc] init];
                    bean.title = [item objectForKey:@"title"];
                    
                    if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]] hasPrefix:@"http"]) {
                        
                        bean.image = [NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]];
                    }else
                    {
                        bean.image = [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"image_filename"]];
                    }
                    
                    bean.urlStr = [item objectForKey:@"url"];
                    bean.tag = [arrayAdMessage count] + 1;
                    [arrayAdMessage addObject:bean];
                }
            }
        }
        
        //公告滚动条.
        if (![[dataDics objectForKey:@"invests"] isEqual:[NSNull null]]) {
            
            NSArray *dataMessageArr = [dataDics objectForKey:@"invests"];
            if ([dataMessageArr count]!=0) {
                for (NSDictionary *item in dataMessageArr)
                {
                    NSString *nameStr = [NSString  stringWithFormat:@"%@",[item objectForKey:@"userName"]];
                    NSString *numStr = [NSString  stringWithFormat:@"%@",[item objectForKey:@"count"]];
                    NSString *aprStr = [NSString  stringWithFormat:@"%@",[item objectForKey:@"apr"]];
                    NSString *amountStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"amount"]];
                    NSString *message = [NSString stringWithFormat:@"会员%@借出¥%@年息%@%%理财%@次",nameStr,amountStr,aprStr,numStr];
                    
                    NSMutableAttributedString *attriMessage=[[NSMutableAttributedString alloc] initWithString:message];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"会员"]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[message rangeOfString:nameStr]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"借出"]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[message rangeOfString:[NSString stringWithFormat:@"¥%@",amountStr]]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"年息"]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[message rangeOfString:[NSString stringWithFormat:@"%@%%",aprStr]]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"理财"]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorRedMain range:[message rangeOfString:[NSString stringWithFormat:@"%@次",numStr]]];
                    [attriMessage addAttribute:NSForegroundColorAttributeName value:ColorTextContent range:[message rangeOfString:@"次"]];
                    [arrayAnnuMessage addObject:attriMessage];
                }
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessHomeMessage:withAnnuMessage:withMessge:)]) {
            [self.delegate responseSuccessHomeMessage:arrayAdMessage withAnnuMessage:arrayAnnuMessage withMessge:nil];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessHomeMessage:withAnnuMessage:withMessge:)]) {
            [self.delegate responseSuccessHomeMessage:nil withAnnuMessage:nil withMessge:[dataDics objectForKey:@"msg"]];
        }
    }
}
/**
 *  OPT=167  注册
 *
 *  @param userName <#userName description#>
 *  @param phone    <#phone description#>
 */
-(void)requestRegisterWithUserName:(NSString *)userName  withPhone:(NSString *)phone{
    //暂时先用登录接口，后面要新增判断账号是否存在接口
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"176" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:userName forKey:@"name"];
    [parameters setObject:phone forKey:@"cellPhone"];
    
    NetWorkBasic *netWorkBasic=[[NetWorkBasic alloc] init];
    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    
    if (![netWorkBasic isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequestRegister)]) {
            [self.delegate startRequestRegister];
        }
        netWorkBasic.dataTask = [netWorkBasic GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self responseSuccessRegister:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(responseFailure:)]) {
                [self.delegate responseFailure:error];
            }
        }];
    }
}

-(void)responseSuccessRegister:(id)obj{
    NSDictionary *dics = obj;
    DLOG(@"OPT=167  注册:%@",dics);
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessRegister:withMessage:)]) {
            [self.delegate responseSuccessRegister:YES withMessage:nil];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseSuccessRegister:withMessage:)]) {
            [self.delegate responseSuccessRegister:nil withMessage:[obj objectForKey:@"msg"]];
        }
    }
}
@end
