//
//  SeachViewController.m
//  NewAfar
//
//  Created by cw on 16/12/28.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "SeachViewController.h"
#import "AddressbookModel.h"
#import "AddressbookCell.h"
#import "FriendInfoViewController.h"

@interface SeachViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation SeachViewController
{
    UITextField *search;
    UITableView *searchTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavigationBar];
    
    [self initUI];
}
- (void)customNavigationBar
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 30)];
    //titleView.backgroundColor = [UIColor redColor];
    
    search = [UITextField new];
    search.backgroundColor = [UIColor whiteColor];
    search.borderStyle = UITextBorderStyleRoundedRect;
    search.placeholder = @"搜索";
    search.clearButtonMode = UITextFieldViewModeWhileEditing;
    search.font = [UIFont systemFontOfSize:14];
    search.returnKeyType = UIReturnKeySearch;
    search.delegate = self;
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    icon.image = [UIImage imageNamed:@"searcicon"];
    search.leftView = icon;
    search.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *cancle = [UIButton new];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    cancle.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancle addTarget:self action:@selector(dismissClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancle setTitleColor:RGBColor(102, 146, 51) forState:UIControlStateNormal];
    
    [titleView sd_addSubviews:@[search,cancle]];
    
    search.sd_layout.leftSpaceToView(titleView,0).topSpaceToView(titleView,0).bottomSpaceToView(titleView,0).widthIs(ViewWidth-60);
    
    cancle.sd_layout.leftSpaceToView(search,0).topSpaceToView(titleView,0).bottomSpaceToView(titleView,0).widthIs(50);
    
    self.navigationItem.titleView = titleView;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self sendRequestSearchFriendData];
    return YES;
}
- (void)initUI
{
    searchTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    searchTable.rowHeight = 60;
    searchTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:searchTable];
    
    [searchTable registerNib:[UINib nibWithNibName:@"AddressbookCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    
    UIView *foot = [[UIView alloc]init];
    searchTable.tableFooterView = foot;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressbookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AddressbookModel *model = _dataArr[indexPath.row];
    [cell configCell:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressbookModel *model = _dataArr[indexPath.row];
    FriendInfoViewController *info = [[FriendInfoViewController alloc]init];
    info.model = model;
    if ([model.isfriend isEqualToString:@"0"]) {//非好友
        info.type = @"addFriend";
    }else{//好友
        info.type = @"callPhone";
    }
    info.phone = model.tel;
    PushController(info)
}
- (void)dismissClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//通讯录搜索数据
- (void)sendRequestSearchFriendData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    if (_dataArr.count>0) {
        [_dataArr removeAllObjects];
        [searchTable reloadData];
    }
    
    NSString *str = @"<root><api><querytype>2</querytype><query>{key=%@,type=1}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,search.text,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        NSLog(@"doc:%@",doc);
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
            }else
            {
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
                    if ([item elementsForName:@"isfriend"].count>0) {
                        DDXMLElement *isfriend = [item elementsForName:@"isfriend"][0];
                        model.isfriend = isfriend.stringValue;
                    }else{
                        model.isfriend = @"";
                    }
                    [self.dataArr addObject:model];
                }
                [searchTable reloadData];
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
//添加好友
- (void)senRequestAddFriendData:(NSString *)phone
{
    NSString *str = @"<root><api><module>1101</module><type>0</type><query>{tel=%@,ifck=0}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,phone,[userDefault valueForKey:@"name"],UUID];
    
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
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
