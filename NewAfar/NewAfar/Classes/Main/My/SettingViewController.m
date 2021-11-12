//
//  SettingViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "ModifyPhoneViewController.h"
#import "BindPhoneViewController.h"
#import "BindBusinessViewController.h"
#import "CommonProblemViewController.h"
#import "FeedbackViewController.h"
#import "LoginViewController.h"
#import "QuotationViewController.h"
#import "NewsViewController.h"

#import "BaseNavigationController.h"

#import <LocalAuthentication/LocalAuthentication.h>

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SettingViewController
{
    NSString *qyCode;
    NSString *qyName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"系统设置" hasLeft:YES hasRight:NO withRightBarButtonItemImage:nil];
    [self initUI];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *setTable = [[UITableView alloc]initWithFrame:CGRectMake(0,NVHeight, ViewWidth, ViewHeight-NVHeight) style:UITableViewStyleGrouped];
    setTable.delegate = self;
    setTable.dataSource = self;
    setTable.sectionFooterHeight = 5;
    setTable.sectionHeaderHeight = 5;
    setTable.rowHeight = 40;
    setTable.backgroundColor = BaseColor;
    [self.view addSubview:setTable];
    [setTable registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    setTable.tableHeaderView = view;
    
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 200)];
    //foot.backgroundColor = [UIColor greenColor];
    setTable.tableFooterView = foot;
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth/2-75, 25, 150, 150)];
    //imv.center = foot.center;
    imv.image = [UIImage imageNamed:@"newfar_code"];
    [foot addSubview:imv];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCell:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0://修改密码
            {
                ModifyPhoneViewController *phone = StoryBoard(@"Modify", @"modifyPhone")
                PushController(phone)
                break;
            }
            case 1://绑定企业
            {
                [self userBindsCompanyData];
                break;
            }
            case 2://客服热线
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-609-6980"]];
                break;
            }
            case 3://常见问题
            {
                CommonProblemViewController *problem = [[CommonProblemViewController alloc]init];
                PushController(problem)
                break;
            }
            case 4://意见反馈
            {
                QuotationViewController *quotation = StoryBoard(@"Home", @"quotation")
                quotation.hidesBottomBarWhenPushed = YES;
                PushController(quotation)
                break;
            }
            default:
                break;
        }
    }
    else
    {
        LoginViewController *login = StoryBoard(@"Login", @"login")
        [login.view makeToast:@"退出成功，请重新登录"];
        BaseNavigationController *navc = [[BaseNavigationController alloc]initWithRootViewController:login];
        [UIApplication sharedApplication].keyWindow.rootViewController = navc;
        
    }
}
//判断用户是否绑定企业
- (void)userBindsCompanyData
{
    NSString *str = @"<root><user><company></company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:BindCompanyURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"已绑定过企业！"]) {
                BindBusinessViewController *bindBusiness = StoryBoard(@"Modify", @"bindBusiness")
                NSArray *codeArr = [doc nodesForXPath:@"//qyno" error:nil];
                for (DDXMLElement *item in codeArr) {
                    qyCode = item.stringValue;
                }
                NSArray *nameArr = [doc nodesForXPath:@"//qyname" error:nil];
                for (DDXMLElement *item in nameArr) {
                    qyName = item.stringValue;
                }
                bindBusiness.store = [NSString stringWithFormat:@"%@ %@",qyCode,qyName];
                bindBusiness.isBind = YES;
                PushController(bindBusiness)
            }else if ([element.stringValue isEqualToString:@"数据地址未连通！"]){
                [self.view makeToast:@"数据地址未连通,请联系企业管理员！"];
            }else{
                BindBusinessViewController *bindBusiness = StoryBoard(@"Modify", @"bindBusiness")
                bindBusiness.store = @"";
                bindBusiness.isBind = NO;
                PushController(bindBusiness)
            }
        }
       
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
