//
//  Alert.h
//  HomeWork
//
//  Created by Doraer on 2020/6/20.
//  Copyright © 2020 AW Cheirs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Alert : NSObject
+(void)alertPresentTitle:(NSString *)title detailContent:(NSString *)content incontroller:(UIViewController *)vc cancel:(NSString *)cancelTitle confirm:(NSString *)sureTitle  cacelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))sureBlock;
@end

