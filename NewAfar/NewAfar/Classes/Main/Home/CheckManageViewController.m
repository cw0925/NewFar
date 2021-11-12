//
//  CheckManageViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/5.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CheckManageViewController.h"

@interface CheckManageViewController ()

@end

@implementation CheckManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"查看巡场" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self sendRequestInspectManageData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestInspectManageData
{
    NSString *str = @"<root><api><module>1604</module><type>0</type><query>{c_id=1}</query></api><user><company>001101</company><customeruser>15939010676</customeruser><phoneno>lblblblblblbtt</phoneno></user></root>";
    [NetRequest sendRequest:BaseURL parameters:str success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@""]) {
                
            }else
            {
                
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
