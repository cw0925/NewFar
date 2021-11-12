//
//  LoginViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/19.
//  Copyright © 2016年 CW. All rights reserved.
//
#import "LoginViewController.h"
#import "ScrollModel.h"
#import "BaseTabBarController.h"
#import "RegistViewController.h"
#import "CycleScrollView.h"
#import "FindPasswordViewController.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "SetDomainViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bg_Scroll;
@property (weak, nonatomic) IBOutlet UIView *bg_Login;
@property (weak, nonatomic) IBOutlet UITextField *user_Name;
@property (weak, nonatomic) IBOutlet UITextField *user_Password;
- (IBAction)userLoginClick:(UIButton *)sender;
- (IBAction)userRegistClick:(UIButton *)sender;
- (IBAction)callClick:(UIButton *)sender;
- (IBAction)rememberClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *remember;
- (IBAction)forgetPassword:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *regist;
@property(nonatomic,copy)NSMutableArray *scrollArr;

@property (weak, nonatomic) IBOutlet UILabel *remeberPsd;
@property (weak, nonatomic) IBOutlet UIButton *forgetPsd;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UIButton *setting;
- (IBAction)settingClick:(UIButton *)sender;

@end

@implementation LoginViewController
{
    CycleScrollView *cycleScroll;
    
    NSString *currentVersion;
    NSString *appstoreVersion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"管翼通2.0";
    [self initInputView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self sendRequestScrollViewData];
    
    [self noticeUserUpdate];
}
#pragma mark - 版本更新
- (void)noticeUserUpdate
{
    currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    [mgr POST:@"http://itunes.apple.com/lookup?id=1144062674" parameters:nil headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray *arr = resultDic[@"results"];
        NSDictionary *dic = [arr lastObject];
        appstoreVersion = dic[@"version"];
        NSArray *currentArr = [currentVersion componentsSeparatedByString:@"."];//2.0.0
        NSArray *appstoreArr = [appstoreVersion componentsSeparatedByString:@"."];//1.4
        NSMutableArray *arrM = [NSMutableArray arrayWithArray:appstoreArr];
        if (arrM.count<3) {
            [arrM insertObject:@"0" atIndex:2];
        }
        if ([currentArr[0] integerValue]<[appstoreArr[0] integerValue]) {
            [self showUpdateView];
        }else if ([currentArr[0] integerValue]==[appstoreArr[0] integerValue]){
            if ([currentArr[1] integerValue]<[appstoreArr[1] integerValue]) {
                [self showUpdateView];
            }else if ([currentArr[1] integerValue]==[appstoreArr[1] integerValue]){
                if ([currentArr[2] integerValue]<[arrM[2] integerValue]) {
                    [self showUpdateView];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
//    [mgr POST:@"http://itunes.apple.com/lookup?id=1144062674" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//       NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSArray *arr = resultDic[@"results"];
//        NSDictionary *dic = [arr lastObject];
//        appstoreVersion = dic[@"version"];
//        NSArray *currentArr = [currentVersion componentsSeparatedByString:@"."];//2.0.0
//        NSArray *appstoreArr = [appstoreVersion componentsSeparatedByString:@"."];//1.4
//        NSMutableArray *arrM = [NSMutableArray arrayWithArray:appstoreArr];
//        if (arrM.count<3) {
//            [arrM insertObject:@"0" atIndex:2];
//        }
//        if ([currentArr[0] integerValue]<[appstoreArr[0] integerValue]) {
//            [self showUpdateView];
//        }else if ([currentArr[0] integerValue]==[appstoreArr[0] integerValue]){
//            if ([currentArr[1] integerValue]<[appstoreArr[1] integerValue]) {
//                [self showUpdateView];
//            }else if ([currentArr[1] integerValue]==[appstoreArr[1] integerValue]){
//                if ([currentArr[2] integerValue]<[arrM[2] integerValue]) {
//                    [self showUpdateView];
//                }
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
}
- (void)showUpdateView
{
    [self.view endEditing:YES];
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"当前版本是V%@,发现新版本V%@，是否更新？",currentVersion,appstoreVersion] cancelBtnTitle:@"取消" otherBtnTitle:@"更新" clickIndexBlock:^(NSInteger clickIndex) {
        NSLog(@"点击index====%ld",clickIndex);
        if (clickIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/guan-yi-tong/id1144062674?mt=8"]];
        }
    }];
    [alert showLXAlertView];
}
//轮播图
- (void)initUI
{
    cycleScroll = [[CycleScrollView alloc]init];
    cycleScroll.iconArr = _scrollArr;
    [cycleScroll createScrollView:_bg_Scroll];
}
//输入框
- (void)initInputView
{
    _regist.titleLabel.font = [UIFont systemFontWithSize:12];
    _setting.titleLabel.font = [UIFont systemFontWithSize:12];
    _remeberPsd.font = [UIFont systemFontWithSize:12];
    _forgetPsd.titleLabel.font = [UIFont systemFontWithSize:12];
    _company.font = [UIFont systemFontWithSize:12];
    
    UIView *bg_name = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    //bg_name.backgroundColor = [UIColor redColor];
    UIImageView *name_img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    name_img.image = [UIImage imageNamed:@"username"];
    [bg_name addSubview:name_img];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 60, 30)];
    name.text = @"用户名";
    name.font = [UIFont systemFontWithSize:13];
    [bg_name addSubview:name];
    _user_Name.leftView = bg_name;
    _user_Name.leftViewMode = UITextFieldViewModeAlways;
    _user_Name.font = [UIFont systemFontWithSize:13];
    
    UIView *bg_psd = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    //bg_psd.backgroundColor = [UIColor redColor];
    UIImageView *psd_img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    psd_img.image = [UIImage imageNamed:@"password"];
    [bg_psd addSubview:psd_img];
    UILabel *psd = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 60, 30)];
    psd.text = @"密   码";
    psd.font = [UIFont systemFontWithSize:13];
    [bg_psd addSubview:psd];
    _user_Password.leftView = bg_psd;
    _user_Password.leftViewMode = UITextFieldViewModeAlways;
    _user_Password.font = [UIFont systemFontWithSize:13];
    _user_Password.returnKeyType = UIReturnKeyGo;
    _user_Password.delegate = self;
    //输入框默认
    if ([userDefault valueForKey:@"name"]) {
        _user_Name.text = [userDefault valueForKey:@"name"];
    }
    if ([userDefault boolForKey:@"isRemember"]) {
        _remember.selected = YES;
        if ([userDefault valueForKey:@"password"]) {
            _user_Password.text = [userDefault valueForKey:@"password"];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - return键登录
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_user_Name.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入用户名！"];
    }else if (![JudgePhone judgePhoneNumber:_user_Name.text]){
        [self.view makeToast:@"请输入正确的手机号！"];
    }else if ([_user_Password.text isEqualToString:@""]){
        [self.view makeToast:@"请输入密码！"];
    }else{
        [MBProgressHUD showMessag:@"正在登录,请稍候" toView:self.view];
        //判断是否绑定企业
        [self userBindsCompanyData];
    }
    return YES;
}
#pragma mark - 登录实现
- (IBAction)userLoginClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_user_Name.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入用户名！"];
    }else if (![JudgePhone judgePhoneNumber:_user_Name.text]){
        [self.view makeToast:@"请输入正确的手机号！"];
    }else if ([_user_Password.text isEqualToString:@""]){
        [self.view makeToast:@"请输入密码！"];
    }else{
        [MBProgressHUD showMessag:@"正在登录,请稍候" toView:self.view];
        //判断是否绑定企业
        [self userBindsCompanyData];
    }
}
#pragma mark - 注册
- (IBAction)userRegistClick:(UIButton *)sender {
    RegistViewController *regist = StoryBoard(@"Login", @"regist")
    [regist returnText:^(NSString *showText) {
        _user_Name.text = showText;
    }];
    [self.navigationController pushViewController:regist animated:YES];
}
//客服电话
- (IBAction)callClick:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-609-6980"]];
}
#pragma mark - 记住密码
- (IBAction)rememberClick:(UIButton *)sender {
    if (!sender.selected) {
        NSLog(@"选中");
        [userDefault setBool:YES forKey:@"isRemember"];
    }else
    {
        [userDefault setBool:NO forKey:@"isRemember"];
        NSLog(@"未选中");
    }
    sender.selected = !sender.selected;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//忘记密码
- (IBAction)forgetPassword:(UIButton *)sender {
    FindPasswordViewController *find = StoryBoard(@"Login", @"find")
    PushController(find)
}
//轮播图数据
- (void)sendRequestScrollViewData
{
    [NetRequest sendRequest:InfoURL parameters:ScrollXML success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"轮播图数据：%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            ScrollModel *model = [[ScrollModel alloc]init];
            DDXMLElement *path = [element elementsForName:@"path"][0];
            model.path = path.stringValue;
            DDXMLElement *url = [element elementsForName:@"url"][0];
            model.url = url.stringValue;
            [self.scrollArr addObject:model];
        }
        [self initUI];
    } failure:^(NSError *error) {
        
    }];
}
//登录请求数据
- (void)sendRequestLoginData:(NSString *)company
{
    NSString *str = @"<root><api><module>1002</module><type>0</type><query>{psw=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_user_Password.text,company,_user_Name.text,UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        NSLog(@"%@",doc);
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"登陆成功！"]) {
                [self.view makeToast:element.stringValue];
            }else
            {
                //销售数据查询单位（1 元 2 万元）
                NSArray *unitArr = [doc nodesForXPath:@"//Unit" error:nil];
                for (DDXMLElement *element in unitArr) {
                    [userDefault setValue:element.stringValue forKey:@"unit"];
                }
                //手机号
                [userDefault setValue:_user_Name.text forKey:@"name"];
                //记住密码
                if ([userDefault boolForKey:@"isRemember"]) {
                    [userDefault setValue:_user_Password.text forKey:@"password"];
                    NSLog(@"%@",[userDefault valueForKey:@"name"]);
                }
                [userDefault synchronize];
                BaseTabBarController *root = [[BaseTabBarController alloc]init];
                [UIApplication sharedApplication].keyWindow.rootViewController = root;
            }
            /*
             推送设置别名
             */
            NSString *phone = [userDefault valueForKey:@"name"];
            [JPUSHService setTags:nil alias:phone fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"%d-------------%@-------------%@",iResCode,iTags,iAlias);
            }];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:[error localizedDescription]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark- 判断用户是否绑定企业-权限管理
- (void)userBindsCompanyData
{
    NSString *str = @"<root><user><company></company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_user_Name.text];
    [NetRequest sendRequest:BindCompanyURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"已绑定过企业！"]) {
                [userDefault setBool:YES forKey:@"bind"];
                //企业号-009
                NSArray *qyArr = [doc nodesForXPath:@"//qyno" error:nil];
                for (DDXMLElement *item in qyArr) {
                    [userDefault setValue:item.stringValue forKey:@"qyno"];
                }
                //企业名-商翼测试
                NSArray *qynameArr = [doc nodesForXPath:@"//qyname" error:nil];
                for (DDXMLElement *item in qynameArr) {
                    [userDefault setValue:item.stringValue forKey:@"qyname"];
                }
                //企业-009
                NSArray *noArr = [doc nodesForXPath:@"//no" error:nil];
                for (DDXMLElement *item in noArr) {
                    [userDefault setValue:item.stringValue forKey:@"no"];
                }
                //名称-商翼测试
                NSArray *nameArr = [doc nodesForXPath:@"//name" error:nil];
                for (DDXMLElement *item in nameArr) {
                    [userDefault setValue:item.stringValue forKey:@"company"];
                }
                //判断是否多机构 0-单机构 1- 多机构
                NSArray *storetypeArr = [doc nodesForXPath:@"//storetype" error:nil];
                for (DDXMLElement *item in storetypeArr) {
                    [userDefault setValue:item.stringValue forKey:@"storetype"];
                }
                //机构-102
                NSArray *storeArr = [doc nodesForXPath:@"//store" error:nil];
                for (DDXMLElement *item in storeArr) {
                    [userDefault setValue:item.stringValue forKey:@"store"];
                }
                //部门
                NSArray *dnoArr = [doc nodesForXPath:@"//dno" error:nil];
                for (DDXMLElement *item in dnoArr) {
                    [userDefault setValue:item.stringValue forKey:@"dno"];
                }
                NSArray *dnameArr = [doc nodesForXPath:@"//dname" error:nil];
                for (DDXMLElement *item in dnameArr) {
                    [userDefault setValue:item.stringValue forKey:@"dname"];
                }
                //模块权限0 - 未开通 1- 开通
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {//模块权限解析开始
                    //数据报表
                    if ([item elementsForName:@"sjbb"].count>0) {
                        DDXMLElement *sjbb = [item elementsForName:@"sjbb"][0];
                        if ([sjbb.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"sjbb"];
                            //销售查询
                            if ([item elementsForName:@"xscx"].count>0) {
                                DDXMLElement *xscx = [item elementsForName:@"xscx"][0];
                                if ([xscx.stringValue isEqualToString:@"1"]) {
                                    [userDefault setBool:YES forKey:@"xscx"];
                                }else{
                                    [userDefault setBool:NO forKey:@"xscx"];
                                }
                            }else{
                               [userDefault setBool:NO forKey:@"xscx"];
                            }
                            //付款统计
                            if ([item elementsForName:@"fktj"].count>0) {
                                DDXMLElement *fktj = [item elementsForName:@"fktj"][0];
                                if ([fktj.stringValue isEqualToString:@"1"]) {
                                    [userDefault setBool:YES forKey:@"fktj"];
                                }else{
                                    [userDefault setBool:NO forKey:@"fktj"];
                                }
                            }else{
                                 [userDefault setBool:NO forKey:@"fktj"];
                            }
                            //实时监测
                            if ([item elementsForName:@"ssjc"].count>0) {
                                DDXMLElement *ssjc = [item elementsForName:@"ssjc"][0];
                                if ([ssjc.stringValue isEqualToString:@"1"]) {
                                    [userDefault setBool:YES forKey:@"ssjc"];
                                }else{
                                    [userDefault setBool:NO forKey:@"ssjc"];
                                }
                            }else{
                                [userDefault setBool:NO forKey:@"ssjc"];
                            }
                            //店长视图
                            if ([item elementsForName:@"dzst"].count>0) {
                                DDXMLElement *dzst = [item elementsForName:@"dzst"][0];
                                if ([dzst.stringValue isEqualToString:@"1"]) {
                                    [userDefault setBool:YES forKey:@"dzst"];
                                }else{
                                    [userDefault setBool:NO forKey:@"dzst"];
                                }
                            }else{
                                [userDefault setBool:NO forKey:@"dzst"];
                            }
                            //商品查询
                            if ([item elementsForName:@"spcx"].count>0) {
                                DDXMLElement *spcx = [item elementsForName:@"spcx"][0];
                                if ([spcx.stringValue isEqualToString:@"1"]) {
                                    [userDefault setBool:YES forKey:@"spcx"];
                                }else{
                                    [userDefault setBool:NO forKey:@"spcx"];
                                }
                            }else{
                                [userDefault setBool:NO forKey:@"spcx"];
                            }
                            if ([item elementsForName:@"jgcx"].count>0) {
                                DDXMLElement *jgcx = [item elementsForName:@"jgcx"][0];
                                if ([jgcx.stringValue isEqualToString:@"1"]) {//机构查询
                                    [userDefault setBool:YES forKey:@"jgcx"];
                                }else{
                                    [userDefault setBool:NO forKey:@"jgcx"];
                                }
                            }else{
                                [userDefault setBool:NO forKey:@"jgcx"];
                            }
                        }else{
                            [userDefault setBool:NO forKey:@"sjbb"];
                        }
                    }else{
                         [userDefault setBool:NO forKey:@"sjbb"];
                    }
                    //巡场管理
                    if ([item elementsForName:@"xcgl"].count>0) {
                        DDXMLElement *xcgl = [item elementsForName:@"xcgl"][0];//巡场管理
                        if ([xcgl.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"xcgl"];
                            if ([item elementsForName:@"xcwrite"].count>0) {
                                DDXMLElement *xcwrite = [item elementsForName:@"xcwrite"][0];
                                if ([xcwrite.stringValue isEqualToString:@"1"]) {//巡场读写
                                    [userDefault setBool:YES forKey:@"xcwrite"];
                                }else{
                                    [userDefault setBool:NO forKey:@"xcwrite"];
                                }
                            }else{
                                [userDefault setBool:NO forKey:@"xcwrite"];
                            }
                        }else{
                            [userDefault setBool:NO forKey:@"xcgl"];
                        }
                    }else{
                       [userDefault setBool:NO forKey:@"xcgl"];
                    }
                    //客诉处理
                    if ([item elementsForName:@"kscl"].count>0) {
                        DDXMLElement *kscl = [item elementsForName:@"kscl"][0];//客诉处理
                        if ([kscl.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"kscl"];
                            if ([item elementsForName:@"kswrite"].count>0) {
                                DDXMLElement *kswrite = [item elementsForName:@"kswrite"][0];
                                if ([kswrite.stringValue isEqualToString:@"1"]) {//客诉读写
                                    [userDefault setBool:YES forKey:@"kswrite"];
                                }else{
                                    [userDefault setBool:NO forKey:@"kswrite"];
                                }
                            }else{
                                [userDefault setBool:NO forKey:@"kswrite"];
                            }
                        }else{
                            [userDefault setBool:NO forKey:@"kscl"];
                        }
                    }else{
                        [userDefault setBool:NO forKey:@"kscl"];
                    }
                    //谏言反馈
                    if ([item elementsForName:@"jyfk"].count>0) {
                        DDXMLElement *jyfk = [item elementsForName:@"jyfk"][0];//谏言反馈
                        
                        if ([jyfk.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"jyfk"];
                        }else{
                            [userDefault setBool:NO forKey:@"jyfk"];
                        }
                    }else{
                        [userDefault setBool:NO forKey:@"jyfk"];
                    }
                    //企业公告
                    if ([item elementsForName:@"qygg"].count>0) {
                        DDXMLElement *qygg = [item elementsForName:@"qygg"][0];//企业公告
                        if ([qygg.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"qygg"];
                        }else{
                            [userDefault setBool:NO forKey:@"qygg"];
                        }
                    }else{
                        [userDefault setBool:NO forKey:@"qygg"];
                    }
                    //生日提醒
                    if ([item elementsForName:@"srtx"].count>0) {
                        DDXMLElement *srtx = [item elementsForName:@"srtx"][0];//生日提醒
                        if ([srtx.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"srtx"];
                        }else{
                            [userDefault setBool:NO forKey:@"srtx"];
                        }
                    }else{
                        [userDefault setBool:NO forKey:@"srtx"];
                    }
                    //精彩分享
                    if ([item elementsForName:@"jcfx"].count>0) {
                        DDXMLElement *jcfx = [item elementsForName:@"jcfx"][0];//精彩分享
                        if ([jcfx.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"jcfx"];
                        }else{
                            [userDefault setBool:NO forKey:@"jcfx"];
                        }
                    }else{
                       [userDefault setBool:NO forKey:@"jcfx"];
                    }
                    //工作日志
                    if ([item elementsForName:@"gzrz"].count>0) {
                        DDXMLElement *gzrz = [item elementsForName:@"gzrz"][0];//工作日志
                        if ([gzrz.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"gzrz"];
                        }else{
                            [userDefault setBool:NO forKey:@"gzrz"];
                        }
                    }else{
                        [userDefault setBool:NO forKey:@"gzrz"];
                    }
                    //零售资讯
                    if ([item elementsForName:@"lszx"].count>0) {
                        DDXMLElement *lszx = [item elementsForName:@"lszx"][0];//零售资讯
                        if ([lszx.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"lszx"];
                        }else{
                            [userDefault setBool:NO forKey:@"lszx"];
                        }
                    }else{
                        [userDefault setBool:NO forKey:@"lszx"];
                    }
                    //职场圈
                    if ([item elementsForName:@"zcq"].count>0) {
                        DDXMLElement *zcq = [item elementsForName:@"zcq"][0];//职场圈
                        if ([zcq.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"zcq"];
                        }else{
                            [userDefault setBool:NO forKey:@"zcq"];
                        }
                    }else{
                        [userDefault setBool:NO forKey:@"zcq"];
                    }
                    //通讯录
                    if ([item elementsForName:@"txl"].count>0) {
                        DDXMLElement *txl = [item elementsForName:@"txl"][0];//通讯录
                        if ([txl.stringValue isEqualToString:@"1"]) {
                            [userDefault setBool:YES forKey:@"txl"];
                        }else{
                            [userDefault setBool:NO forKey:@"txl"];
                        }
                    }else{
                       [userDefault setBool:NO forKey:@"txl"];
                    }//模块权限解析结束
                }
                //登录
                [self sendRequestLoginData:[userDefault valueForKey:@"qyno"]];
            }else{//未绑定企业
                [userDefault setBool:NO forKey:@"bind"];
                [userDefault setValue:element.stringValue forKey:@"msg"];
                [userDefault setValue:@"" forKey:@"qyno"];
                [userDefault setBool:YES forKey:@"jcfx"];//精彩分享
                [userDefault setBool:YES forKey:@"gzrz"];//工作日志
                [userDefault setBool:YES forKey:@"lszx"];//零售资讯
                [userDefault setBool:YES forKey:@"srtx"];//生日提醒
                //登录
                [self sendRequestLoginData:@""];
            }
            [userDefault synchronize];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:[error localizedDescription]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
- (NSMutableArray *)scrollArr
{
    if (!_scrollArr) {
        _scrollArr = [NSMutableArray array];
    }
    return _scrollArr;
}
#pragma mark - 配置域名
- (IBAction)settingClick:(UIButton *)sender {
    SetDomainViewController *domain = [[SetDomainViewController alloc]init];
    PushController(domain)
}
#pragma mark - 竖屏设置
- (BOOL)shouldAutorotate
{
    return NO;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
