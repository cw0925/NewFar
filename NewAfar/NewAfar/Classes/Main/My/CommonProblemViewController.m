//
//  CommonProblemViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/1.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CommonProblemViewController.h"
#import "ProblemCell.h"
#import "ProblemModel.h"

@interface CommonProblemViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation CommonProblemViewController
{
    UITableView *problemTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"常见问题" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
    [self sendRequestCommonProblemData];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    problemTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth,ViewHeight-64) style:UITableViewStyleGrouped];
    problemTable.delegate = self;
    problemTable.dataSource = self;
    problemTable.sectionHeaderHeight = 5;
    problemTable.sectionFooterHeight = 5;
    problemTable.estimatedRowHeight = 50;
    problemTable.rowHeight = UITableViewAutomaticDimension;
    problemTable.backgroundColor = BaseColor;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ViewWidth,10)];
    problemTable.tableHeaderView = view;
    [self.view addSubview:problemTable];
    [problemTable registerNib:[UINib nibWithNibName:@"ProblemCell" bundle:nil] forCellReuseIdentifier:@"problemCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProblemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"problemCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ProblemModel *model = _dataArr[indexPath.section];
    cell.title.text = [NSString stringWithFormat:@"%@、%@",model.c_id,model.program];
    cell.title.font = [UIFont systemFontWithSize:13];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestCommonProblemData
{
    NSString *str = @"<root><api><querytype>3</querytype><query></query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue];
                
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ProblemModel *model = [[ProblemModel alloc]init];
                    DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                    model.c_id = c_id.stringValue;
                    DDXMLElement *program = [item elementsForName:@"program"][0];
                    model.program = program.stringValue;
                    [self.dataArr addObject:model];
                }
                [problemTable reloadData];
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
