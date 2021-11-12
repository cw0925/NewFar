//
//  RegistManageViewController.m
//  NewAfar
//
//  Created by cw on 16/12/12.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "RegistManageViewController.h"
#import "CWPickView.h"
#import "ShowActionSheet.h"
#import "AlbumViewController.h"
#import "PickView.h"
#import "DatePickView.h"
#import "GetAlbumPhotos.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "CategoryModel.h"

#define Padding 10
#define BtnW (ViewWidth-70)/4

@interface RegistManageViewController ()<SenderClickDelegate,BtnClickDelegate,ChoseClickDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *organizationArr;
@property(nonatomic,copy)NSMutableArray *departmentArr;
@property(nonatomic,copy)NSMutableArray *mesureArr;

@property(nonatomic,copy)NSMutableArray *indexpathArr;
@property(nonatomic,copy)NSMutableArray *searchArr;
@property(nonatomic,strong)UITableView *searchTable;
@property(nonatomic,copy)NSMutableArray *categoryArr;

@property(nonatomic,copy)NSArray *dayArr;

@end

@implementation RegistManageViewController
{
    UIButton *currentSelectedButton;
    CWPickView *pick;
    UITextField *organTf;
    UITextField *departTf;
    NSString *reason;
    UIView *bgView;
    UIView *imgView;
    UIImagePickerController *_imagePickerController;
    UITextField *mesure;
    PickView *mesurePick;
    UITextField *time;
    UITextView *content;
    UITextField *personTf;
    
    NSData *img_data;
    
    DatePickView *datePick;
    
    UITextField *day;
    PickView *dayPick;
    
    NSString *module;
    NSString *dayString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self customNavigationBar:@"正在巡场" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self sendRequestPunishData];
    
    [self initCompanyView];
    [self initAddImage];
    
    [self sendRequestOrganizationInfoData];
    
    [self sendRequestModuleData];
    
    [self sendRequestReasonData];
    
    dayString = @"d";
    
}
- (void)backPage
{
    [super backPage];
    if (_searchTable) {
        [_searchTable removeFromSuperview];
    }
}
#pragma mark - textfield搜索
- (void)textFieldDidChange:(UITextField *)textfield {
    if (textfield.markedTextRange == nil) {
        NSLog(@"text:%@", textfield.text);
        if ([organTf isFirstResponder]) {
            [self sendRequestSearchData:textfield.text type:@"1"];
        }else if ([departTf isFirstResponder]){
            [self sendRequestSearchData:textfield.text type:@"2"];
        }
    }
}
//搜索数据
- (void)sendRequestSearchData:(NSString *)text type:(NSString *)type{
    if (self.searchArr.count >0) {
        [_searchArr removeAllObjects];
    }
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    NSString *store = [userDefault valueForKey:@"store"];
    
    NSString *str = @"<root><api><module></module><type>0</type><query>{qyno=%@,store=%@,key=%@,type=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,qyno,store,text,type,qyno,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:SearchURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                if ([type isEqualToString:@"1"]) {
                    for (DDXMLElement *item in rowArr) {
                        DDXMLElement *name = [item elementsForName:@"name"][0];
                        [self.searchArr addObject:name.stringValue];
                    }
                }else if ([type isEqualToString:@"2"]){
                    for (DDXMLElement *item in rowArr) {
                        DDXMLElement *c_depart_id = [item elementsForName:@"c_depart_id"][0];
                        DDXMLElement *c_depart_name = [item elementsForName:@"c_depart_name"][0];
                        [self.searchArr addObject:[NSString stringWithFormat:@"%@ %@",c_depart_id.stringValue,c_depart_name.stringValue]];
                    }
                }
                [_searchTable reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)initCompanyView
{
    CGFloat margin = 10;
    UIScrollView *scroll = [UIScrollView new];
    [self.view addSubview:scroll];
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleEdit)];
    scroll.userInteractionEnabled = YES;
    [scroll addGestureRecognizer:gesture];
    
    UILabel *organ = [UILabel new];
    organ.text = @"机      构:";
    organ.font = [UIFont systemFontWithSize:13];
    
    organTf = [UITextField new];
    organTf.placeholder = @"添加将要巡视的机构";
    organTf.borderStyle = UITextBorderStyleRoundedRect;
    organTf.font = [UIFont systemFontWithSize:13];
    organTf.delegate = self;
    
    
    UIButton *organizationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    organizationBtn.frame = CGRectMake(0, 0, 30, 30);
    organizationBtn.tag = 100;
    [organizationBtn setBackgroundImage:[UIImage imageNamed:@"xia"] forState:UIControlStateNormal];
    [organizationBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    organTf.rightView = organizationBtn;
    organTf.rightViewMode = UITextFieldViewModeAlways;
    
    [organTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *depart = [UILabel new];
    depart.text = @"部      门:";
    depart.font = [UIFont systemFontWithSize:13];
    
    departTf = [UITextField new];
    departTf.placeholder = @"添加将要巡视的部门";
    departTf.borderStyle = UITextBorderStyleRoundedRect;
    departTf.font = [UIFont systemFontWithSize:13];
    departTf.delegate = self;
    [departTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *departBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    departBtn.tag = 101;
    departBtn.frame = CGRectMake(0, 0, 30, 30);
    [departBtn setBackgroundImage:[UIImage imageNamed:@"xia"] forState:UIControlStateNormal];
    [departBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    departTf.rightView = departBtn;
    departTf.rightViewMode = UITextFieldViewModeAlways;
    
    
    UILabel *reasonLb = [UILabel new];
    reasonLb.text = @"原      因:";
    reasonLb.font = [UIFont systemFontWithSize:13];
    
    bgView = [UIView new];
    
    UILabel *deadline = [UILabel new];
    deadline.text = @"整改期限:";
    deadline.font = [UIFont systemFontWithSize:13];
    
    time = [UITextField new];
    time.borderStyle = UITextBorderStyleRoundedRect;
    time.font = [UIFont systemFontWithSize:13];
    time.keyboardType = UIKeyboardTypeNumberPad;
    
    day = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    day.font = [UIFont systemFontWithSize:13];
    day.delegate = self;
    time.rightView = day;
    time.rightViewMode = UITextFieldViewModeAlways;
    day.text = self.dayArr[0];
    //day.backgroundColor = [UIColor greenColor];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    img.image = [UIImage imageNamed:@"sanjiao"];
    day.rightView = img;
    day.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *person = [UILabel new];
    person.text = @"负责人:";
    person.font = [UIFont systemFontWithSize:13];
    
    personTf = [UITextField new];
    personTf.borderStyle = UITextBorderStyleRoundedRect;
    personTf.font = [UIFont systemFontWithSize:13];
    
    UILabel *punish = [UILabel new];
    punish.text = @"处罚类型:";
    punish.font = [UIFont systemFontWithSize:13];
    
    mesure = [UITextField new];
    mesure.font = [UIFont systemFontWithSize:13];
    mesure.borderStyle = UITextBorderStyleRoundedRect;
    mesure.delegate = self;
    [mesure addTarget:self action:@selector(chosePunishType:) forControlEvents:UIControlEventEditingDidBegin];
    
    
    imgView = [UIView new];
    imgView.layer.borderWidth = 1;
    imgView.layer.borderColor = RGBColor(211, 212, 213).CGColor;
    
    content = [UITextView new];
    content.placeholder = @"填写问题具体情况！";
    content.delegate = self;
    content.font = [UIFont systemFontWithSize:13];
    [imgView addSubview:content];
    
    UIButton *sure = [UIButton new];
    [sure setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [scroll sd_addSubviews:@[organ,organTf,depart,departTf,reasonLb,bgView,deadline,time,day,person,personTf,imgView,sure,punish,mesure]];
    
    organ.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(scroll,margin).widthIs(70).heightIs(30);
    
    organTf.sd_layout.leftSpaceToView(organ,0).topSpaceToView(scroll,margin).rightSpaceToView(scroll,margin).heightIs(30);
    
    depart.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(organ,margin).widthIs(70).heightIs(30);
    
    departTf.sd_layout.leftSpaceToView(depart,0).topSpaceToView(organTf,margin).rightSpaceToView(scroll,margin).heightIs(30);
    
    reasonLb.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(depart,margin).widthIs(70).heightIs(30);
    
    bgView.sd_layout.leftSpaceToView(reasonLb,0).topSpaceToView(departTf,margin).widthIs(ViewWidth-70-20).heightIs(65);
    
    //punish.backgroundColor = [UIColor greenColor];
    punish.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(deadline,margin).widthIs(70).heightIs(30);
    
    //mesure.backgroundColor = [UIColor blackColor];
     mesure.sd_layout.leftSpaceToView(punish,0).rightSpaceToView(scroll,margin).topEqualToView(punish).heightIs(30);

    deadline.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(bgView,margin+5).widthIs(70).heightIs(30);
    
    //time.backgroundColor = [UIColor greenColor];
    time.sd_layout.leftSpaceToView(deadline,0).topSpaceToView(bgView,margin+5).widthIs(ViewWidth/2-100).heightIs(30);
    
    personTf.sd_layout.topSpaceToView(bgView,margin+5).rightSpaceToView(scroll,margin).widthIs(ViewWidth/2-60-2*margin).heightIs(30);
    
    //person.backgroundColor = [UIColor redColor];
    person.sd_layout.topSpaceToView(bgView,margin+5).rightSpaceToView(personTf,0).widthIs(60).heightIs(30);
    
    //imgView.backgroundColor = [UIColor purpleColor];
    imgView.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(mesure,margin).widthIs(ViewWidth-20).heightIs(300);
    
    //content.backgroundColor = [UIColor greenColor];
    content.sd_layout.leftSpaceToView(imgView,0).topSpaceToView(imgView,0).rightSpaceToView(imgView,0).heightIs(100);
    
    sure.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(imgView,margin).rightSpaceToView(scroll,margin).heightIs(35);
    // scrollview自动contentsize
    [scroll setupAutoContentSizeWithBottomView:sure bottomMargin:100];
}
- (void)initReasonView:(NSArray *)arr{
    CGFloat ButtonW = (bgView.frame.size.width-15)/4.0;
    CGFloat BtnH = 30;
    NSLog(@"%@",NSStringFromCGRect(bgView.frame));
    //NSArray *arr = @[@"商品",@"环境",@"服务",@"管理",@"价格",@"工作失误",@"标示不明确"];
    for (NSInteger i = 0; i < arr.count; i++) {
        CategoryModel *model = arr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5*(i%4)+ButtonW*(i%4),5*(i/4)+BtnH*(i/4), ButtonW, BtnH);
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"gg"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:model.tname forState:UIControlStateNormal];
        [bgView addSubview:btn];
        btn.tag = i + 1;
        if (btn.tag == 1) {
            [btn setTitleColor:RGBColor(68, 133, 206) forState:UIControlStateNormal];
            btn.layer.borderColor = RGBColor(68, 133, 206).CGColor;
            CategoryModel *model = arr[btn.tag-1];
            reason = model.tid;//
        }
        [btn addTarget:self action:@selector(choseManageTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}
- (void)cancleEdit
{
    [self.view endEditing:YES];
    if (pick||_searchTable) {
        [pick remove];
        [_searchTable removeFromSuperview];
    }
    
}
#pragma mark - 提交巡场记录
- (void)commitClick:(UIButton *)sender
{
    if ([day.text isEqualToString:@"日"]) {
        dayString = @"d";
    }else if ([day.text isEqualToString:@"时"]){
        dayString = @"h";
    }else if ([day.text isEqualToString:@"分"]){
        dayString = @"m";
    }
    if ([organTf.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择机构！"];
    }else if (_dataArr.count >0){
        [MBProgressHUD showMessag:@"上传图片中..." toView:self.view];

        [NetRequest uploadImage:self.dataArr withFileName:[NSString stringWithFormat:@"%@g2g%@",[userDefault valueForKey:@"name"],module] success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self sendRequestManagingData:dayString];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else if (_dataArr.count==0){
        [self sendRequestManagingData:dayString];
    }
}
- (void)initAddImage
{
    NSInteger imgCount = self.dataArr.count;
    
    if (imgCount == 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(Padding, 100+Padding, BtnW, BtnW);
        [btn setBackgroundImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(choseImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:btn];
    }else if (imgCount == 6){
        for (NSInteger i =0; i<imgCount; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(((i%4)+1)*Padding+(i%4)*BtnW, 100+((i/4)+1)*Padding+(i/4)*BtnW, BtnW, BtnW);
            [btn setBackgroundImage:_dataArr[i] forState:UIControlStateNormal];
            [imgView addSubview:btn];
        }
    }else if(imgCount<6){
        for (NSInteger i =0; i<imgCount+1; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(((i%4)+1)*Padding+(i%4)*BtnW, 100+((i/4)+1)*Padding+(i/4)*BtnW, BtnW, BtnW);
            if (i== imgCount) {
                [btn addTarget:self action:@selector(choseImageClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:_dataArr[i] forState:UIControlStateNormal];
            }
            [imgView addSubview:btn];
        }
    }
    CGFloat height = (imgCount/4+1)*BtnW + (imgCount/4+2)*Padding+100;
    imgView.frame = CGRectMake(10, 66+64, ViewWidth-20, height);
    imgView.layer.borderWidth = 1;
    imgView.layer.borderColor = RGBColor(211, 212, 213).CGColor;
}
- (void)choseImageClick:(UIButton *)sender
{
    [ShowActionSheet showActionSheetToController:self takeBlock:^{
        [self selectImageFromCamera];
    } phoneBlock:^{
        AlbumViewController *album = [[AlbumViewController alloc]init];
        [album returnSelImg:^(NSArray *selArr, NSArray *indexArr) {
            [self.dataArr addObjectsFromArray:selArr];
            [self initAddImage];
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
//    [self.dataArr insertObject:image atIndex:0];
    UIImage *takeImg = [self OriginImage:image scaleToSize:CGSizeMake(300, 300)];
    [self.dataArr addObject:takeImg];
    [self initAddImage];
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
- (void)chosePunishType:(UITextField *)textfield
{
    if ([organTf.text isEqualToString:@""]) {
    }else{
        [self sendRequestPunishData];
    }
}
//原因
- (void)choseManageTypeClick:(UIButton *)sender
{
    CategoryModel *model = _categoryArr[sender.tag-1];
    reason = model.tid;
    for (UIButton *btn  in bgView.subviews) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:RGBColor(68, 133, 206) forState:UIControlStateNormal];
            btn.layer.borderColor = RGBColor(68, 133, 206).CGColor;
        }else
        {
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
    NSLog(@"%@",reason);
}
//添加机构、部门
- (void)addClick:(UIButton *)sender
{
    currentSelectedButton = sender;
    if (pick||_searchTable) {
        [pick remove];
        [_searchTable removeFromSuperview];
    }
    if (sender.tag == 101) {
        if ([organTf.text isEqualToString:@""]) {
            [self.view makeToast:@"请先选择机构！"];
        }else{
            [self sendRequestDepartData];
        }
    }else{
        NSLog(@"%@",_organizationArr);
        pick = [[CWPickView alloc]initPickViewWithArray:_organizationArr];
        pick.senderDelegate = self;
        [pick showAt:self.view whenClick:sender];
    }
    [self.view endEditing:YES];
}
#pragma mark - senderClickDelegate
- (void)senderClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if (currentSelectedButton.tag == 100) {
            organTf.text = pick.title.text;
        }else if (currentSelectedButton.tag == 101){
            departTf.text = pick.title.text;
        }
    }
    [pick remove];
}
#pragma mark - UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([mesure isFirstResponder]) {
        mesurePick = [[PickView alloc]initPickViewWithArray:_mesureArr];
        mesurePick.clickDelegate = self;
        [mesurePick showPickViewWhenClick:mesure];
    }
    if ([day isFirstResponder]) {
        dayPick = [[PickView alloc]initPickViewWithArray:self.dayArr];
        dayPick.clickDelegate = self;
        [dayPick showPickViewWhenClick:day];
    }
    if ([organTf isFirstResponder]) {
        if (_searchTable||_searchArr.count>0) {
            [_searchTable removeFromSuperview];
            [_searchArr removeAllObjects];
        }
        _searchTable = [[UITableView alloc]initWithFrame:CGRectMake(80, 64+42,ViewWidth-120, 200) style:UITableViewStylePlain];
        //_searchTable.backgroundColor = [UIColor purpleColor];
        _searchTable.delegate = self;
        _searchTable.dataSource = self;
        [self.view.window addSubview:_searchTable];
        
        [_searchTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"search"];
    }
    if ([departTf isFirstResponder]) {
        if (_searchTable||_searchArr.count>0) {
            [_searchTable removeFromSuperview];
            [_searchArr removeAllObjects];
        }
        _searchTable = [[UITableView alloc]initWithFrame:CGRectMake(80, 64+42+40,ViewWidth-120, 200) style:UITableViewStylePlain];
        //_searchTable.backgroundColor = [UIColor purpleColor];
        _searchTable.delegate = self;
        _searchTable.dataSource = self;
        [self.view.window addSubview:_searchTable];
        
        [_searchTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"search"];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search" forIndexPath:indexPath];
    cell.textLabel.text = _searchArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontWithSize:12];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([organTf isFirstResponder]) {
        organTf.text = _searchArr[indexPath.row];
    }else if ([departTf isFirstResponder]){
        departTf.text = _searchArr[indexPath.row];
    }
    
    [tableView removeFromSuperview];
}
- (void)choseBtnClick:(UIButton *)sender
{
//    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
//        expectTf.text = datePick.title.text;
//    }
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if (pick||_searchTable) {
        [pick remove];
        [_searchTable removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refresh:(RefreshBlock)block{
    self.refreshBlock = block;
}
- (void)sendRequestManagingData:(NSString *)qxtype// 日d 时h  分m
{
    //<root><api><module>1601</module><type>0</type><query>{store=101,bumenno=1,xuntype=1,zgqixian=1,qxtype=d,zerenren=荆轲,xunneirong=还不处理！！！,chufatype=4,zgdate= ,maxid=5510651489719302}</query></api><user><company>009</company><customeruser>18300602014</customeruser><phoneno>lblblblblblbtt</phoneno></user></root>
    NSArray *organArray = [organTf.text componentsSeparatedByString:@" "];
    NSArray *departArray = [departTf.text componentsSeparatedByString:@" "];
    
    NSArray *arr = [mesure.text componentsSeparatedByString:@" "];

    NSString *str = @"<root><api><module>1601</module><type>0</type><query>{store=%@,bumenno=%@,xuntype=%@,zgqixian=%@,qxtype=%@,zgdate=,xunneirong=%@,xctp=,zerenren=%@,chufatype=%@,maxid=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,organArray[0],departArray[0],reason,time.text,qxtype,content.text,personTf.text,arr[0],module,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"保存成功！"]) {
                [self.navigationController.viewControllers[1].view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
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
    }];
}

//机构
- (void)sendRequestOrganizationInfoData
{
    NSString *str = @"<root><api><querytype>10</querytype><query>{storetype=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *company = [[userDefault valueForKey:@"qyno"] substringToIndex:3];
    
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"storetype"],company,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    NSArray *arr = [name.stringValue componentsSeparatedByString:@","];
                    [self.organizationArr addObjectsFromArray:arr];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//部门
- (void)sendRequestDepartData
{
    //<root><api><querytype>4</querytype><query>{store=009,sto=101}</query></api><user><company>009</company><customeruser>18300602014</customeruser></user></root>
    NSString *qy = [userDefault valueForKey:@"qyno"];
    NSString *store = [organTf.text componentsSeparatedByString:@" "][0];
    NSString *str = @"<root><api><querytype>14</querytype><query>{store=%@,sto=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,qy,store,qy,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:InfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            if ([element elementsForName:@"dname"].count>0) {
                DDXMLElement *name = [element elementsForName:@"dname"][0];
                [self.departmentArr addObject:name.stringValue];
            }
        }
        pick = [[CWPickView alloc]initPickViewWithArray:_departmentArr];
        pick.senderDelegate = self;
        [pick showAt:self.view whenClick:currentSelectedButton];
    } failure:^(NSError *error) {
        
    }];
}

//处罚类型
- (void)sendRequestPunishData
{
    //<root><api><querytype>7</querytype><query>{store=001}</query></api><user><company>001</company><customeruser>15939010676</customeruser></user></root>
    NSString *company = [[userDefault valueForKey:@"qyno"] substringToIndex:3];
    
    NSString *str = @"<root><api><querytype>7</querytype><query>{store=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,company,company,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *element in rowArr) {
                    DDXMLElement *name = [element elementsForName:@"name"][0];
                     DDXMLElement *ID = [element elementsForName:@"id"][0];
                    [self.mesureArr addObject:[NSString stringWithFormat:@"%@ %@",ID.stringValue,name.stringValue]];
                }
//        NSArray *arr = [_mesureArr[0] componentsSeparatedByString:@" "];
        mesure.text = _mesureArr[0];
    } failure:^(NSError *error) {
        
    }];
}
//请求图片存储的模块
- (void)sendRequestModuleData
{
    NSString *str = @"<root><api><module>1706</module><type>0</type><query>{type=2}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>gb</phoneno></user></root>";
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
//原因
- (void)sendRequestReasonData{
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    NSString *company = [qyno substringToIndex:3];
    NSString *str = @"<root><api><querytype>5</querytype><query>{store=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,company,company,[userDefault valueForKey:@"name"]];
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                   CategoryModel *model = [[CategoryModel alloc]init];
                    DDXMLElement *tname = [item elementsForName:@"tname"][0];
                    model.tname = tname.stringValue;
                    DDXMLElement *tid = [item elementsForName:@"tid"][0];
                    model.tid = tid.stringValue;
                    [self.categoryArr addObject:model];
                }
                [self initReasonView:_categoryArr];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - BtnClickDelegate
- (void)btnClick:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([mesure isFirstResponder]) {
            mesure.text = mesurePick.title.text;
        }else if([day isFirstResponder]){
            day.text = dayPick.title.text;
        }
    }
    [self.view endEditing:YES];
}
- (NSMutableArray *)organizationArr
{
    if (!_organizationArr) {
        _organizationArr = [NSMutableArray array];
    }
    return _organizationArr;
}
- (NSMutableArray *)departmentArr
{
    if (!_departmentArr) {
        _departmentArr = [NSMutableArray array];
    }
    return _departmentArr;
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)mesureArr
{
    if (!_mesureArr) {
        _mesureArr = [NSMutableArray array];
    }
    return _mesureArr;
}
- (NSMutableArray *)indexpathArr
{
    if (!_indexpathArr) {
        _indexpathArr = [NSMutableArray array];
    }
    return _indexpathArr;
}
- (NSMutableArray *)searchArr
{
    if (!_searchArr) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}
- (NSMutableArray *)categoryArr
{
    if (!_categoryArr) {
        _categoryArr = [NSMutableArray array];
    }
    return _categoryArr;
}
- (NSArray *)dayArr
{
    if (!_dayArr) {
        _dayArr = @[@"日",@"时",@"分"];
    }
    return _dayArr;
}
@end
