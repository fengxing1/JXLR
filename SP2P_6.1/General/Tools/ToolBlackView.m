//
//  ToolBlackView.m
//  SP2P_6.1
//
//  Created by 邹显 on 16/4/16.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ToolBlackView.h"
#import "ToolButton.h"
#import "ModelRemoteNotification.h"

#define WidthRemind (WidthScreen-SpaceMediumBig*2)
#define HeightRemain (WidthRemind*0.57)
#define HeightTop (HeightRemain*0.26)
#define HeightContent (HeightRemain*0.37)
#define WHImageRight (HeightTop*0.58)
#define WidthButton 90
#define SpaceButton  15
#define HeightButton (HeightContent-SpaceButton*2)

//更新提示框
#define WidthUpdateBg (WidthScreen*(500.0/720))
#define HeightUpdateBg (WidthUpdateBg*(643.0/500))
#define PointYContent (HeightUpdateBg*(350.0/643))
#define HeightUpdateContent (HeightUpdateBg*(110.0/643))
#define PointYButton  (HeightUpdateBg-HeightUpdateBg*(110.0/643))
#define HeightUpdateButton (HeightUpdateBg*(60.0/643))
#define WidthUpdateButton (WidthUpdateBg*(270.0/500))
#define WidthCloseButton (WidthUpdateBg*(49.0/500))
#define PointYCloseButton (HeightUpdateBg*(43.0/643)-WidthCloseButton/3)

//推送提示框
#define HeightTitleImage  (HeightTop*2)
#define WidthTitleImage   (HeightTitleImage*2.7)

@implementation ToolBlackView

+(UIView *)createBlackView{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightScreen)];
    view.backgroundColor=ColorBlackView;
    
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到窗口
    [window addSubview:view];
    return view;
}

//两个按钮的提示框
+(UIView *)createRemindWithTitle:(NSString *)title withContent:(NSString *)content withLeftText:(NSString *)left withRightText:(NSString  *)right withTarget:(id)target  withActionLeft:(SEL)actionLeft withActionRight:(SEL)actionRight{
    UIView *viewBlack=[ToolBlackView createBlackView];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake((WidthScreen-WidthRemind)/2, (HeightScreen-HeightRemain)/2, WidthRemind, HeightRemain)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=4.0;
    view.layer.masksToBounds=YES;
    [viewBlack addSubview:view];
    
    
    UIView *viewTop=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WidthRemind, HeightTop)];
    viewTop.backgroundColor=ColorBlackTop;
    [view addSubview:viewTop];
    
    float widthTitle=[SizeTools getStringWidth:title Font:FontNavTitle];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake((WidthRemind-widthTitle-WHImageRight)/2, (HeightTop-WHImageRight)/2, WHImageRight, WHImageRight)];
    [imageView setImage:[UIImage imageNamed:@"loan_pass"]];
    [viewTop addSubview:imageView];
    
    UILabel *labelTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 0, widthTitle, HeightTop)];
    [labelTitle setText:title];
    labelTitle.font=FontNavTitle;
    labelTitle.textColor=ColorTextContent;
    [viewTop addSubview:labelTitle];
    
    UILabel *labContent=[[UILabel alloc] initWithFrame:CGRectMake(SpaceBig, CGRectGetMaxY(viewTop.frame), WidthRemind-SpaceBig*2, HeightContent)];
    labContent.textAlignment=NSTextAlignmentCenter;
    labContent.textColor=ColorTextContent;
    labContent.text=content;
    labContent.font=FontTextTitle;
    labContent.numberOfLines=0;
    [view addSubview:labContent];
    
    UIButton *btnLeft=[ToolButton CreateMainButton:CGRectMake(WidthRemind/2-SpaceMediumBig-WidthButton, CGRectGetMaxY(labContent.frame)+SpaceButton, WidthButton, HeightButton) withTitle:left withColor:ColorTextVice withTarget:target withAction:actionLeft];
    [view addSubview:btnLeft];
    
    UIButton *btnRight=[ToolButton CreateMainButton:CGRectMake(WidthRemind/2+SpaceMediumBig, CGRectGetMinY(btnLeft.frame), WidthButton, HeightButton) withTitle:right  withTarget:target withAction:actionRight];
    [view addSubview:btnRight];
    
    return viewBlack;
}

//单个按钮提示框
+(UIView *)createRemindWithTitle:(NSString *)title withContent:(NSString *)content withButtonText:(NSString *)buttonText withTarget:(id)target  withAction:(SEL)action{
    UIView *viewBlack=[ToolBlackView createBlackView];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake((WidthScreen-WidthRemind)/2, (HeightScreen-HeightRemain)/2, WidthRemind, HeightRemain)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=4.0;
    view.layer.masksToBounds=YES;
    [viewBlack addSubview:view];
    
    
    UIView *viewTop=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WidthRemind, HeightTop)];
    viewTop.backgroundColor=ColorBlackTop;
    [view addSubview:viewTop];
    
    float widthTitle=[SizeTools getStringWidth:title Font:FontNavTitle];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake((WidthRemind-widthTitle-WHImageRight)/2, (HeightTop-WHImageRight)/2, WHImageRight, WHImageRight)];
    [imageView setImage:[UIImage imageNamed:@"loan_pass"]];
    [viewTop addSubview:imageView];
    
    UILabel *labelTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 0, widthTitle, HeightTop)];
    [labelTitle setText:title];
    labelTitle.font=FontNavTitle;
    labelTitle.textColor=ColorTextContent;
    [viewTop addSubview:labelTitle];
    
    UILabel *labContent=[[UILabel alloc] initWithFrame:CGRectMake(SpaceBig, CGRectGetMaxY(viewTop.frame), WidthRemind-SpaceBig*2, HeightContent)];
    labContent.textAlignment=NSTextAlignmentCenter;
    labContent.textColor=ColorTextContent;
    labContent.text=content;
    labContent.font=FontTextTitle;
    labContent.numberOfLines=0;
    [view addSubview:labContent];
    
    UIButton *button=[ToolButton CreateMainButton:CGRectMake(SpaceMediumBig, CGRectGetMaxY(labContent.frame)+SpaceButton, CGRectGetWidth(view.frame)-SpaceMediumBig*2, HeightButton) withTitle:buttonText withTarget:target withAction:action];
    [view addSubview:button];
    
    return viewBlack;
}

//获取推动提示框
+(UIView *)createRemindWithContent:(NSString *)content withTarget:(id)target  withAction:(SEL)action  withCloseAction:(SEL)actionClose{
    UIView *viewBlack=[ToolBlackView createBlackView];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake((WidthScreen-WidthUpdateBg)/2, (HeightScreen-HeightUpdateBg)/2, WidthUpdateBg, HeightUpdateBg)];
    [imageView setImage:[UIImage imageNamed:@"update_bg"]];
    [viewBlack addSubview:imageView];
    imageView.userInteractionEnabled=NO;
    
    UILabel *labContent=[[UILabel alloc] initWithFrame:CGRectMake(SpaceBig, PointYContent, CGRectGetWidth(imageView.frame)-SpaceBig*2,HeightUpdateContent)];
    labContent.textAlignment=NSTextAlignmentLeft;
    labContent.textColor=ColorBigContentText;
    labContent.font=FontTextSmall;
    labContent.numberOfLines=0;
    labContent.text=content;
    [imageView addSubview:labContent];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMinX(imageView.frame)+(WidthUpdateBg-WidthUpdateButton)/2,CGRectGetMinY(imageView.frame)+ PointYButton, WidthUpdateButton, HeightUpdateButton);
    [button setBackgroundImage:[ImageTools imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[ImageTools imageWithColor:[UIColor whiteColor] withAlpha:0.2] forState:UIControlStateHighlighted];
    [button setTitle:@"立即更新" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = FontMedium;
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:HeightUpdateButton/2];
    button.layer.borderColor=ColorLine.CGColor;
    button.layer.borderWidth=1;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [viewBlack addSubview:button];
    
    UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonClose.frame = CGRectMake(CGRectGetMaxX(imageView.frame)-WidthCloseButton/2, CGRectGetMinY(imageView.frame)+PointYCloseButton, WidthCloseButton, WidthCloseButton);
    [buttonClose setBackgroundImage:[UIImage imageNamed:@"close_click"] forState:UIControlStateNormal];
    [buttonClose setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateHighlighted];
    [buttonClose addTarget:target action:actionClose forControlEvents:UIControlEventTouchUpInside];
    [viewBlack addSubview:buttonClose];
    
    return viewBlack;
}

//单个按钮提示框
+(UIView *)createRemoteNotificationWithModel:(ModelRemoteNotification *)model withButtonText:(NSString *)buttonText withTarget:(id)target  withAction:(SEL)action  withCloseAction:(SEL)actionClose{
    UIView *viewBlack=[ToolBlackView createBlackView];
    
    UIView *viewContent=[[UIView alloc] initWithFrame:CGRectMake(SpaceBig, 0, WidthScreen-SpaceBig*2, 0)];
    [viewBlack addSubview:viewContent];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, HeightTop, WidthScreen-SpaceBig*2, 0)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=4.0;
    view.layer.masksToBounds=YES;
    [viewContent addSubview:view];
    
    if(model.remoteNotificationType==RemoteNotificationTypeNewBidOne||model.remoteNotificationType==RemoteNotificationTypeNewBidTwo||model.remoteNotificationType==RemoteNotificationTypeActivite){
        UIImageView *imageViewTitle=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(view.frame)-WidthTitleImage)/2, 0, WidthTitleImage, HeightTitleImage)];
        imageViewTitle.image=[UIImage imageNamed:[NSString stringWithFormat:@"push%ld",(long)model.remoteNotificationType]];
        [viewContent addSubview:imageViewTitle];
    }else{
        UIView *viewTop=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WidthRemind, HeightTop)];
        viewTop.backgroundColor=ColorBlackTop;
        [view addSubview:viewTop];
        
        float widthTitle=[SizeTools getStringWidth:model.title Font:FontNavTitle];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake((WidthRemind-widthTitle-WHImageRight)/2, (HeightTop-WHImageRight)/2, WHImageRight, WHImageRight)];
        [imageView setImage:[UIImage imageNamed:@"loan_pass"]];
        [viewTop addSubview:imageView];
        
        UILabel *labelTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 0, widthTitle, HeightTop)];
        [labelTitle setText:model.title];
        labelTitle.font=FontNavTitle;
        labelTitle.textColor=ColorTextContent;
        [viewTop addSubview:labelTitle];
    }
    
    UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonClose setBackgroundImage:[UIImage imageNamed:@"close_click"] forState:UIControlStateNormal];
    [buttonClose setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateHighlighted];
    [buttonClose addTarget:target action:actionClose forControlEvents:UIControlEventTouchUpInside];
    [viewBlack addSubview:buttonClose];
    
    NSString *strContent=model.descriptionStr;
    CGFloat heightContent=[SizeTools getStringHeight:model.descriptionStr Font:FontTextTitle constrainedToSize:CGSizeMake(WidthRemind, 900)];
    if(model.remoteNotificationType==RemoteNotificationTypeNewBidOne){
        strContent=[NSString stringWithFormat:@"项目:%@\n年化利率:%@\n借款期限:%@\n",model.newbidtitleone,model.rateone,model.dateone];
        heightContent=[SizeTools getStringHeight:strContent Font:FontTextTitle constrainedToSize:CGSizeMake(WidthRemind, 900)];
        heightContent=heightContent+SpaceButton*1.4;
    }else if(model.remoteNotificationType==RemoteNotificationTypeNewBidTwo){
        strContent=[NSString stringWithFormat:@"项目:%@\n年化利率:%@\n借款期限:%@\n\n项目:%@\n年化利率:%@\n借款期限:%@",model.newbidtitleone,model.rateone,model.dateone,model.newbidtitletwo,model.ratetwo,model.datetwo];
        heightContent=[SizeTools getStringHeight:strContent Font:FontTextTitle constrainedToSize:CGSizeMake(WidthRemind, 900)];
        heightContent=heightContent+SpaceButton*2;
    }else{
        heightContent=heightContent+SpaceButton*2.4;
    }
    
    UILabel *labContent=[[UILabel alloc] initWithFrame:CGRectMake(SpaceBig, HeightTop+SpaceMediumSmall, WidthRemind-SpaceBig*2, heightContent)];
    labContent.textColor=ColorTextVice;
    labContent.text=strContent;
    labContent.font=FontTextTitle;
    labContent.numberOfLines=0;
    [view addSubview:labContent];
    
    UIButton *button=[ToolButton CreateMainButton:CGRectMake(SpaceMediumBig, CGRectGetMaxY(labContent.frame), CGRectGetWidth(view.frame)-SpaceMediumBig*2, HeightButton) withTitle:buttonText withTarget:target withAction:action];
    [view addSubview:button];
    
    view.frame=CGRectMake(0, HeightTop, CGRectGetWidth(viewContent.frame), CGRectGetMaxY(button.frame)+SpaceMediumBig);
    viewContent.frame=CGRectMake(CGRectGetMinX(viewContent.frame), (HeightScreen-CGRectGetMaxY(view.frame))/2, CGRectGetWidth(viewContent.frame), CGRectGetMaxY(view.frame));
    buttonClose.frame = CGRectMake(CGRectGetMaxX(viewContent.frame)-WidthCloseButton/2,CGRectGetMinY(viewContent.frame)+HeightTop-WidthCloseButton/2, WidthCloseButton, WidthCloseButton);
    
    return viewBlack;
}
@end
