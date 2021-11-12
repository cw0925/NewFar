//
//  RegistViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/22.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "RegistViewController.h"
#import "ShowActionSheet.h"
#import "JudgePhone.h"
#import "DatePickView.h"
//调取相机、照片
#import <MobileCoreServices/MobileCoreServices.h>
#import "HereManager.h"

#define CountTime 60 //倒计时时间

@interface RegistViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,ChoseClickDelegate>

- (IBAction)userRegistClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *hobby;
//@property (weak, nonatomic) IBOutlet UITextField *position;
@property (weak, nonatomic) IBOutlet UITextField *birth;
- (IBAction)getCodeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *veryCode;
@property (weak, nonatomic) IBOutlet UIButton *regist;

@property (weak, nonatomic) IBOutlet UIButton *image;

@property(nonatomic,copy)NSString *sex;//性别
@property(nonatomic,strong)UIImagePickerController *imagePickerController;
@property(nonatomic,copy)NSString *iconData;//头像数据

@end

@implementation RegistViewController
{
    NSTimer *_timer;
    NSData *fileData;
    UIImage *img;
    NSData *user_data;
    DatePickView *datePick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
    [self customNavigationBar];
    
    self.sex = @"男";
    //验证码倒计时时间
    [HereManager sharedManager].regiestVerifCountTime = CountTime;
    
    [self initUI];
}
- (void)customNavigationBar
{
    self.navigationItem.title = @"注册";
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 60, 30);
    [left addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    
    UIImageView *left_imv = [UIImageView new];
    left_imv.image = [UIImage imageNamed:@"calendar_left"];
    
    UILabel *left_title = [UILabel new];
    left_title.text = @"返回";
    left_title.font = [UIFont systemFontWithSize:14];
    left_title.textColor = RGBColor(151, 151, 151);
    //left_title.backgroundColor = [UIColor redColor];
    
    [left sd_addSubviews:@[left_imv,left_title]];
    
    left_imv.sd_layout.leftSpaceToView(left,0).topSpaceToView(left,4).bottomSpaceToView(left,4).widthIs(20);
    
    left_title.sd_layout.leftSpaceToView(left_imv,0).topSpaceToView(left,0).rightSpaceToView(left,0).bottomSpaceToView(left,0);
}
- (void)backPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initUI
{
    img = [UIImage imageNamed:@"avatar_zhixing"];
    //头像
    [_image addTarget:self action:@selector(uploadIconClick) forControlEvents:UIControlEventTouchUpInside];
    //调取相机和照片
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    //输入框
    _code.font = [UIFont systemFontWithSize:12];
    
    UILabel *nick = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    nick.text = @"  昵          称:";
    nick.font = [UIFont systemFontWithSize:12];
    _nickname.leftView = nick;
    _nickname.leftViewMode = UITextFieldViewModeAlways;
    _nickname.font = [UIFont systemFontWithSize:12];
    
    UILabel *user = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,90, 30)];
    //user.backgroundColor = [UIColor redColor];
    user.text = @"  您 的 姓 名:";
    user.font = [UIFont systemFontWithSize:12];
    _username.leftView = user;
    _username.leftViewMode = UITextFieldViewModeAlways;
    _username.font = [UIFont systemFontWithSize:12];
    
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    //right.backgroundColor = [UIColor greenColor];
    _username.rightView = right;
    _username.rightViewMode = UITextFieldViewModeAlways;
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(60*i, 5, 60, 20);
        btn.titleLabel.font = [UIFont systemFontWithSize:10];
        NSArray *titleArr = @[@"先生",@"女士"];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"sex"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"sex_selected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(choseSexClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+1;
//        if (btn.tag == 1) {
//            btn.selected = YES;
//            _sex = @"男";
//        }
        [right addSubview:btn];
    }
    
    UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    //num.backgroundColor = [UIColor purpleColor];
    num.text = @"  您的手机号:";
    num.font = [UIFont systemFontWithSize:12];
    _phone.leftView = num;
    _phone.leftViewMode = UITextFieldViewModeAlways;
    _phone.font = [UIFont systemFontWithSize:12];
    
    UILabel *psd = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    psd.text = @"  密          码:";
    psd.font = [UIFont systemFontWithSize:12];
    _password.leftView = psd;
    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.font = [UIFont systemFontWithSize:12];
    
    UILabel *interest = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    interest.text = @"  您 的 爱 好:";
    interest.font = [UIFont systemFontWithSize:12];
    _hobby.leftView = interest;
    _hobby.leftViewMode = UITextFieldViewModeAlways;
    _hobby.font = [UIFont systemFontWithSize:12];
    
    UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    day.text = @"  您 的 生 日:";
    day.font = [UIFont systemFontWithSize:12];
    _birth.delegate = self;
    _birth.leftView = day;
    _birth.leftViewMode = UITextFieldViewModeAlways;
    _birth.font = [UIFont systemFontWithSize:12];
    
    _veryCode.titleLabel.font = [UIFont systemFontWithSize:12];
    _regist.titleLabel.font = [UIFont systemFontWithSize:13];
}
#pragma mark - UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_birth isFirstResponder]) {
        datePick = [[DatePickView alloc]initDatePickView];
        [datePick showPickViewWhenClick:textField];
        datePick.choseDelegate = self;
    }
}
- (void)choseBtnClick:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        _birth.text = datePick.title.text;
    }
    [self.view endEditing:YES];
}
- (void)uploadIconClick
{
    [ShowActionSheet showActionSheetToController:self takeBlock:^{
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //设置摄像头模式（拍照，录制视频）为录像模式
        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    } phoneBlock:^{
        NSLog(@"调取照片");
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }];
}
#pragma mark UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        img = info[UIImagePickerControllerEditedImage];
        [_image setImage:img forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
/* 取消拍照或录像会调用 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消");
    //拾取控制器弹回
    [self dismissViewControllerAnimated:YES completion:nil];
}
//性别选择
- (void)choseSexClick:(UIButton *)sender
{
    sender.selected = YES;
    if (sender.tag == 1) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:2];
        btn.selected = NO;
        _sex = @"男";
    }
    if (sender.tag == 2) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:1];
        btn.selected = NO;
        _sex = @"女";
    }
    NSLog(@"%@",_sex);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//图片处理，图片压缩
- (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);  //你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回已变图片
}
#pragma mark - 用户注册(头像上传有问题)
- (IBAction)userRegistClick:(UIButton *)sender {
    if ([_nickname.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入昵称！"];
    }else if ([_username.text isEqualToString:@""]){
        [self.view makeToast:@"请输入您的姓名！"];
    }else if ([_phone.text isEqualToString:@""]){
        [self.view makeToast:@"请输入您的手机号！"];
    }else if (![JudgePhone judgePhoneNumber:_phone.text]){
        [self.view makeToast:@"请输入正确的手机号！"];
    }else if ([_password.text isEqualToString:@""]){
        [self.view makeToast:@"请输入密码！"];
    }else{
        [self commitUserInfoData];
    }
}
- (void)commitUserInfoData
{
    UIImage *getImg = [self OriginImage:img scaleToSize:CGSizeMake(50, 50)];
    if (UIImageJPEGRepresentation(getImg, 1)) {
        user_data = UIImageJPEGRepresentation(getImg, 1);
    }else{
        user_data = UIImagePNGRepresentation(getImg);
    }
    NSString *tx = [user_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (!user_data) {
        tx = @"";
    }
    NSString *str = @"<root><api><module>1001</module><type>0</type><query>{username=%@,realname=%@,password=%@,xingbie=%@,photo=%@,hobby=%@,position=,birth=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno><verifycode>%@</verifycode></user></root>";
    NSString *string = [NSString stringWithFormat:str,_nickname.text,_username.text,_password.text,_sex,tx,_hobby.text,_birth.text,_phone.text,UUID,_code.text];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"注册成功！"]) {
                [self.view makeToast:element.stringValue];
            }else{
                if (self.returnTextBlock != nil) {
                    self.returnTextBlock(_phone.text);
                }
                [self.navigationController.viewControllers[0].view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
//获取验证码
- (IBAction)getCodeClick:(UIButton *)sender {
    if ([_phone.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入手机号"];
    }else if (![JudgePhone judgePhoneNumber:_phone.text]){
        [self.view makeToast:@"请输入正确的手机号！"];
    }else{
        if (!_timer) {
            [[HereManager sharedManager] stopRegisterCountTime];
            [HereManager sharedManager].regiestVerifCountTime = CountTime;
            _getCodeBtn.enabled = NO;
            _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(chageButtonCount) userInfo:nil repeats:YES];
        }
        [self getCode];
    }
}
- (void)getCode{
    NSString *string = [NSString stringWithFormat:CodeXML,_phone.text,UUID];
    [NetRequest sendRequest:CodeURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
           [self.view makeToast:element.stringValue];
        }
    } failure:^(NSError *error) {
        NSLog(@"错误：%@",error);
    }];
}
//倒计时button时间
- (void)chageButtonCount
{
    //更新button显示时间
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    NSUInteger count = [HereManager sharedManager].regiestVerifCountTime;
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ld s后重发",(unsigned long)count] forState:UIControlStateNormal];
    if (!count){
        [_timer invalidate];
        _timer = nil;
        _getCodeBtn.enabled = YES;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
