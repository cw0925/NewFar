//
//  GoodViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/16.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "GoodViewController.h"
#import "ScanningViewController.h"
#import "GoodResultViewController.h"
#import "PickView.h"

@interface GoodViewController ()<UITextFieldDelegate,BtnClickDelegate>

@property (weak, nonatomic) IBOutlet UITextField *store;
@property (weak, nonatomic) IBOutlet UITextField *goodCode;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *goodName;
@property (weak, nonatomic) IBOutlet UITextField *plu;
- (IBAction)scanCodeClick:(UIButton *)sender;
- (IBAction)queryClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *scan;

@property(nonatomic,copy)NSMutableArray *organizationArr;

@end

@implementation GoodViewController{
    PickView *pick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"商品查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    _store.delegate = self;
    [self sendRequestOrganizationInfoData];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_store isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:_organizationArr];
        [pick showPickViewWhenClick:_store];
    }
    pick.clickDelegate = self;
}

#pragma mark - 实现点击选择器上面的取消、确定按钮的代理
- (void)btnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]){
        if ([_store isFirstResponder]) {
            _store.text = pick.title.text;
        }
        
    }
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//扫描条码
- (IBAction)scanCodeClick:(UIButton *)sender {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“管翼通”打开相机访问权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        return;
        
    }
    else
    {
        ScanningViewController *scan = [[ScanningViewController alloc]init];
        [scan sendValue:^(NSString *string) {
            _code.text = string;
        }];
        scan.code = _goodCode.text;
        scan.name = _goodName.text;
        scan.plu = _plu.text;
        [self.navigationController pushViewController:scan animated:YES];
    }
}
//查询数据
- (IBAction)queryClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_goodCode.text isEqualToString:@""]&&[_goodName.text isEqualToString:@""]&&[_code.text isEqualToString:@""]&&[_plu.text isEqualToString:@""]) {
        [self.view makeToast:@"请至少输入一个条件"];
    }else{
        GoodResultViewController *goodRes = [[GoodResultViewController alloc]init];
        NSArray *storeArray = [_store.text componentsSeparatedByString:@" "];
        goodRes.store = storeArray[0];
        goodRes.goodCode = _goodCode.text;
        goodRes.goodName = _goodName.text;
        goodRes.barcode = _code.text;
        goodRes.PLU = _plu.text;
        PushController(goodRes)
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//机构
- (void)sendRequestOrganizationInfoData
{
    //<root><api><querytype>10</querytype><query>{storetype=1}</query></api><user><company>009</company><customeruser>15939010676</customeruser></user></root>
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
                _store.text = _organizationArr[0];
            }else{
                [self.view makeToast:@"请联系企业管理员！"];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)organizationArr
{
    if (!_organizationArr) {
        _organizationArr = [NSMutableArray array];
    }
    return _organizationArr;
}
@end
