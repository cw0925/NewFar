//
//  FriendInfoViewController.m
//  NewAfar
//
//  Created by cw on 17/2/16.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "InfoCell.h"
#import "PersonalInfoModel.h"

@interface FriendInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *personalArr;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, assign) CGFloat topContentInset;

@end

@implementation FriendInfoViewController
{
    UITableView *personalTable;
    UIButton *icon;
    UILabel *postion;
    UIButton *foucs;
}
#pragma mark - 设置导航栏透明
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar  setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar];
    
    [self initUI];
    [self initHeadView];
    [self createHeadView];
    
    [self initFootView:_type];
    
    [self sendRequestPersonalInfoData];
}

//自定义导航条
- (void)customNavigationBar{
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 60, 30);
    [left addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    
    UIImageView *left_imv = [UIImageView new];
    left_imv.image = [UIImage imageNamed:@"back_left"];
    
    UILabel *left_title = [UILabel new];
    left_title.text = @"返回";
    left_title.font = [UIFont systemFontWithSize:14];
    left_title.textColor = [UIColor whiteColor];
    //left_title.backgroundColor = [UIColor redColor];
    
    [left sd_addSubviews:@[left_imv,left_title]];
    
    left_imv.sd_layout.leftSpaceToView(left,0).topSpaceToView(left,5).bottomSpaceToView(left,5).widthIs(20);
    
    left_title.sd_layout.leftSpaceToView(left_imv,0).topSpaceToView(left,0).rightSpaceToView(left,0).bottomSpaceToView(left,0);
    
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;//这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, leftBarButtonItem];
}

#pragma mark - 创建头像视图
- (void)createHeadView
{
    _topContentInset = 180; //136+64=200
    
    UIView * headBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, _topContentInset)];
    headBkView.backgroundColor = [UIColor clearColor];
    personalTable.tableHeaderView = headBkView;
    
    
    icon = [UIButton buttonWithType:UIButtonTypeCustom];
    icon.adjustsImageWhenHighlighted = NO;
    icon.frame = CGRectMake(0, 0, 80, 80);
    icon.center = CGPointMake(ViewWidth/2., (_topContentInset - 64)/2.);
    icon.layer.cornerRadius = 40;
    icon.layer.masksToBounds = YES;
    [headBkView addSubview:icon];
    
    postion = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame)+5, ViewWidth, 30)];
    postion.font = [UIFont systemFontWithSize:13];
    postion.textAlignment = NSTextAlignmentCenter;
    postion.textColor = [UIColor whiteColor];
    [headBkView addSubview:postion];
    
    
    foucs = [UIButton buttonWithType:UIButtonTypeCustom];
    foucs.frame = CGRectMake(ViewWidth-100, 150-40, 80, 30);
    foucs.layer.borderWidth = 1;
    foucs.layer.borderColor = [UIColor whiteColor].CGColor;
    foucs.layer.cornerRadius = 5;
    foucs.layer.masksToBounds = YES;
    foucs.titleLabel.font = [UIFont systemFontWithSize:13];
    NSLog(@"%@",_model.gztype);
    if ([_model.gztype isEqualToString:@"1"]) {
        [foucs setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [foucs setTitle:@"+ 关注" forState:UIControlStateNormal];
    }
    [foucs addTarget:self action:@selector(foucsClick:) forControlEvents:UIControlEventTouchUpInside];
    [headBkView addSubview:foucs];
    
    if ([_type isEqualToString:@"callPhone"]) {
        foucs.hidden = NO;
    }else{
        foucs.hidden = YES;
    }
}
- (void)foucsClick:(UIButton *)sender{
    [self sendRequestFoucsData:_model.c_no sender:sender];
}
- (void)initHeadView
{
    //_topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth,ViewWidth*435.5/414.0)];
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth,220)];
    _topImageView.backgroundColor = [UIColor whiteColor];
    _topImageView.image = [UIImage imageNamed:@"bg"];
    [self.view insertSubview:_topImageView belowSubview:personalTable];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    personalTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight) style:UITableViewStylePlain];
    personalTable.rowHeight = 40;
    personalTable.delegate = self;
    personalTable.dataSource = self;
    personalTable.backgroundColor = [UIColor clearColor];
    personalTable.contentInset = UIEdgeInsetsMake(64 + _topContentInset, 0, 0, 0);
    personalTable.scrollIndicatorInsets = UIEdgeInsetsMake(64 + _topContentInset, 0, 0, 0);
    personalTable.scrollEnabled = NO;
    [self.view  addSubview:personalTable];
    
    [personalTable registerNib:[UINib nibWithNibName:@"InfoCell" bundle:nil] forCellReuseIdentifier:@"personalCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_type isEqualToString:@"addFriend"]) {
        return 5;
    }else{
        return 6;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = @[@"  昵   称",@"  性   别",@"  手机号",@"  职   位",@"  生   日",@"  爱   好"];
    NSArray *arrAdd = @[@"  昵   称",@"  性   别",@"  手机号",@"  职   位",@"  爱   好"];
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.font = [UIFont systemFontWithSize:13];
    cell.title.font = [UIFont systemFontWithSize:13];
    if ([_type isEqualToString:@"addFriend"]) {
        cell.name.text = arrAdd[indexPath.row];
    }else{
        cell.name.text = arr[indexPath.row];
    }
    PersonalInfoModel *model = _personalArr[0];
    if (indexPath.row == 0) {
        cell.title.text = model.nc;
    }else if (indexPath.row == 1){
        cell.title.text = model.sex;
    }else if (indexPath.row == 2){
        if ([_type isEqualToString:@"addFriend"]) {
            NSString *subString = [model.tel substringFromIndex:3];
            NSString *string = [model.tel stringByReplacingOccurrencesOfString:subString withString:@"********"];
            cell.title.text = string;
        }else{
            cell.title.text = model.tel;
        }
    }else if (indexPath.row == 3){
        cell.title.text = model.zw;
    }else if (indexPath.row == 4){
        if ([_type isEqualToString:@"addFriend"]) {
            cell.title.text = model.ah;
        }else{
            cell.title.text = model.sr;
        }
    }else if (indexPath.row == 5){
        cell.title.text = model.ah;
    }
    return cell;
}
- (void)initFootView:(NSString *)style{
    if ([style isEqualToString:@"none"]) {
        UIView *foot = [[UIView alloc]init];
        personalTable.tableFooterView = foot;
    }else{
        UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 65)];
        personalTable.tableFooterView = foot;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50, 15, ViewWidth-100, 35);
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontWithSize:14];
        [foot addSubview:btn];
        if ([style isEqualToString:@"callPhone"]) {
            [btn setTitle:@"拨打电话" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(callPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if([style isEqualToString:@"addFriend"]){
            [btn setTitle:@"加好友" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
- (void)callPhoneClick:(UIButton *)sender{
    NSLog(@"拨打电话");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phone]]];
}
- (void)addFriend:(UIButton *)sender{
    NSLog(@"添加好友");
    [self senRequestAddFriendData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//个人信息
//添加好友0 -手机号搜索 1- 关键字搜索
//- (void)senRequestAddFriendData
//{
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    
//    NSString *str = @"<root><api><querytype>2</querytype><query>{key=%@,type=0}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
//    NSString *string = [NSString stringWithFormat:str,_phone,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
//    
//    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
//        NSData *data = (NSData *)responseObject;
//        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
//        NSLog(@"%@",doc);
//        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
//        for (DDXMLElement *element in msgArr) {
//            if (![element.stringValue isEqualToString:@"查询成功！"]) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                [self.view makeToast:element.stringValue];
//            }else{
//                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
//                for (DDXMLElement *item in rowArr) {
//                    AddressbookModel *model = [[AddressbookModel alloc]init];
//                    DDXMLElement *c_no = [item elementsForName:@"c_no"][0];
//                    model.c_no = c_no.stringValue;
//                    DDXMLElement *tel = [item elementsForName:@"tel"][0];
//                    model.tel = tel.stringValue;
//                    DDXMLElement *zw = [item elementsForName:@"zw"][0];
//                    model.zw = zw.stringValue;
//                    DDXMLElement *name = [item elementsForName:@"name"][0];
//                    model.name = name.stringValue;
//                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
//                    model.tx = tx.stringValue;
//                    DDXMLElement *gztype = [item elementsForName:@"gztype"][0];
//                    model.gztype = gztype.stringValue;
//                    DDXMLElement *isfriend = [item elementsForName:@"isfriend"][0];
//                    model.isfriend = isfriend.stringValue;
//                    DDXMLElement *isoneqy = [item elementsForName:@"isoneqy"][0];//0代表同一企业 1代表不是同一企业
//                    model.isoneqy = isoneqy.stringValue;
//                    //[self.dataArr addObject:model];
//                }
//                [personalTable reloadData];
//            }
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }];
//}
- (void)sendRequestPersonalInfoData
{
    NSString *str = @"<root><api><module>1301</module><type>0</type><query></query></api><user><company></company><customeruser>%@</customeruser><phoneno></phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_phone];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue];
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    PersonalInfoModel *model = [[PersonalInfoModel alloc]init];
                    DDXMLElement *nc = [item elementsForName:@"nc"][0];
                    model.nc = nc.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    postion.text = name.stringValue;
                    //nameStr = name.stringValue;
                    model.name = name.stringValue;
                    DDXMLElement *tel = [item elementsForName:@"tel"][0];
                    model.tel = tel.stringValue;
                    DDXMLElement *sex = [item elementsForName:@"sex"][0];
                    model.sex = sex.stringValue;
                    if ([item elementsForName:@"ah"].count>0) {
                        DDXMLElement *ah = [item elementsForName:@"ah"][0];
                        model.ah = ah.stringValue;
                    }else{
                        model.ah = @"";
                    }
                    DDXMLElement *zw = [item elementsForName:@"zw"][0];
                    model.zw = zw.stringValue;
                    //postionStr = zw.stringValue;
                    DDXMLElement *sr = [item elementsForName:@"sr"][0];
                    model.sr = sr.stringValue;
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    model.tx = tx.stringValue;
                    //iconUrl = tx.stringValue;
                    [self.personalArr addObject:model];
                    if ([tx.stringValue isEqualToString:@""]) {
                        [icon setBackgroundImage:[UIImage imageNamed:@"avatar_zhixing"]  forState:UIControlStateNormal];
                    }else{
                        //设置头像
                        [icon sd_setBackgroundImageWithURL:[NSURL URLWithString:model.tx] forState:UIControlStateNormal];
                    }
                }
                [personalTable reloadData];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
//添加好友
- (void)senRequestAddFriendData
{
    //<root><api><module>1101</module><type>0</type><query>{tel=13140015925,ifck=0}</query></api><user><company></company><customeruser>15515950185</customeruser><phoneno>lblblblblblbtt</phoneno></user></root>
    NSString *str = @"<root><api><module>1101</module><type>0</type><query>{tel=%@,ifck=0}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_phone,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            [self.view makeToast:element.stringValue];
        }
    } failure:^(NSError *error) {
        
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
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
                [self.view makeToast:@"关注成功！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
            }else if ([element.stringValue isEqualToString:@"已取消！"]){
                [sender setTitle:@"+ 关注" forState:UIControlStateNormal];
                [self.view makeToast:@"取消关注！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)personalArr
{
    if (!_personalArr) {
        _personalArr = [NSMutableArray array];
    }
    return _personalArr;
}

@end
