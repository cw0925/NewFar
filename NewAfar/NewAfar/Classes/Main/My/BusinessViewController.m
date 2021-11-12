//
//  BusinessViewController.m
//  NewAfar
//
//  Created by CW on 2017/4/18.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "BusinessViewController.h"

@interface BusinessViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation BusinessViewController
{
    UITextField *search;
    UITableView *businessTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"企业搜素" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI{
    //搜索框
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 55)];
    
    search = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, ViewWidth-40, 35)];
    search.delegate = self;
    search.placeholder = @"请输入企业关键字";
    search.font = [UIFont systemFontWithSize:14];
    search.returnKeyType = UIReturnKeySearch;
    search.borderStyle = UITextBorderStyleRoundedRect;
    
    UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    left.image = [UIImage imageNamed:@"searcicon"];
    search.leftView = left;
    search.leftViewMode = UITextFieldViewModeAlways;
    [head addSubview:search];
    
    businessTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    businessTable.delegate = self;
    businessTable.dataSource = self;
    businessTable.tableHeaderView = head;
    businessTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:businessTable];
    [businessTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontWithSize:14];
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_dataArr[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self sendRequestBusinessData];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //NSLog(@"---%@",strM);
    [NetRequest sendRequest:InfoURL parameters:strM success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                [self.view makeToast:element.stringValue];
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    [self.dataArr addObject:name.stringValue];
                }
            }
            [businessTable reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
