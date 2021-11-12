//
//  ModifyMaterialViewController.m
//  NewAfar
//
//  Created by cw on 17/1/18.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "ModifyMaterialViewController.h"
#import "DatePickView.h"
#import "ShowActionSheet.h"
//调取相机、照片
#import <MobileCoreServices/MobileCoreServices.h>

@interface ModifyMaterialViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,ChoseClickDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *hobby;
@property (weak, nonatomic) IBOutlet UITextField *postion;
@property (weak, nonatomic) IBOutlet UITextField *birth;
- (IBAction)changeInfoClick:(UIButton *)sender;

@property(nonatomic,strong)UIImagePickerController *imagePickerController;
@property(nonatomic,copy)NSString *sex;//性别
@end

@implementation ModifyMaterialViewController
{
    DatePickView *datePick;
    NSData *data;
    UIButton *btn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"资料修改" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
    [self sendRequestPersonalInfoData];
}
- (void)initUI{
    //头像
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseIcon:)];
    _icon.userInteractionEnabled = YES;
    [_icon addGestureRecognizer:gesture];
    //调取相机和照片
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    //输入框
    UILabel *nick = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    nick.text = @"   昵       称:";
    nick.font = [UIFont systemFontWithSize:12];
    _nickname.leftView = nick;
    _nickname.leftViewMode = UITextFieldViewModeAlways;
    _nickname.font = [UIFont systemFontWithSize:12];
    
    UILabel *user = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    user.text = @"   您的姓名:";
    user.font = [UIFont systemFontWithSize:12];
    _username.leftView = user;
    _username.leftViewMode = UITextFieldViewModeAlways;
    _username.font = [UIFont systemFontWithSize:12];
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    //right.backgroundColor = [UIColor greenColor];
    _username.rightView = right;
    _username.rightViewMode = UITextFieldViewModeAlways;
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sexBtn.frame = CGRectMake(60*i, 5, 60, 20);
        sexBtn.titleLabel.font = [UIFont systemFontWithSize:10];
        NSArray *titleArr = @[@"先生",@"女士"];
        [sexBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sexBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [sexBtn setImage:[UIImage imageNamed:@"sex"] forState:UIControlStateNormal];
        [sexBtn setImage:[UIImage imageNamed:@"sex_selected"] forState:UIControlStateSelected];
        [sexBtn addTarget:self action:@selector(choseSexClick:) forControlEvents:UIControlEventTouchUpInside];
        sexBtn.tag = i+1;
        [right addSubview:sexBtn];
    }

//    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
//    _username.rightView = right;
//    _username.rightViewMode = UITextFieldViewModeAlways;
//    
//    btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 5, 60, 20);
//    btn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"sex_selected"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
//    [right addSubview:btn];
    
    UILabel *interest = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    //interest.backgroundColor = [UIColor redColor];
    interest.text = @"   您的爱好:";
    interest.font = [UIFont systemFontWithSize:12];
    _hobby.leftView = interest;
    _hobby.leftViewMode = UITextFieldViewModeAlways;
    _hobby.font = [UIFont systemFontWithSize:12];
    UILabel *post = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    post.text = @"   您的职位:";
    post.font = [UIFont systemFontWithSize:12];
    _postion.leftView = post;
    _postion.leftViewMode = UITextFieldViewModeAlways;
    _postion.font = [UIFont systemFontWithSize:12];\
    _postion.enabled = NO;
    _postion.backgroundColor = [UIColor whiteColor];
    UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    day.text = @"   您的生日:";
    day.font = [UIFont systemFontWithSize:12];
    _birth.leftView = day;
//    _birth.delegate = self;
    _birth.leftViewMode = UITextFieldViewModeAlways;
    _birth.font = [UIFont systemFontWithSize:12];
    _birth.enabled = NO;
    _birth.backgroundColor = [UIColor whiteColor];
}
//性别选择
- (void)choseSexClick:(UIButton *)sender
{
    sender.selected = YES;
    if (sender.tag == 1) {
        UIButton *sexBtn = (UIButton *)[self.view viewWithTag:2];
        sexBtn.selected = NO;
        self.sex = @"男";
    }
    if (sender.tag == 2) {
        UIButton *sexBtn = (UIButton *)[self.view viewWithTag:1];
        sexBtn.selected = NO;
        self.sex = @"女";
    }
    NSLog(@"%@",self.sex);
}
- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}
- (void)choseIcon:(UITapGestureRecognizer *)gesture{
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
        //img = info[UIImagePickerControllerEditedImage];
        _icon.image = info[UIImagePickerControllerEditedImage];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//个人资料
- (void)sendRequestPersonalInfoData
{
    NSString *str = @"<root><api><module>1301</module><type>0</type><query></query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *resdata = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:resdata options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue];
                return ;
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *nc = [item elementsForName:@"nc"][0];
                    _nickname.text = nc.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    _username.text = name.stringValue;
                    DDXMLElement *sex = [item elementsForName:@"sex"][0];
                    self.sex = sex.stringValue;
                    if ([sex.stringValue isEqualToString:@"男"]) {
                        UIButton *sexbtn = (UIButton *)[self.view viewWithTag:1];
                        sexbtn.selected = YES;
                    }else if ([sex.stringValue isEqualToString:@"女"]){
                        UIButton *sexbtn = (UIButton *)[self.view viewWithTag:2];
                        sexbtn.selected = YES;
                    }
                    if ([item elementsForName:@"ah"].count>0) {
                        DDXMLElement *ah = [item elementsForName:@"ah"][0];
                        _hobby.text = ah.stringValue;
                    }else{
                        _hobby.text = @"";
                    }
                    DDXMLElement *zw = [item elementsForName:@"zw"][0];
                    _postion.text = zw.stringValue;
                    DDXMLElement *sr = [item elementsForName:@"sr"][0];
                    _birth.text = sr.stringValue;
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    if ([tx.stringValue isEqualToString:@""]) {
                        _icon.image = [[UIImage imageNamed:@"avatar_zhixing"] circleImage];
                    }else{
                        [_icon sd_setImageWithURL:[NSURL URLWithString:tx.stringValue] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            _icon.image = [image circleImage];
                        }];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)changeInfoClick:(UIButton *)sender {
    NSLog(@"---------");
    [self sendRequestModifyInfoData];
}
//图片处理，图片压缩
- (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);  //你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回已变图片
}

//修改资料
- (void)sendRequestModifyInfoData
{
    UIImage *getImg = [self OriginImage:_icon.image scaleToSize:CGSizeMake(100, 100)];
    if (UIImageJPEGRepresentation(getImg, 1.0)) {
        data = UIImageJPEGRepresentation(getImg, 1.0);
    }else{
        data = UIImagePNGRepresentation(getImg);
    }
    //NSLog(@"%@",data);
    NSString *pic = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (!pic) {
        pic = @"";
    }
    NSString *str = @"<root><api><module>1003</module><type>0</type><query>{username=%@,realname=%@,xingbie=%@,hobby=%@,position=%@,photo=%@,birth=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno><verifycode></verifycode></user></root>";
    NSString *string = [NSString stringWithFormat:str,_nickname.text,_username.text,_sex,_hobby.text,_postion.text,pic,_birth.text,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *returen_data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:returen_data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"更新成功！"]) {
                [self.navigationController.viewControllers[0].view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:element.stringValue];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
