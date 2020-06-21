//
//  UserInfoViewController.h
//  HomeWork
//
//  Created by Doraer on 2020/6/19.
//  Copyright © 2020 AW Cheirs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserInfoViewController : UIViewController
- (void)updateUserModel:(UserModel *)userModel;
@end

BOOL flatMapObjectIsNull(id object);
NS_ASSUME_NONNULL_END
