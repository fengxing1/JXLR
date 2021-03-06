//
//  ChangeIconViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  更换头像

#import "ChangeIconViewController.h"


#import "ColorTools.h"
#import "UserInfo.h"


@interface ChangeIconViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,HTTPClientDelegate>

@property (nonatomic, strong) UIButton *iconView;
@property (nonatomic,strong) UIButton *changeBtn;
@property (nonatomic,strong) UIButton *yesBtn;
@property (nonatomic, copy) NSString *logoStr;
@property (nonatomic)UIImage *hearImg;
@property(nonatomic ,strong) NetWorkClient *requestClient;


@end

@implementation ChangeIconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initData
{
    _logoStr = AppDelegateInstance.userInfo.userImg;
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"更换头像";
}

/**
 * 初始化内容详情
 */
#pragma mark 初始化内容
- (void)initContentView
{
     //头像
    _iconView = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconView.frame = CGRectMake(75, 75, WidthScreen-75*2, WidthScreen-75*2);
    [_iconView.layer setMasksToBounds:YES];
    [_iconView.layer setCornerRadius:(WidthScreen-75*2)/2]; //设置矩形四个圆角半径
    [_iconView addTarget:self action:@selector(changeIconClick) forControlEvents:UIControlEventTouchUpInside];
//    [_iconView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_logoStr]];
    [_iconView sd_setBackgroundImageWithURL:[NSURL URLWithString:_logoStr]forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"news_image_default"]];
    [self.view addSubview:_iconView];// 登陆头像
    
    _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBtn.frame = CGRectMake(self.view.frame.size.width * 0.5 - 75, CGRectGetMaxY(_iconView.frame)+SpaceMediumSmall, 150, 35);
    _changeBtn.backgroundColor = GreenColor;
    [_changeBtn setTitle:@"选择图片" forState:UIControlStateNormal];
    _changeBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    [_changeBtn.layer setMasksToBounds:YES];
    [_changeBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [_changeBtn addTarget:self action:@selector(changeIconClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeBtn];
    
    
    _yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _yesBtn.frame = CGRectMake(self.view.frame.size.width * 0.5 - 75, CGRectGetMaxY(_changeBtn.frame)+SpaceMediumSmall, 150, 35);
    _yesBtn.backgroundColor = ColorCheckButtonGray;  //不可用背景
    [_yesBtn setTitle:@"上 传" forState:UIControlStateNormal];
    _yesBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    [_yesBtn.layer setMasksToBounds:YES];
    [_yesBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [_yesBtn addTarget:self action:@selector(yesCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yesBtn];
}

#pragma mark CLick 上传按钮
- (void)changeIconClick
{
    //DLOG(@"上传图片按钮");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"从手机相册选择"];
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showInView:self.view];
}


#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    if (buttonIndex == 0)//照相机
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:@"该设备没有摄像头"];
            
        }
    }
    if (buttonIndex == 1)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    if (buttonIndex == 2)
    {
        
    }
}

#pragma mark
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _yesBtn.backgroundColor = PinkColor;
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)saveImage:(UIImage *)image
{
    [_iconView setImage:image forState:UIControlStateNormal];
    _hearImg = image;
}


#pragma mark 确定按钮
- (void)yesCLick
{
  
    if (_hearImg!= nil) {

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
        [parameters setObject:@"1" forKey:@"type"];

        NSData *imageData = UIImageJPEGRepresentation(_hearImg, 0.5);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
        [manager POST:[NSString stringWithFormat:@"%@%@",Baseurl,@"/app/uploadUserPhoto"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //上传时使用当前的系统事件作为文件名
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
            
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            //
            
            
            [formData appendPartWithFileData:imageData
                                        name:@"imgFile"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if([[dic objectForKey:@"error"] integerValue] == -1)
            {
                [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"msg"]];
                
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"filename"]] hasPrefix:@"http"]) {
                    AppDelegateInstance.userInfo.userImg =[NSString stringWithFormat:@"%@",[dic objectForKey:@"filename"]] ;
                    [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:[NSString stringWithFormat:@"%@", [dic objectForKey:@"filename"]]];
                }else
                {
                    
                    AppDelegateInstance.userInfo.userImg =[NSString stringWithFormat:@"%@%@", Baseurl, [dic objectForKey:@"filename"]] ;
                    [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:[NSString stringWithFormat:@"%@%@", Baseurl, [dic objectForKey:@"filename"]]];
                }
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                    
                    
                    [self dismissViewControllerAnimated:YES completion:^(){}];
                    
                });
                
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
            }
            
            
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"update" object:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    }
   
}



#pragma HTTPClientDelegate 网络数据回调代理


// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"error"]] isEqualToString:@"-1"]) {
            
            
            
        
    }
    else{
        
        //DLOG(@"返回失败===========%@",[obj objectForKey:@"msg"]);
         [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
    }


}


// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{

    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}
// 无可用的网络
-(void) networkError
{
    
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            // 记录 退出状态
            if (AppDelegateInstance.userInfo != nil) {
                AppDelegateInstance.userInfo.isLogin = 0;
                
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"update" object:nil];
                [self dismissViewControllerAnimated:YES completion:^(){}];
            }
        }
            break;
        case 1:
        
            break;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
