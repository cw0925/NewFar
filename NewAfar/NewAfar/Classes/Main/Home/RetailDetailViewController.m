//
//  RetailDetailViewController.m
//  NewAfar
//
//  Created by cw on 16/12/24.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "RetailDetailViewController.h"
#import <WebKit/WebKit.h>

@interface RetailDetailViewController ()

@end

@implementation RetailDetailViewController
{
    WKWebView *web;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavigationBar:@"资讯详情" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
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
     web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    web.scrollView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    [self.view addSubview:web];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, -60, ViewWidth, 60)];
    [web.scrollView addSubview:view];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ViewWidth, 30)];
    title.font = [UIFont systemFontWithSize:14];
    //title.textAlignment = NSTextAlignmentCenter;
    title.text = _tip;
    [view addSubview:title];
    
    UILabel *dateP = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, ViewWidth, 30)];
    dateP.textColor = RGBColor(151, 151, 151);
    dateP.font = [UIFont systemFontWithSize:12];
    dateP.text = [NSString stringWithFormat:@"发布于%@",_date];
    [view addSubview:dateP];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 59, ViewWidth-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    
    [self sendRequestDetailData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequestDetailData
{
    NSString *str = @"<root><api><module>1408</module><type>0</type><query>{id=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_title_ID,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue];
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    //DDXMLElement *tip = [item elementsForName:@"title"][0];
                    //[self customNavigationBar:tip.stringValue hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
                    DDXMLElement *nr = [item elementsForName:@"nr"][0];
                    NSString *css = @"<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=yes'> <link rel='stylesheet' type='text/css' href='amazeui.min.css' > <link rel='stylesheet' type='text/css' href='app.css' >";
                    NSString *subStr = [css stringByAppendingString:nr.stringValue];
                    [web loadHTMLString:subStr baseURL:nil];
                    
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
