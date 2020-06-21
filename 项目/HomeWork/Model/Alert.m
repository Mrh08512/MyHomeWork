//
//  Alert.m
//  HomeWork
//
//  Created by Doraer on 2020/6/20.
//  Copyright © 2020 AW Cheirs. All rights reserved.
//

#import "Alert.h"

@implementation Alert
+(void)alertPresentTitle:(NSString *)title detailContent:(NSString *)content incontroller:(UIViewController *)vc cancel:(NSString *)cancelTitle confirm:(NSString *)sureTitle  cacelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))sureBlock {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    if (cancelTitle) {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertVc addAction:cancleAction];
    }
    if (sureTitle) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureBlock) {
                sureBlock();
            }
        }];
        [alertVc addAction:sureAction];
    }
    if (!cancelTitle && !sureTitle) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVc addAction:sureAction];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alertVc animated:YES completion:nil];
    });
}
@end
