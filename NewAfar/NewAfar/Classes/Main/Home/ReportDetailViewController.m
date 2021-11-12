//
//  ReportDetailViewController.m
//  NewAfar
//
//  Created by cw on 16/9/14.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ReportDetailViewController.h"

@interface ReportDetailViewController ()<UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *heading;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *file;

@end

@implementation ReportDetailViewController
{
    NSString *fileUrl;
    NSString *fileName;
    UIDocumentInteractionController *docController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"公告详情" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestReportDetailData];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _heading.text = _name;
    _file.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _file.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_file addTarget:self action:@selector(downloadFile:) forControlEvents:UIControlEventTouchUpInside];
}
//文件下载
- (void)downloadFile:(UIButton *)sender
{
    NSString *url = [fileUrl stringByReplacingOccurrencesOfString:@"app.afarsoft.com" withString:@"192.168.0.54:8894"];

    [ShowAlter showAlertToController:self title:@"提示" message:[NSString stringWithFormat:@"下载：%@",fileName] cancelAction:@"取消" otherAction:@"确定" sureBlock:^{
        
        [MBProgressHUD showMessag:@"下载中..." toView:self.view];
        
        [NetRequest downloadFile:url successDownload:^(NSURL *path) {
            NSLog(@"path:%@",path);
            if (path) {
                docController = [UIDocumentInteractionController  interactionControllerWithURL:path];
                docController.delegate = self;
                [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            }else{
                [ShowAlter showAlertToController:self title:@"提示" message:@"文件错误!" buttonAction:@"取消" buttonBlock:^{
                }];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } cancelBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - UIDocumentInteractionControllerDelegate
-(void)documentInteractionController:(UIDocumentInteractionController *)controller

       willBeginSendingToApplication:(NSString *)application

{
    
    //将要发送的应用
    
}
//下面是他的代理方法

-(void)documentInteractionController:(UIDocumentInteractionController *)controller

          didEndSendingToApplication:(NSString *)application

{
    
    //已经发送的应用
    
}

-(void)documentInteractionControllerDidDismissOpenInMenu:

(UIDocumentInteractionController *)controller

{
    
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
                    _content.text = nr.stringValue;
                    DDXMLElement *fj = [item elementsForName:@"fj"][0];
                    [_file setTitle:[NSString stringWithFormat:@"附件下载:%@",fj.stringValue] forState:UIControlStateNormal];
                    fileName = fj.stringValue;
                    DDXMLElement *c_address = [item elementsForName:@"c_address"][0];
                    fileUrl = c_address.stringValue;
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
