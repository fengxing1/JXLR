//
//  ViewTransferContent.h
//  SP2P_6.1
//
//  Created by tusm on 16/3/24.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditorTransfer.h"
#define HeightViewTransferContent (WidthScreen/2.4)

@interface ViewTransferContent : UIView
@property(nonatomic,strong)CreditorTransfer *creditorTransfer;
@property(nonatomic,strong)UIButton *btnInvest;
@end