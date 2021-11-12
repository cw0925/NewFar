//
//  AddFriendViewController.m
//  NewFarSoft
//
//  Created by CW on 16/8/23.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "AddFriendViewController.h"
#import "SGGenerateQRCodeVC.h"
#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "AddressbookCell.h"
#import "FriendInfoViewController.h"

@interface AddFriendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *phone;

- (IBAction)addClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *bgPhone;

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation AddFriendViewController
{
    UITableView *searchTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"添加好友" hasLeft:YES hasRight:YES withRightBarButtonItemImage:@"scaning"];
    
    [self initUI];
    [self initSearchView];
}
//扫描添加好友
- (void)rightBarClick
{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
                        PushController(scanningQRCodeVC)
                        NSLog(@"主线程 - - %@", [NSThread currentThread]);
                    });
                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
                    
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
            PushController(scanningQRCodeVC)
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            [ShowAlter showAlertToController:self title:@"提示" message:@"请去-> [设置 - 隐私 - 相机 - 管翼通] 打开访问开关" buttonAction:@"取消" buttonBlock:^{
                
            }];
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        [ShowAlter showAlertToController:self title:@"提示" message:@"未检测到您的摄像头, 请在真机上测试" buttonAction:@"取消" buttonBlock:^{
            
        }];
    }
}
- (void)initUI
{
    _bgPhone.layer.borderWidth = 1;
    _bgPhone.layer.borderColor = RGBColor(211, 212, 213).CGColor;
}
- (void)initSearchView{
    searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NVHeight+56, ViewWidth, ViewHeight-NVHeight-56) style:UITableViewStylePlain];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    searchTable.rowHeight = 55;
    [self.view addSubview:searchTable];
    [searchTable registerNib:[UINib nibWithNibName:@"AddressbookCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    
    UIView *foot = [[UIView alloc]init];
    searchTable.tableFooterView = foot;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressbookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AddressbookModel *model = _dataArr[indexPath.row];
    [cell configCell:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfoViewController *info = [[FriendInfoViewController alloc]init];
    AddressbookModel *model = _dataArr[indexPath.row];
    info.model = model;
    if ([model.isfriend isEqualToString:@"0"]) {//非好友
        info.type = @"addFriend";
    }else{//好友
        info.type = @"callPhone";
    }
    info.phone = model.tel;
    PushController(info)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark -搜索
- (IBAction)addClick:(UIButton *)sender {
    NSLog(@"搜索");
    [self.view endEditing:YES];
    if ([_phone.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入对方的姓名或手机号！"];
    }else{
        if ([self deptNumInputShouldNumber:_phone.text]) {
            if (![JudgePhone judgePhoneNumber:_phone.text]) {
                [self.view makeToast:@"请输入正确的手机号！"];
            }else{
                [self senRequestAddFriendData:@"0"];
            }
        }else{
            [self senRequestAddFriendData:@"1"];
        }
    }
}
- (BOOL)deptNumInputShouldNumber:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}
//添加好友0 -手机号搜索 1- 关键字搜索
- (void)senRequestAddFriendData:(NSString *)type
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    if (self.dataArr.count >0) {
        [self.dataArr removeAllObjects];
    }
    NSString *str = @"<root><api><querytype>2</querytype><query>{key=%@,type=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_phone.text,type,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:element.stringValue];
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    AddressbookModel *model = [[AddressbookModel alloc]init];
                    DDXMLElement *c_no = [item elementsForName:@"c_no"][0];
                    model.c_no = c_no.stringValue;
                    DDXMLElement *tel = [item elementsForName:@"tel"][0];
                    model.tel = tel.stringValue;
                    DDXMLElement *zw = [item elementsForName:@"zw"][0];
                    model.zw = zw.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    model.tx = tx.stringValue;
                    DDXMLElement *gztype = [item elementsForName:@"gztype"][0];
                    model.gztype = gztype.stringValue;
                    DDXMLElement *isfriend = [item elementsForName:@"isfriend"][0];
                    model.isfriend = isfriend.stringValue;
                    DDXMLElement *isoneqy = [item elementsForName:@"isoneqy"][0];//0代表同一企业 1代表不是同一企业
                    model.isoneqy = isoneqy.stringValue;
                    [self.dataArr addObject:model];
                }
                [searchTable reloadData];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
