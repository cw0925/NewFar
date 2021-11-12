//
//  CarryViewController.m
//  NewAfar
//
//  Created by cw on 16/12/12.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "CarryViewController.h"
#import "ShowActionSheet.h"
#import "AlbumViewController.h"
#import "JurisdictionCell.h"
#import "LocationViewController.h"
#import "JurisdictionViewController.h"
#import "GetAlbumPhotos.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define Padding 10
#define BtnW (ViewWidth-70)/4

@interface CarryViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *indexpathArr;

@end

@implementation CarryViewController
{
    UITableView *carryTable;
    UIImagePickerController *_imagePickerController;
    UIView *bgView;
    UITextView *content;
    NSString *user_location;
    NSString *limit;
    
    NSString *module;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"发表职场" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self initAddImageView];
    [self initTableView];
    
    [self sendRequestModuleData];
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    [super customNavigationBar:title hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 45, 30);
    right.titleLabel.font = [UIFont systemFontWithSize:14];
    [right setTitle:@"发布" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(publishWorkplace) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
}
#pragma mark -  发布职场圈
- (void)publishWorkplace
{
    [self.view endEditing:YES];
    if (([content.text isEqualToString:@""]||[content.text isEqualToString:@"记录您的心情或感受吧！"])&&_dataArr.count==0) {//发送内容为空
        [self.view makeToast:@"请输入要发表的内容！"];
    }else if (_dataArr.count>0){//只发送图片
        [MBProgressHUD showMessag:@"上传图片中..." toView:self.view];
        [NetRequest uploadImage:self.dataArr withFileName:[NSString stringWithFormat:@"%@g0g%@",[userDefault valueForKey:@"name"],module] success:^(id responseObject) {
            [self sendRequestPublicData];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else if (!([content.text isEqualToString:@""]||[content.text isEqualToString:@"记录您的心情或感受吧！"])&&_dataArr.count==0){//只发送文字
        [self sendRequestPublicData];
    }
}
- (void)backPage
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    limit = @"0";
    user_location = @"";
    
    bgView = [[UIView alloc]initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    content = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 100)];
    content.placeholder = @"记录您的心情或感受吧！";
    content.font = [UIFont systemFontWithSize:12];
    content.delegate = self;
    [bgView addSubview:content];
}
- (void)initAddImageView
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
    bgView.frame = CGRectMake(0, NVHeight, ViewWidth, 3*Padding+2*BtnW+100);
}
- (void)initTableView
{
    carryTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), ViewWidth, ViewHeight-CGRectGetMaxY(bgView.frame)) style:UITableViewStyleGrouped];
    carryTable.sectionFooterHeight = 5;
    carryTable.sectionHeaderHeight = 5;
    carryTable.delegate = self;
    carryTable.dataSource = self;
    //carryTable.scrollEnabled = NO;
    [self.view addSubview:carryTable];
    
    [carryTable registerNib:[UINib nibWithNibName:@"JurisdictionCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ViewWidth, 0.1)];
    carryTable.tableHeaderView = head;
}
#pragma mark - tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JurisdictionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.title.font = [UIFont systemFontWithSize:14];
    cell.text.font = [UIFont systemFontWithSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.pic.image = [UIImage imageNamed:@"location"];
        cell.title.text = @"所在位置";
        cell.text.text = @"";
    }else
    {
        cell.pic.image = [UIImage imageNamed:@"jurisdiction"];
        cell.title.text = @"权限设置";
        cell.text.text = @"公开";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//定位
        LocationViewController *location = [[LocationViewController alloc]init];
        [location returnText:^(NSString *showText) {
            JurisdictionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.title.text = showText;
            user_location = showText;
        }];
        PushController(location)
    }else//权限 0-公开 1- 私密
    {
        JurisdictionViewController *jurisdiction = [[JurisdictionViewController alloc]init];
        [jurisdiction returnLimit:^(NSString *showLimit) {
            JurisdictionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.text.text = showLimit;
            if ([showLimit isEqualToString:@"公开"]) {
                limit = @"0";
            }else{
                limit = @"1";
            }
        }];
        PushController(jurisdiction)
    }
}

- (void)addClick:(UIButton *)sender
{
    [ShowActionSheet showActionSheetToController:self takeBlock:^{
        [self selectImageFromCamera];
    } phoneBlock:^{
        AlbumViewController *album = [[AlbumViewController alloc]init];
        [album returnSelImg:^(NSArray *selArr, NSArray *indexArr) {
            if (selArr) {
                [self.dataArr addObjectsFromArray:selArr];
                [self initAddImageView];
            }
        }];
        if (self.dataArr.count>0) {
            album.sum = self.dataArr.count;
        }
        [self.navigationController pushViewController:album animated:YES];
    }];
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
    [self initAddImageView];
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
- (void)refresh:(RefreshBlock)block{
    self.refreshBlock = block;
}
- (void)sendRequestPublicData
{
    NSString *str = @"<root><api><module>1202</module><type>0</type><query>{content=%@,position=%@,power=%@,photo=,maxid=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,content.text,user_location,limit,module,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"发布成功！"]) {
                if (self.refreshBlock != nil) {
                    self.refreshBlock(YES);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:element.stringValue];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//请求图片存储的模块
- (void)sendRequestModuleData
{
    NSString *str = @"<root><api><module>1706</module><type>0</type><query>{type=0}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>gb</phoneno></user></root>";
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
- (NSMutableArray *)indexpathArr
{
    if (!_indexpathArr) {
        _indexpathArr = [NSMutableArray array];
    }
    return _indexpathArr;
}
@end
