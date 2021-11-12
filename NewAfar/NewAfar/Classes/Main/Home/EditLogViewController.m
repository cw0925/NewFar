//
//  EditLogViewController.m
//  NewAfar
//
//  Created by cw on 17/2/8.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "EditLogViewController.h"
#import "ShowActionSheet.h"
#import "AlbumViewController.h"
#import "GetAlbumPhotos.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "StaffViewController.h"

#import "StaffModel.h"

#define Padding 10
#define BtnW (ViewWidth-70)/4

#define ViewW (ViewWidth-70)/6

@interface EditLogViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *photoArr;
@property(nonatomic,copy)NSMutableArray *sumArr;
@property(nonatomic,copy)NSMutableArray *indexpathArr;
@property(nonatomic,retain)UITextView *content;

@property(nonatomic,copy)NSMutableArray *retArr;

@property(nonatomic,copy)NSArray *statueArr;

@end

@implementation EditLogViewController
{
    NSString *module;
    UIImagePickerController *_imagePickerController;
    UIView *bgView;
    
    UIButton *send;
    UIView *staffView;
    
    UIView *sendView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"编辑日志" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initTopUI];
    [self initUI];
    if ([_c_newid isEqualToString:@""]) {
        [self sendRequestModuleData];
    }else{
        module = _c_newid;
    }
    
    NSLog(@"%@",_c_newid);
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    [super customNavigationBar:title hasLeft:isLeft hasRight:isRight withRightBarButtonItemImage:image];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 60, 30);
    right.titleLabel.font = [UIFont systemFontWithSize:14];
    [right setTitleColor:RGBColor(18,184,246) forState:UIControlStateNormal];
    [right addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"保存" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
}
- (void)backPage{
    [self dismissViewControllerAnimated:YES completion:^{
        _content = nil;
    }];
}
#pragma mark - 提交
- (void)saveClick:(UIButton *)sender{
    [self.view endEditing:YES];
    if (([self.content.text isEqualToString:@""]||[self.content.text isEqualToString:@"把今天的工作记录一下吧！"])&&_dataArr.count == 0) {
        [self.view makeToast:@"请输入要发表的日志内容！"];
    }else if (_dataArr.count>0){//有图
        [MBProgressHUD showMessag:@"正在上传图片..." toView:self.view];
        NSLog(@"%@",self.dataArr);
        [NetRequest uploadImage:self.dataArr withFileName:[NSString stringWithFormat:@"%@g1g%@",[userDefault valueForKey:@"name"],module] success:^(id responseObject) {
            [self sendRequestAddLogData];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else if (!([self.content.text isEqualToString:@""]||[self.content.text isEqualToString:@"把今天的工作记录一下吧！"])&&_dataArr.count==0){//只发送文字
        [self sendRequestAddLogData];
    }
}
- (void)initTopUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    bgView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:bgView];
    
    [bgView addSubview:self.content];
    
    if (![_log_content isEqualToString:@""]) {
        self.content.text = _log_content;
        //self.content.placeholder = @"";
    }else{
        self.content.placeholder = @"把今天的工作记录一下吧！";
    }
}
- (UITextView *)content{
    if (!_content) {
        _content = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth-20, 100)];
        _content.delegate = self;
    }
    return _content;
}
#pragma mark - 选择图片
- (void)initUI
{
    NSInteger imgCount = self.dataArr.count;

    if (imgCount == 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(Padding, 100+Padding, BtnW, BtnW);
        [btn setBackgroundImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }else if (imgCount == 6){
        for (NSInteger i =0; i<imgCount; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(((i%4)+1)*Padding+(i%4)*BtnW, 100+((i/4)+1)*Padding+(i/4)*BtnW, BtnW, BtnW);
            [btn setBackgroundImage:_dataArr[i] forState:UIControlStateNormal];
            [bgView addSubview:btn];
        }
    }else if(imgCount <6){
        for (NSInteger i =0; i<imgCount+1; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(((i%4)+1)*Padding+(i%4)*BtnW, 100+((i/4)+1)*Padding+(i/4)*BtnW, BtnW, BtnW);
            if (i== imgCount) {
                [btn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:_dataArr[i] forState:UIControlStateNormal];
            }
            [bgView addSubview:btn];
        }
    }
    CGFloat height = (imgCount/4+1)*BtnW + (imgCount/4+2)*Padding+100;
    bgView.frame = CGRectMake(10,10+NVHeight, ViewWidth-20, height);
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = RGBColor(211, 212, 213).CGColor;
    
    if (sendView) {
        [sendView setFrame:CGRectMake(10, CGRectGetMaxY(bgView.frame)+10, ViewWidth-20, 30)];
    }else{
        sendView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bgView.frame)+10, ViewWidth-20, 30)];
        //sendView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:sendView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        label.text = @"抄送(点击图像删除)";
        label.textColor = RGBColor(18,184,246);
        label.font = [UIFont systemFontWithSize:14];
        //label.textAlignment = NSTextAlignmentCenter;
        [sendView addSubview:label];
        
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth-20-20, 5, 20, 20)];
        imv.image = [UIImage imageNamed:@"calendar_right"];
        [sendView addSubview:imv];
    }
    sendView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendClick:)];
    [sendView addGestureRecognizer:gesture];
}
- (void)addClick:(UIButton *)sender{
    [ShowActionSheet showActionSheetToController:self takeBlock:^{
        [self selectImageFromCamera];
    } phoneBlock:^{
        AlbumViewController *album = [[AlbumViewController alloc]init];
        [album returnSelImg:^(NSArray *selArr, NSArray *indexArr) {
            [self.dataArr addObjectsFromArray:selArr];
            [self initUI];
            NSLog(@"返回后的总张数：%lu--%@---%@",(unsigned long)self.dataArr.count,selArr,self.dataArr);
        }];
        if (self.dataArr.count>0) {
            album.sum = self.dataArr.count;
        }
        NSLog(@"%lu",(unsigned long)self.dataArr.count);
        [self.navigationController pushViewController:album animated:YES];
    }];
}
- (void)initStaffView:(NSArray *)selArr{
    if (staffView) {
      for (UIView *view in staffView.subviews) {
              [view removeFromSuperview];
        }
    }else{
        staffView = [UIView new];
        [self.view addSubview:staffView];
    }
    staffView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(sendView,10).rightSpaceToView(self.view,0);
    
    UIView *lastView = [[UIView alloc]init];
    for (NSInteger i = 0; i<selArr.count; i++) {
        StaffModel *model = selArr[i];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10*(i%6+1)+ViewW*(i%6), 10*(i/6+1)+(ViewW+30)*(i/6), ViewW, ViewW+30)];
        view.tag = i+1;
        [staffView addSubview:view];
        //添加删除操作
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [view addGestureRecognizer:gesture];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewW, ViewW)];
        if ([model.c_addresszc isEqualToString:@""]||[model.c_addresszc isEqualToString:@"0"]) {
            icon.image = [UIImage imageNamed:@"avatar_zhixing"];
            icon.userInteractionEnabled = YES;
        }else{
            [icon sd_setImageWithURL:[NSURL URLWithString:model.c_addresszc] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                icon.image = [image circleImage];
            }];
        }
        [view addSubview:icon];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, ViewW, ViewW, 30)];
        name.text = model.c_real_name;
        name.textAlignment = NSTextAlignmentCenter;
        name.font = [UIFont systemFontWithSize:12];
        name.userInteractionEnabled = YES;
        [view addSubview:name];
        
        if (i==selArr.count-1) {
            lastView = view;
        }
    }
    [staffView setupAutoHeightWithBottomView:lastView bottomMargin:10];
}
//删除选择的联系人
- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    NSLog(@"删除联系人");
    NSInteger index = gesture.view.tag;
    [self.retArr removeObjectAtIndex:index-1];
    [self initStaffView:self.retArr];
}
//抄送
- (void)sendClick:(UITapGestureRecognizer *)sender{
    if (self.retArr.count >0) {
        [self.retArr removeAllObjects];
    }
    StaffViewController *staff = [[StaffViewController alloc]init];
    if (self.statueArr.count > 0) {
        staff.indexArr = self.statueArr;
    }
    [staff returnName:^(NSArray *selectArr, NSArray *statueArr) {
        if (selectArr.count >0) {
            [self.retArr addObjectsFromArray:selectArr];
            [self initStaffView:_retArr];
            self.statueArr = statueArr;
        }
    }];
    
    PushController(staff)
}
#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self.navigationController presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    //[self.dataArr insertObject:image atIndex:0];
    UIImage *takeImg = [self OriginImage:image scaleToSize:CGSizeMake(300, 300)];
   [self.dataArr addObject:takeImg];
    [self initUI];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
//图片处理，图片压缩
- (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);  //你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回已变图片
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    NSLog(@"");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestAddLogData
{
    if ([_content.text rangeOfString:@" "].length>0) {
        _content.text = [_content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    NSMutableString *strM = [NSMutableString string];
    if (self.retArr.count>0) {
        for (StaffModel *model  in self.retArr) {
            [strM appendFormat:@"%@.",model.c_no];
        }
        [strM deleteCharactersInRange:NSMakeRange(strM.length-1, 1)];
    }
    NSLog(@"%@",strM);
    //<root><api><module>1501</module><type>0</type><query>{content=6666,title=,receiver=000015.000030,time=2017-04-11,maxid=1862131491887415,photo=}</query></api><user><company></company><customeruser>13140015925</customeruser><phoneno>hhhhhhhhtt</phoneno></user></root>
    NSString *str = @"<root><api><module>1501</module><type>0</type><query>{title=,content=%@,receiver=%@,time=%@,photo=,maxid=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    
    NSString *string = [NSString stringWithFormat:str,_content.text,strM,_date,module,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"保存成功！"]) {
                self.block(element.stringValue);
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }else{
                [self.view makeToast:element.stringValue];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//请求图片存储的模块
- (void)sendRequestModuleData
{
    NSString *str = @"<root><api><module>1706</module><type>0</type><query>{type=1}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>gb</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//maxid" error:nil];
                for (DDXMLElement *item in rowArr) {
                    module = item.stringValue;
                    NSLog(@"%@",module);
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}
- (NSMutableArray *)sumArr
{
    if (!_sumArr) {
        _sumArr = [NSMutableArray array];
    }
    return _sumArr;
}
- (NSMutableArray *)indexpathArr
{
    if (!_indexpathArr) {
        _indexpathArr = [NSMutableArray array];
    }
    return _indexpathArr;
}
- (NSMutableArray *)retArr
{
    if (!_retArr) {
        _retArr = [NSMutableArray array];
    }
    return _retArr;
}
- (void)dealloc
{
    _content = nil;
    _content.delegate = nil;
}
#pragma mark - 竖屏设置
- (BOOL)shouldAutorotate
{
    return NO;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
