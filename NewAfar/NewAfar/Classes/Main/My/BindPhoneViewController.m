//
//  BindPhoneViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/1.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BindPhoneViewController.h"

@interface BindPhoneViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *bindphone;
- (IBAction)bindPhoneClick:(UIButton *)sender;

@property(nonatomic,copy)NSMutableArray *dataArr;
@end

@implementation BindPhoneViewController
{
    UIView *bg_search;
    UITableView *searchTable;
    UITextField *search;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"绑定手机" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI
{
    self.view.backgroundColor = BaseColor;
    
    [_bindphone addTarget:self action:@selector(tefieldChange:) forControlEvents:UIControlEventEditingDidBegin];
}
//弹出搜索框
- (void)tefieldChange:(UITextField *)textfield
{
    bg_search = [[UIView alloc]initWithFrame:CGRectMake(ViewWidth*0.15, 64+20, ViewWidth*0.7, ViewHeight*0.5)];
    //bg_search.backgroundColor = [UIColor clearColor];
    search = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bg_search.frame), 30)];
    search.backgroundColor = RGBColor(211, 212, 213);
    search.placeholder = @"请输入企业关键字";
    [bg_search addSubview:search];
    //左视图
    UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
    left.image = [UIImage imageNamed:@"img_classify_btn_normal"];
    search.leftView = left;
    search.leftViewMode = UITextFieldViewModeAlways;
    //右视图
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 50, 30);
    [right setTitle:@"搜索" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchUpInside];
    search.rightView = right;
    search.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:bg_search];
}
//点击搜索，弹出搜索结果
- (void)showSearchView
{
    [self.view endEditing:YES];
    if ([search.text isEqualToString:@""]) {
        [self.view makeToast:@"请至少输入一个关键字！"];
    }else
    {
        [self showCompanyView];
        [self sendRequestBusinessData];
    }
}
- (void)showCompanyView
{
    searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, CGRectGetWidth(bg_search.frame), CGRectGetHeight(bg_search.frame)-30) style:UITableViewStylePlain];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    //searchTable.backgroundColor = [UIColor clearColor];
    [bg_search addSubview:searchTable];
    [searchTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"businessCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArr.count == 0) {
        return 0;
    }else
        return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"businessCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    //cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _bindphone.text = [_dataArr[indexPath.row] componentsSeparatedByString:@" "][0];
    [bg_search removeFromSuperview];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if (bg_search) {
        [bg_search removeFromSuperview];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//绑定手机号
- (IBAction)bindPhoneClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [self sendRequestBindPhoneData];
}
#pragma mark - 绑定手机
- (void)sendRequestBindPhoneData
{
    NSString *str = @"<root><api><module>1403</module><type>0</type><query>{cid=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"],UUID];
    
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
//加载企业
- (void)sendRequestBusinessData
{
    if (_dataArr.count>0) {
        [_dataArr removeAllObjects];
    }
    NSString *str = @"<root><api><module>0000</module><type>0</type><querytype>1</querytype><query>[c_name like '%%']</query></api><user><company/><customeruser/></user></root>";
    NSMutableString *strM = [NSMutableString stringWithString:str];
    NSRange range = [strM rangeOfString:@"%"];
    [strM insertString:[NSString stringWithFormat:@"%@",search.text] atIndex:range.location+1];

    [NetRequest sendRequest:InfoURL parameters:strM success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                [self.view makeToast:element.stringValue];
                return ;
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    [self.dataArr addObject:name.stringValue];
                }
                [searchTable reloadData];
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
