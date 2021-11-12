//
//  MoreViewController.m
//  NewAfar
//
//  Created by cw on 17/2/21.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreModel.h"
#import "MoreCell.h"

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation MoreViewController
{
    UITableView *moreTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"浏览记录" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestPersonData];
}
- (void)initUI{
    moreTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    moreTable.delegate = self;
    moreTable.dataSource = self;
    moreTable.rowHeight = 40;
    [self.view addSubview:moreTable];
    
    [moreTable registerNib:[UINib nibWithNibName:@"MoreCell" bundle:nil] forCellReuseIdentifier:@"moreCell"];
    
    UIView *foot = [[UIView alloc]init];
    moreTable.tableFooterView = foot;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MoreModel *model = _dataArr[indexPath.row];
    [cell configCell:model];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查看人员
- (void)sendRequestPersonData{
    NSString *company = [userDefault valueForKey:@"qyno"];
    NSString *qyno = [company substringToIndex:3];
    
    NSString *str = @"<root><api><module>1410</module><type>0</type><query>{c_id=%@,qyno=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_cid,qyno,company,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    MoreModel *model = [[MoreModel alloc]init];
                    if ([item elementsForName:@"c_real_name"].count>0) {
                        DDXMLElement *c_real_name = [item elementsForName:@"c_real_name"][0];
                        model.c_real_name = c_real_name.stringValue;
                    }
                    DDXMLElement *dt = [item elementsForName:@"dt"][0];
                    model.dt = dt.stringValue;
                    [self.dataArr addObject:model];
                }
            }else{
                [self.view makeToast:element.stringValue];
            }
            [moreTable reloadData];
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
