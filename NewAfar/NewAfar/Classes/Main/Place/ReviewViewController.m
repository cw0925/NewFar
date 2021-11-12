//
//  ReviewViewController.m
//  NewAfar
//
//  Created by cw on 16/11/30.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"评论" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    [super customNavigationBar:title hasLeft:isLeft hasRight:isRight withRightBarButtonItemImage:image];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 60, 30);
    [right setTitle:@"提交" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(reviewClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
}
- (void)reviewClick:(UIButton *)sender
{
    [self sendRequestCommentData];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth, 200)];
    textview.text = @"请输入你的评论";
    [self.view addSubview:textview];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 264, ViewWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestCommentData
{
    NSString *string = @"<root><api><module>1203</module><type>0</type><query>{c_id=1,type=2,content=同乐同乐123}</query></api><user><company></company><customeruser>15225101157</customeruser><phoneno>hhhhhhhhtt</phoneno></user></root>";
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
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
