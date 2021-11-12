//
//  AddressbookViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "AddressbookViewController.h"
#import "AddressbookCell.h"
#import "AddressbookModel.h"
#import "AddFriendViewController.h"
#import "FriendRequestViewController.h"
#import "BaseNavigationController.h"
#import "SeachViewController.h"
#import "FriendInfoViewController.h"

#import "SGGenerateQRCodeVC.h"
#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
//
#import "PartnerViewController.h"

@interface AddressbookViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,copy)NSMutableArray *addressbookArr;
@property(nonatomic,copy)NSMutableArray *reservedObjsArr;
@property(nonatomic,assign)BOOL isPop;

@end

@implementation AddressbookViewController
{
    UITableView *addressbookTable;
    NSMutableArray *newSectionsArray;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sendRequestFriendData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _isPop = NO;
    [self customNavigationBar:@"通讯录" hasLeft:NO hasRight:YES withRightBarButtonItemImage:@"addfriend"];
    
    [self initUI];
    //[self sendRequestFriendData];
    
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    self.navigationItem.title = title;
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 25, 25);
    right.center = barView.center;
    [right setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:right];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barView];
}
- (void)rightBarClick
{
    AddFriendViewController *add = StoryBoard(@"Addressbook", @"add")
    add.hidesBottomBarWhenPushed = YES;
    PushController(add)
}
- (void)initUI
{
    //搜索框
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 55)];
    
    UIButton *search = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    search.layer.borderWidth = 1;
    search.layer.cornerRadius = 5;
    search.layer.masksToBounds = YES;
    search.layer.borderColor = RGBColor(220, 220, 220).CGColor;
    search.backgroundColor = [UIColor whiteColor];
    search.frame = CGRectMake(20,10, ViewWidth-40, 35);
    [search setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    search.titleLabel.font = [UIFont systemFontOfSize:14];
    [search setTitle:@"试试搜索你所认识的人吧" forState:UIControlStateNormal];
    [search addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [head addSubview:search];
    
    addressbookTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight) style:UITableViewStylePlain];
    addressbookTable.delegate = self;
    addressbookTable.dataSource = self;
    addressbookTable.rowHeight = 55;
    addressbookTable.backgroundColor = BaseColor;
    [self.view addSubview:addressbookTable];
    [addressbookTable registerNib:[UINib nibWithNibName:@"AddressbookCell" bundle:nil] forCellReuseIdentifier:@"addressbookCell"];
    
    addressbookTable.tableHeaderView = head;
    addressbookTable.tableFooterView = [[UIView alloc]init];
}
- (void)searchClick:(UIButton *)sender{
    
    SeachViewController *search = [[SeachViewController alloc]init];
    BaseNavigationController *baseNvc = [[BaseNavigationController alloc]initWithRootViewController:search];
    baseNvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:baseNvc animated:NO completion:^{
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (newSectionsArray.count >0) {
        return newSectionsArray.count + 1;
    }else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        NSArray *arr = newSectionsArray[section-1];
        return arr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else
        return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectZero];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 15)];
    if (section != 0) {
        label.text = [NSString stringWithFormat:@"  %@",_reservedObjsArr[section-1]];
    }
    label.textColor = [UIColor lightGrayColor];
    [headview addSubview:label];
    return headview;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 6)];
    return footview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressbookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressbookCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.icon.image = [[UIImage imageNamed:@"scancode"] circleImage];
            cell.name.text = @"扫一扫";
        }else{
            cell.icon.image = [[UIImage imageNamed:@"we"] circleImage];
            cell.name.text = @"新的朋友";
        }
        cell.name.font = [UIFont systemFontWithSize:14];
        cell.callClick.hidden = YES;
        cell.icon.sd_layout.leftSpaceToView(cell.contentView,10).topSpaceToView(cell.contentView,10).widthIs(40).heightIs(40);
        cell.name.sd_layout.leftSpaceToView(cell.icon,10).topSpaceToView(cell.contentView,20).rightSpaceToView(cell.contentView,10).heightIs(20);
        [cell updateLayout];
    }else{
        AddressbookModel *model = newSectionsArray[indexPath.section-1][indexPath.row];
        [cell configCell:model];
        [cell.callClick addTarget:self action:@selector(callPhoneClick:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self scanFriendCode];
        }else{
            FriendRequestViewController *request = [[FriendRequestViewController alloc]init];
            request.hidesBottomBarWhenPushed = YES;
            PushController(request)
        }
    }else{
        AddressbookModel *model = newSectionsArray[indexPath.section-1][indexPath.row];
        PartnerViewController *partner = [[PartnerViewController alloc]init];
        partner.phone = model.tel;
        partner.hidesBottomBarWhenPushed = YES;
        PushController(partner)
        
//        FriendInfoViewController *info = [[FriendInfoViewController alloc]init];
//        info.phone = model.tel;
//        info.type = @"callPhone";
//        info.hidesBottomBarWhenPushed = YES;
//        PushController(info)
    }
}
//添加关注
- (void)callPhoneClick:(UIButton *)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint Position = [touch locationInView:addressbookTable];
    NSIndexPath *indexPath= [addressbookTable indexPathForRowAtPoint:Position];
    if (indexPath!= nil)    {
        AddressbookModel *model = newSectionsArray[indexPath.section-1][indexPath.row];
        [self sendRequestFoucsData:model.c_no sender:sender];
    }
}
#pragma mark - 姓名按首字母大写排序
- (void)sortNameByCapitalize{
    
    NSMutableArray *willDeleObjs = @[].mutableCopy;
    
    newSectionsArray = [self setObjects:_addressbookArr];
    [newSectionsArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [willDeleObjs addObject:arr];
        } else {
            [self.reservedObjsArr addObject:[[UILocalizedIndexedCollation currentCollation] sectionTitles][idx]];
        }
    }];
    // 我们可以去除掉mutableSections中空的数组
    [newSectionsArray removeObjectsInArray:willDeleObjs];
    
    //NSLog(@"reservedObjs - %@  ", _reservedObjsArr);
    
    // 打印出排序后的name
    [newSectionsArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL * _Nonnull stop) {
        for (AddressbookModel *model in arr) {
            NSLog(@"%@",model.name);
        }
    }];
    
    [addressbookTable reloadData];
}
- (NSMutableArray *)setObjects:(NSMutableArray *)objects {
    SEL selector = @selector(name);
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    // 得到collation索引数量（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    
    // 初始化数组mutableSections用来存放最终数据，我们最终要得到的数据模型应该形如 \
    @[@[以A开头的数据数组], @[以B开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    // 初始化27个空数组加入mutableSections
    for (NSInteger idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    // 将每个人按name分到某个section下
    for (id obj in objects) {
        // 获取name属性的值所在的位置，比如“林”首字母是L，在A~Z中排第11，sectionNumber则为11
        NSInteger sectionNumber = [collation sectionForObject:obj collationStringSelector:selector];
        // name为“林”的obj则加入mutableSections中的第11个数组中
        [[mutableSections objectAtIndex:sectionNumber] addObject:obj];
    }
    
    // 对每个section中的数组按照name属性排序
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objsForSection = [mutableSections objectAtIndex:idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[collation sortedArrayFromArray:objsForSection collationStringSelector:selector]];
    }
    return mutableSections;
}
- (void)scanFriendCode{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
                        scanningQRCodeVC.hidesBottomBarWhenPushed = YES;
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
            scanningQRCodeVC.hidesBottomBarWhenPushed = YES;
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//通讯录数据
- (void)sendRequestFriendData
{
    if (self.addressbookArr.count>0||newSectionsArray.count>0) {
        [self.addressbookArr removeAllObjects];
        [newSectionsArray removeAllObjects];
        [addressbookTable reloadData];
    }
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *string = [NSString stringWithFormat:AddressbookXML,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
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
                    [self.addressbookArr addObject:model];
                }
                
                [self sortNameByCapitalize];
                [addressbookTable reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//关注
- (void)sendRequestFoucsData:(NSString *)c_no sender:(UIButton *)sender
{
    NSString *str = @"<root><api><module>1105</module><type>0</type><query>{c_no=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,c_no,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"关注成功！"]) {
                if (sender.selected) {
                 [self.view makeToast:@"已关注！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }else{
                    sender.selected = YES;
                    [self.view makeToast:@"关注成功！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }
            }else if ([element.stringValue isEqualToString:@"已取消！"]){
                if (sender.selected) {
                    sender.selected = NO;
                    [self.view makeToast:@"取消关注！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }else{
                    [self.view makeToast:@"未关注！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)addressbookArr
{
    if (!_addressbookArr) {
        _addressbookArr = [NSMutableArray array];
    }
    return _addressbookArr;
}
- (NSMutableArray *)reservedObjsArr
{
    if (!_reservedObjsArr) {
        _reservedObjsArr = [NSMutableArray array];
    }
    return _reservedObjsArr;
}
@end
