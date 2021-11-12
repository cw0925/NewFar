//
//  NoticeViewController.m
//  NewAfar
//
//  Created by cw on 17/1/11.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "NoticeViewController.h"
#import <WebKit/WebKit.h>
#import "MoreViewController.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController
{
    WKWebView *web;
    UIButton *btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavigationBar:@"企业公告" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    [self sendRequestReportDetailData];
}
- (void)refresh:(RefreshBlock)block{
    self.refreshBlock = block;
}
- (void)backPage{
    [super backPage];
    if (self.refreshBlock != nil) {
        self.refreshBlock(YES);
    }
}
- (void)initUI
{
    web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight-40)];
    web.scrollView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    [self.view addSubview:web];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, -60, ViewWidth, 60)];
    [web.scrollView addSubview:view];
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ViewWidth, 30)];
    title.font = [UIFont systemFontWithSize:14];
    //title.textAlignment = NSTextAlignmentCenter;
    title.text = _heading;
    [view addSubview:title];
    
    UILabel *dateP = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, ViewWidth, 30)];
    dateP.textColor = RGBColor(151, 151, 151);
    dateP.font = [UIFont systemFontWithSize:12];
    dateP.text = [NSString stringWithFormat:@"发布于%@",_date];
    [view addSubview:dateP];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 59, ViewWidth-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = BaseColor;
    btn.frame = CGRectMake(0,ViewHeight-40-BottomHeight, ViewWidth, 40);
    [btn setTitleColor:RGBColor(18,184,246) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontWithSize:14];
    [btn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)moreClick:(UIButton *)sender{
    MoreViewController *more = [[MoreViewController alloc]init];
    more.cid = _ggID;
    PushController(more)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//详情
- (void)sendRequestReportDetailData
{
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    NSString *company = [qyno substringToIndex:3];
    
    NSString *str = @"<root><api><module>1404</module><type>0</type><query>{cid=%@,type=1,ggid=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,company,_ggID,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue];
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *nr = [item elementsForName:@"nr"][0];
                    NSString *css = @"<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=yes'> <link rel='stylesheet' type='text/css' href='amazeui.min.css' > <link rel='stylesheet' type='text/css' href='app.css' >";
                    NSString *subStr = [css stringByAppendingString:nr.stringValue];
                    [web loadHTMLString:subStr baseURL:nil];
            
                }
                
                NSArray *numArr = [doc nodesForXPath:@"//num" error:nil];
                for (DDXMLElement *item in numArr) {
                    [btn setTitle:[NSString stringWithFormat:@"查看浏览记录(%@)",item.stringValue] forState:UIControlStateNormal];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
