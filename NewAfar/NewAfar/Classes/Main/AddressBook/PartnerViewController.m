//
//  PartnerViewController.m
//  NewAfar
//
//  Created by cw on 17/3/17.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "PartnerViewController.h"
#import "AddressbookModel.h"
#import "InfoCell.h"
#import "FriendSettingViewController.h"

@interface PartnerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, assign) CGFloat topContentInset;

@property(nonatomic,copy)NSMutableArray *dataArr;

@property(nonatomic,assign)BOOL isPop;
@end

@implementation PartnerViewController
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
    if (_isPop) {
        if (self.dataArr.count>0) {
            [_dataArr removeAllObjects];
        }
        [self senRequestAddFriendData:_phone];
    }
    _isPop = YES;
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
    [self createHeadView];
    [self initHeadView];
    [self senRequestAddFriendData:_phone];
    NSLog(@"视图加载-----1");
    
    _isPop = NO;
    
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
    foucs.frame = CGRectMake(ViewWidth-100, 180-40, 80, 30);
    foucs.layer.borderWidth = 1;
    foucs.layer.borderColor = [UIColor whiteColor].CGColor;
    foucs.layer.cornerRadius = 5;
    foucs.layer.masksToBounds = YES;
    foucs.titleLabel.font = [UIFont systemFontWithSize:13];
    [foucs addTarget:self action:@selector(foucsClick:) forControlEvents:UIControlEventTouchUpInside];
    [headBkView addSubview:foucs];
}
- (void)foucsClick:(UIButton *)sender{
    AddressbookModel  *model = _dataArr[0];
    [self sendRequestFoucsData:model.c_no sender:sender];
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
    
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight-180-240-64)];
    foot.backgroundColor = [UIColor whiteColor];
    personalTable.tableFooterView = foot;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ViewWidth-15, 1)];
    line.backgroundColor = RGBColor(237, 237, 238);
    [foot addSubview:line];
    
    UIButton *call = [UIButton buttonWithType:UIButtonTypeCustom];
    call.frame = CGRectMake(10, 10, ViewWidth/2-20, 35);
    [call setTitle:@"拨打电话" forState:UIControlStateNormal];
    [call setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [call addTarget:self action:@selector(callPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:call];
    
    UIButton *set = [UIButton buttonWithType:UIButtonTypeCustom];
    set.frame = CGRectMake(10+ViewWidth/2, 10, ViewWidth/2-20, 35);
    [set setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [set setTitle:@"设置" forState:UIControlStateNormal];
    [set addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:set];
}
- (void)callPhoneClick:(UIButton *)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phone]]];
}
- (void)settingClick:(UIButton *)sender{
    FriendSettingViewController *setting = [[FriendSettingViewController alloc]init];
    AddressbookModel  *model = _dataArr[0];
    setting.model = model;
    PushController(setting)
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = @[@"  昵   称",@"  性   别",@"  手机号",@"  职   位",@"  生   日",@"  爱   好"];
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.font = [UIFont systemFontWithSize:13];
    cell.title.font = [UIFont systemFontWithSize:13];
    cell.name.text = arr[indexPath.row];
    AddressbookModel  *model = _dataArr[0];
    if (indexPath.row == 0) {
        cell.title.text = model.nickname;
    }else if (indexPath.row == 1){
        cell.title.text = model.sex;
    }else if (indexPath.row == 2){
        cell.title.text = model.tel;
    }else if (indexPath.row == 3){
        cell.title.text = model.zw;
    }else if (indexPath.row == 4){
        NSString *birth = [model.sr componentsSeparatedByString:@"T"][0];
       cell.title.text = birth;
    }else if (indexPath.row == 5){
        cell.title.text = model.ah;
    }
    return cell;
}
- (void)initHeadView
{
    //_topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth,ViewWidth*435.5/414.0)];
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth,ViewHeight)];
    _topImageView.backgroundColor = [UIColor whiteColor];
    _topImageView.image = [UIImage imageNamed:@"bg"];
    [self.view insertSubview:_topImageView belowSubview:personalTable];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//添加好友0 -手机号搜索 1- 关键字搜索
- (void)senRequestAddFriendData:(NSString *)phone
{
//    if (self.dataArr.count>0) {
//        [_dataArr removeAllObjects];
//    }
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><querytype>2</querytype><query>{key=%@,type=0}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_phone,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
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
                    DDXMLElement *nickname = [item elementsForName:@"nickname"][0];
                    model.nickname = nickname.stringValue;
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
                    DDXMLElement *sr = [item elementsForName:@"sr"][0];
                    model.sr = sr.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    postion.text = name.stringValue;
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    if ([tx.stringValue isEqualToString:@""]||[tx.stringValue isEqualToString:@"0"]) {
                        [icon setBackgroundImage:[UIImage imageNamed:@"avatar_zhixing"] forState:UIControlStateNormal];
                    }else{
                        [icon sd_setBackgroundImageWithURL:[NSURL URLWithString:tx.stringValue] forState:UIControlStateNormal];
                    }
                    model.tx = tx.stringValue;
                    DDXMLElement *gztype = [item elementsForName:@"gztype"][0];
                    model.gztype = gztype.stringValue;
                    if ([gztype.stringValue isEqualToString:@"0"]) {
                        [foucs setTitle:@"+ 关注" forState:UIControlStateNormal];
                    }else{
                        [foucs setTitle:@"已关注" forState:UIControlStateNormal];
                    }
                    DDXMLElement *isfriend = [item elementsForName:@"isfriend"][0];
                    model.isfriend = isfriend.stringValue;
                    DDXMLElement *isoneqy = [item elementsForName:@"isoneqy"][0];
                    model.isoneqy = isoneqy.stringValue;
                    DDXMLElement *iflook = [item elementsForName:@"iflook"][0];
                    model.iflook = iflook.stringValue;
                    [self.dataArr addObject:model];
                }
                [personalTable reloadData];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
