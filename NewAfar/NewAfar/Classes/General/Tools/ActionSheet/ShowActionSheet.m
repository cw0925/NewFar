//
//  ShowActionSheet.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ShowActionSheet.h"

@interface ShowActionSheet ()

@end

@implementation ShowActionSheet

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)showActionSheetToController:(UIViewController *)targetController takeBlock:(void (^)(void))takeB phoneBlock:(void(^)(void))pictureB
{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (takeB) {
            takeB();
        }
    }];
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (pictureB) {
            pictureB();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:takeAction];
    [sheet addAction:phoneAction];
    [sheet addAction:cancelAction];
    
    [targetController presentViewController:sheet animated:YES completion:nil];
}

@end
