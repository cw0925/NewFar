//
//  MyCodeViewController.m
//  NewAfar
//
//  Created by cw on 17/2/16.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "MyCodeViewController.h"
#import "SGQRCodeTool.h"

@interface MyCodeViewController ()

@end

@implementation MyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"我的二维码" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
    NSLog(@"图片：%@",_iconImage);
}
- (void)initUI{
    self.view.backgroundColor = BaseColor;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(20,100, ViewWidth-40, (ViewWidth-40)*1.2)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIImageView *icon = [UIImageView new];
    if ([_iconImage isEqualToString:@""]) {
        icon.image = [[UIImage imageNamed:@"avatar_zhixing"]circleImage];
    }else{
        [icon sd_setImageWithURL:[NSURL URLWithString:_iconImage] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            icon.image = [image circleImage];
        }];
    }
    
    UILabel *name = [UILabel new];
    name.text = _name;
    name.font = [UIFont systemFontWithSize:14];
    
    UILabel *postion = [UILabel new];
    postion.text = _postion;
    postion.font = [UIFont systemFontWithSize:12];
    
    
    UIImageView *codeImg = [UIImageView new];
    //codeImg.image = [UIImage imageNamed:@"lunbo"];
    
    codeImg.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:[userDefault valueForKey:@"name"] logoImageName:_iconImage logoScaleToSuperView:0.2];
    
    UILabel *title = [UILabel new];
    title.text = @"用管翼通扫一扫，加我为好友";
    title.font = [UIFont systemFontWithSize:10];
    title.textAlignment = NSTextAlignmentCenter;
    
    [bgView sd_addSubviews:@[icon,name,postion,codeImg,title]];
    
    CGFloat margin = 20;
    
    icon.sd_layout.leftSpaceToView(bgView,margin).topSpaceToView(bgView,margin).widthIs(40).heightIs(40);
    
    name.sd_layout.leftSpaceToView(icon,margin).topEqualToView(icon).rightSpaceToView(bgView,margin).heightIs(20);
    
    postion.sd_layout.leftEqualToView(name).topSpaceToView(name,0).rightSpaceToView(bgView,margin).heightIs(20);
    
    title.sd_layout.leftEqualToView(icon).bottomSpaceToView(bgView,5).rightSpaceToView(bgView,margin).heightIs(20);
    
    codeImg.sd_layout.leftEqualToView(icon).topSpaceToView(icon,5).rightSpaceToView(bgView,margin).bottomSpaceToView(title,5);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
