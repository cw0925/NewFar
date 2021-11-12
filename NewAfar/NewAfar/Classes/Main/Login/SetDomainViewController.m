//
//  SetDomainViewController.m
//  NewAfar
//
//  Created by cw on 17/3/8.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "SetDomainViewController.h"

@interface SetDomainViewController ()

@end

@implementation SetDomainViewController
{
    UITextField *c_title;
    UILabel *title;
    NSString *string;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"域名配置" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI{
    UILabel *name = [UILabel new];
    name.text = @"默认域名:";
    name.font = [UIFont systemFontWithSize:14];
    
    title = [UILabel new];
    title.text = Domain;
    title.font = [UIFont systemFontWithSize:14];
    
    UILabel *c_name = [UILabel new];
    c_name.text = @"域        名:";
    c_name.font = [UIFont systemFontWithSize:14];
    
    c_title = [UITextField new];
    c_title.placeholder = @"请输入域名";
    c_title.borderStyle = UITextBorderStyleRoundedRect;
    c_title.font = [UIFont systemFontWithSize:14];
    c_title.text = [userDefault valueForKey:@"cus_domain"];
    c_title.clearButtonMode = UITextFieldViewModeWhileEditing;
    string = c_title.text;
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeDomainClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view sd_addSubviews:@[name,title,c_name,c_title,btn]];
    
    CGFloat margin = 10;
    
    name.sd_layout.leftSpaceToView(self.view,margin).topSpaceToView(self.view,NVHeight+margin).widthIs(75).heightIs(30);
    
    title.sd_layout.leftSpaceToView(name,margin).topEqualToView(name).rightSpaceToView(self.view,margin).heightIs(30);
    
    c_name.sd_layout.leftSpaceToView(self.view,margin).topSpaceToView(name,0).widthIs(75).heightIs(30);
    
    c_title.sd_layout.leftSpaceToView(c_name,margin).topEqualToView(c_name).rightSpaceToView(self.view,margin).heightIs(30);
    
    btn.sd_layout.leftSpaceToView(self.view,4*margin).topSpaceToView(c_title,4*margin).rightSpaceToView(self.view,4*margin).heightIs(35);
     
}
- (void)changeDomainClick:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([self haveChinese:c_title.text]) {
        [self.view makeToast:@"不能输入中文字符！"];
    }else{
        if (![string isEqualToString:c_title.text]) {
            [self.navigationController.viewControllers[0].view makeToast:@"域名已修改！"];
        }
        if ([c_title.text isEqualToString:@""]) {
            [userDefault setValue:title.text forKey:@"domain"];
        }else{
            [userDefault setValue:c_title.text forKey:@"domain"];
        }
        [userDefault setValue:c_title.text forKey:@"cus_domain"];
        [userDefault setBool:YES forKey:@"isChange"];
        [userDefault synchronize];
        NSLog(@"域名：%@---%@",[userDefault valueForKey:@"domain"],[userDefault valueForKey:@"cus_domain"]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//判断中文字符
- (BOOL)haveChinese:(NSString *)text{
    for (int i=0; i<text.length;++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [text substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3){
            NSLog(@"汉字:%s", cString);
            return YES;
        }
    }
    return NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
