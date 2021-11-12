//
//  GoodSaleViewController.m
//  NewFarSoft
//
//  Created by huanghuixiang on 16/9/1.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "GoodSaleViewController.h"
#import "ScanningViewController.h"
#import "GoodSaleResultViewController.h"
#import "PickView.h"

@interface GoodSaleViewController ()<BtnClickDelegate>
@property (weak, nonatomic) IBOutlet UITextField *goodcode;
@property (weak, nonatomic) IBOutlet UITextField *barcode;
@property (weak, nonatomic) IBOutlet UITextField *goodname;
@property (weak, nonatomic) IBOutlet UITextField *organization;
- (IBAction)scanCodeClick:(UIButton *)sender;
- (IBAction)queryClick:(UIButton *)sender;

@property(nonatomic,copy)NSMutableArray *organizationArr;

@end

@implementation GoodSaleViewController
{
    PickView *pick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _organizationArr = [NSMutableArray array];

    [self customNavigationBar:@"商品销售查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self sendRequestOrganizationData];
}
- (void)initUI
{
    [_organization addTarget:self action:@selector(textfieldClick:) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)textfieldClick:(UITextField *)textfield
{
    pick = [[PickView alloc]initPickViewWithArray:_organizationArr];
    pick.clickDelegate = self;
    [pick showPickViewWhenClick:_organization];
}
- (void)btnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        _organization.text = [pick.title.text componentsSeparatedByString:@" "][0];
    }
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
            _barcode.text = string;
        }];
        [self.navigationController pushViewController:scan animated:YES];
    }
}
//查询结果
- (IBAction)queryClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_organization.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择机构！"];
    }else
    {
        GoodSaleResultViewController *goodRes = [[GoodSaleResultViewController alloc]init];
        goodRes.goodcode = _goodcode.text;
        goodRes.barcode = _barcode.text;
        goodRes.goodname = _goodname.text;
        goodRes.organization = _organization.text;
        PushController(goodRes)
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//机构
- (void)sendRequestOrganizationData
{
    //2-机构、3-分类、4-部门
    NSString *str = @"<root><api><querytype>2</querytype></api><user><company>009105</company><customeruser>18516901925</customeruser></user></root>";
    //NSString *string = [NSString stringWithFormat:str,type];
    
    [NetRequest sendRequest:InfoURL parameters:str success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            DDXMLElement *name = [element elementsForName:@"name"][0];
            [self.organizationArr addObject:name.stringValue];
        }
        [self initUI];
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
