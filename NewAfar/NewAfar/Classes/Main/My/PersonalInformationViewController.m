//
//  PersonalInformationViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "PersonalInfoModel.h"
#import "InfoCell.h"
#import "MyCodeViewController.h"

@interface PersonalInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *personalArr;

@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, assign) CGFloat topContentInset;

@end

@implementation PersonalInformationViewController
{
    UITableView *personalTable;
    UIButton *icon;
    UILabel *postion;
    
    NSString *iconUrl;
    NSString *nameStr;
    NSString *postionStr;
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
    
    [self sendRequestPersonalInfoData];
}
//自定义导航条（不带下拉文字菜单）
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
    _topContentInset = 150; //136+64=200
    
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
}

- (void)initHeadView
{
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth,ViewWidth*435.5/414.0)];
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
    
    UIView *foot = [[UIView alloc]init];
    personalTable.tableFooterView = foot;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = @[@"  昵称",@"  性别",@"  手机号",@"  职位",@"  生日",@"  爱好",@"  我的二维码"];
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = arr[indexPath.row];
    cell.name.font = [UIFont systemFontWithSize:13];
    cell.title.font = [UIFont systemFontWithSize:13];
    PersonalInfoModel *model = _personalArr[0];
    if (indexPath.row == 0) {
        cell.title.text = model.nc;
    }else if (indexPath.row == 1){
        cell.title.text = model.sex;
    }else if (indexPath.row == 2){
        cell.title.text = model.tel;
    }else if (indexPath.row == 3){
        cell.title.text = model.zw;
    }else if (indexPath.row == 4){
        cell.title.text = model.sr;
    }else if (indexPath.row == 5){
        cell.title.text = model.ah;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        MyCodeViewController *code = [[MyCodeViewController alloc]init];
        code.iconImage = iconUrl;
        code.name = nameStr;
        code.postion = postionStr;
        PushController(code)
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestPersonalInfoData
{
    NSString *str = @"<root><api><module>1301</module><type>0</type><query></query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
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
                    PersonalInfoModel *model = [[PersonalInfoModel alloc]init];
                    DDXMLElement *nc = [item elementsForName:@"nc"][0];
                    model.nc = nc.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    postion.text = name.stringValue;
                    nameStr = name.stringValue;
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
                    postionStr = zw.stringValue;
                    DDXMLElement *sr = [item elementsForName:@"sr"][0];
                    model.sr = sr.stringValue;
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    model.tx = tx.stringValue;
                    iconUrl = tx.stringValue;
                    [self.personalArr addObject:model];
                    if ([tx.stringValue isEqualToString:@""]) {
                        [icon setBackgroundImage:[UIImage imageNamed:@"avatar_zhixing"] forState:UIControlStateNormal];
                    }else{
                        //设置头像
                        [icon sd_setBackgroundImageWithURL:[NSURL URLWithString:tx.stringValue] forState:UIControlStateNormal];
                    }
                }
                [personalTable reloadData];
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
