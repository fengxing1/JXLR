//
//  NetWorkRequestManager.h
//  SP2P_6.1
//
//  Created by tusm on 16/3/26.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NetWorkRequestManagerDeletage<NSObject>
@optional
-(void)networkError;
-(void)responseFailure:(NSError *)error;
/**
 *  OPT=1  登录
 */
-(void)startRequestLogin;
-(void)responseSuccessLogin:(UserInfo *)userInfo withMessage:(NSString *)message;
/**
 *  OPT=2  注册信息
 */
-(void)startRequestRegisterMessage;
-(void)responseSuccessRegisterMessageUserID:(NSString *)userId withMessage:message;
/**
 *  OPT=4  获取验证码
 */
-(void)startRequestGetVerification;
-(void)responseSuccessGetVerification:(BOOL)isVerification  withMessage:(NSString *)message;
/**
 *  OPT=5  验证验证码
 */
-(void)startRequestVerificationIsTrue;
-(void)responseSuccessVerificationIsTrue:(NSString *)userId  withMessage:(NSString *)message;
/**
 *  OPT=6 重置密码
 */
-(void)startRequestChangePassword;
-(void)responseSuccessChangePassword:(BOOL)isSuccess  withMessage:(NSString *)message;
/**
 *  OPT＝10 获取新标数据
 */
-(void)startRequestNewBid;
-(void)responseSuccessNewBid:(NSMutableArray *)newBids withMessge:(NSString *)message;
/**
 *  OPT＝11 借款详情
 */
-(void)startRequestBorrowDetail;
/**
 *  OPT＝122 获取首页数据
 */
-(void)startRequestHomeMessage;
-(void)responseSuccessHomeMessage:(NSMutableArray *)arrayAdMessage  withAnnuMessage:(NSMutableArray *)arrayAnnuMessage withMessge:(NSString *)message;
/**
 *  OPT=167  注册
 */
-(void)startRequestRegister;
-(void)responseSuccessRegister:(BOOL)isRegister  withMessage:(NSString *)message;


@end
@interface NetWorkRequestManager : NSObject
@property(nonatomic,assign)id<NetWorkRequestManagerDeletage> delegate;

/**
 *  初始化网络管理类
 */
+(id)instanceRequest;

/**
 *  OPT=1  登录
 *
 *  @param account    <#account description#>
 *  @param password   <#password description#>
 *  @param deviceType <#deviceType description#>
 */
-(void)requestLoginWithAccount:(NSString *)account  withPassword:(NSString *)password withDeviceType:(NSString *)deviceType;
/**
 *  OPT=2  注册信息
 *
 *  @param userName   <#userName description#>
 *  @param password   <#password description#>
 *  @param phone      <#phone description#>
 *  @param verify     <#verify description#>
 *  @param refereeNum <#refereeNum description#>
 */
-(void)requestRegisterMessage:(NSString *)userName withPassword:(NSString *)password widthPhone:(NSString *)phone withVerify:(NSString *)verify withRefereeNum:(NSString *)refereeNum;
/**
 *  OPT=4  获取验证码
 *
 *  @param phone <#phone description#>
 */
-(void)requestGetVerification:(NSString *)phone;
/**
 *  OPT=5 校验请求
 *
 *  @param phone
 */
-(void)requestVerificationIsTrue:(NSString *)phone withVerification:(NSString *)verification;
/**
 *  OPT=6 重置密码
 *
 *  @param password
 *  @param phone
 */

-(void)requestChangePassword:(NSString *)password withPhone:(NSString *)phone;
/**
 *  OPT＝10 获取新标数据
 *
 *  @param apr    <#apr description#>
 *  @param amount <#amount description#>
 *  @param page   <#page description#>
 */
-(void)requestNewBidWithApr:(NSString *)apr withAmount:(NSString *)amount withPage:(int)page;
/**
 *  OPT＝11 借款详情
 *
 *  @param borrowId 借款标ID
 */
-(void)requestBorrowDetails:(NSString *)borrowId;
/**
 *  OPT＝122 获取首页数据
 */
-(void)requestHomeMessage;
/**
 *  OPT=167  注册
 *
 *  @param userName <#userName description#>
 *  @param phone    <#phone description#>
 */
-(void)requestRegisterWithUserName:(NSString *)userName  withPhone:(NSString *)phone;
@end
