//
//  UserModel.h
//  WawVedo
//
//  Created by Doraer on 2020/6/19.
//  Copyright © 2020 Waw Kil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, assign) NSInteger accountId;

@end

NS_ASSUME_NONNULL_END
