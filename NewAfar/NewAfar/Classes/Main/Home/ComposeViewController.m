//
//  ComposeViewController.m
//  NewAfar
//
//  Created by cw on 16/12/10.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ComposeViewController.h"
#import "CalendarViewController.h"
#import "ShowActionSheet.h"
#import "AlbumViewController.h"
#import "UIImage+Scale.h"
#import "GetAlbumPhotos.h"
#import "LookImageViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define Padding 10
#define BtnW (ViewWidth-70)/4

@interface ComposeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

- (IBAction)choseDateClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateStr;
- (IBAction)lastDayClick:(UIButton *)sender;
- (IBAction)nextDayClick:(UIButton *)sender;

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *statueArr;
@property(nonatomic,copy)NSMutableArray *indexpathArr;
@end

@implementation ComposeViewController
{
    NSDateFormatter *dateFormatter;
    NSData *img_data;
    UIImagePickerController *_imagePickerController;
    UIView *bgView;
    UITextView *content;
    
    NSString *module;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"写工作日志" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initDate];
    [self initUI];
    
    [self sendRequestModuleData];
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    [super customNavigationBar:title hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 50, 30);
    right.titleLabel.font = [UIFont systemFontWithSize:14];
    [right setTitle:@"发布" forState:UIControlStateNormal];
    [right setTitleColor:RGBColor(0, 100, 200) forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
}
//发布
- (void)rightClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (([content.text isEqualToString:@""]||[content.text isEqualToString:@"把今天的工作记录一下吧！"])&&_dataArr.count == 0) {
        [self.view makeToast:@"请输入要发表的日志内容！"];
    }else if (_dataArr.count>0){//有图
        [MBProgressHUD showMessag:@"正在上传图片..." toView:self.view];
        NSArray *imgArr = [[GetAlbumPhotos defaultGetAlbumPhotos]getImages:CGSizeMake(250, 250)];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSString *index in _indexpathArr) {
            [arrM addObject:imgArr[[index integerValue]]];
        }
        [NetRequest uploadImage:arrM withFileName:[NSString stringWithFormat:@"%@g1g%@",[userDefault valueForKey:@"name"],module] success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self sendRequestAddLogData];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else if (!([content.text isEqualToString:@""]||[content.text isEqualToString:@"把今天的工作记录一下吧！"])&&_dataArr.count==0){//只发送文字
        [self sendRequestAddLogData];
    }
}
- (void)initDate
{
    //日期
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    //获取当前时间
    NSDate *currentDate = [NSDate date];//获取当前日期
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    _dateStr.text = dateString;
    
    bgView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:bgView];
    
    content = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth-20, 100)];
    content.text = @"把今天的工作记录一下吧！";
    content.textColor = [UIColor grayColor];
    content.delegate = self;
    [bgView addSubview:content];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"把今天的工作记录一下吧！"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"把今天的工作记录一下吧！";
        textView.textColor = [UIColor grayColor];
    }
}
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
        UIImage *image = [UIImage imageNamed:@"upload"];
        if ([_dataArr containsObject:image]) {
            for (NSInteger i =0; i<imgCount; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(((i%4)+1)*Padding+(i%4)*BtnW, 100+((i/4)+1)*Padding+(i/4)*BtnW, BtnW, BtnW);
                [btn setBackgroundImage:_dataArr[i] forState:UIControlStateNormal];
                [bgView addSubview:btn];
                if (i== imgCount-1) {
                    [btn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    //[btn addTarget:self action:@selector(lookThroughPic:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else{
            for (NSInteger i =0; i<imgCount; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(((i%4)+1)*Padding+(i%4)*BtnW, 100+((i/4)+1)*Padding+(i/4)*BtnW, BtnW, BtnW);
                [btn setBackgroundImage:_dataArr[i] forState:UIControlStateNormal];
               // [btn addTarget:self action:@selector(lookThroughPic:) forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:btn];
            }
        }
    }else{
        for (NSInteger i =0; i<imgCount; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(((i%4)+1)*Padding+(i%4)*BtnW, 100+((i/4)+1)*Padding+(i/4)*BtnW, BtnW, BtnW);
            [btn setBackgroundImage:_dataArr[i] forState:UIControlStateNormal];
            if (i== imgCount-1) {
                [btn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
               //[btn addTarget:self action:@selector(lookThroughPic:) forControlEvents:UIControlEventTouchUpInside];
            }
            [bgView addSubview:btn];
        }
    }
    CGFloat height = (imgCount/4+1)*BtnW + (imgCount/4+2)*Padding+100;
    bgView.frame = CGRectMake(10, 66+64, ViewWidth-20, height);
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = RGBColor(211, 212, 213).CGColor;
}
- (void)addClick:(UIButton *)sender
{
    [ShowActionSheet showActionSheetToController:self takeBlock:^{
        [self selectImageFromCamera];
    } phoneBlock:^{
        AlbumViewController *album = [[AlbumViewController alloc]init];
        [album returnSelImg:^(NSArray *selArr, NSArray *indexArr) {
            if (selArr) {
                UIImage *img = [UIImage imageNamed:@"upload"];
                
                if ([_dataArr containsObject:img]) {
                    [_dataArr removeObject:img];
                    for (UIImage *image in selArr) {
                        [self.dataArr addObject:image];
                    }
                    if (_dataArr.count <6) {
                        [self.dataArr addObject:img];
                    }
                }else{
                    for (UIImage *image in selArr) {
                        [self.dataArr addObject:image];
                    }
                    if (_dataArr.count <6) {
                        [self.dataArr addObject:img];
                    }
                }
                NSLog(@"%lu",(unsigned long)self.dataArr.count);
                [self initUI];
                //选图状态
                [self.indexpathArr addObjectsFromArray:indexArr];
                NSLog(@"%lu---%@",(unsigned long)self.indexpathArr.count,self.indexpathArr);
            }
        }];
        if (self.dataArr.count>0) {
            album.sum = self.dataArr.count-1;
        }
        NSLog(@"%lu",(unsigned long)self.dataArr.count);
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
    [self.dataArr insertObject:image atIndex:0];
    [self initUI];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    NSLog(@"");
}
- (IBAction)choseDateClick:(UIButton *)sender
{
    CalendarViewController *calendar = StoryBoard(@"Log", @"calendar");
    [calendar returnDate:^(NSString *date) {
        _dateStr.text = date;
    }];
    PushController(calendar)
}
- (IBAction)lastDayClick:(UIButton *)sender{
    NSDate *date = [dateFormatter dateFromString:_dateStr.text];
    
    NSDate *yesterday = [NSDate dateWithTimeInterval:-60 * 60 * 24 sinceDate:date];
    _dateStr.text = [dateFormatter stringFromDate:yesterday];
}
- (IBAction)nextDayClick:(UIButton *)sender{
    NSDate *date = [dateFormatter dateFromString:_dateStr.text];
    NSDate *tomorrow = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:date];
    _dateStr.text = [dateFormatter stringFromDate:tomorrow];
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
    NSLog(@"%@",module);
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    fmt.timeZone = timeZone;
    NSDateFormatter *dstFmt=[[NSDateFormatter alloc]init];
    dstFmt.dateFormat = @"yyyy-MM-dd";
    dstFmt.timeZone = timeZone;
    
    NSDate *srcDate=[fmt dateFromString:_dateStr.text];
    
    NSString *date = [dstFmt stringFromDate:srcDate];
    
    if ([content.text isEqualToString:@"把今天的工作记录一下吧！"]) {
        content.text = @"";
    }
    NSString *str = @"<root><api><module>1501</module><type>0</type><query>{title=,content=%@,time=%@,photo=,maxid=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    
    NSString *string = [NSString stringWithFormat:str,content.text,date,module,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"保存成功！"]) {
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
- (NSMutableArray *)statueArr
{
    if (!_statueArr) {
        _statueArr = [NSMutableArray array];
    }
    return _statueArr;
}
- (NSMutableArray *)indexpathArr
{
    if (!_indexpathArr) {
        _indexpathArr = [NSMutableArray array];
    }
    return _indexpathArr;
}
@end
