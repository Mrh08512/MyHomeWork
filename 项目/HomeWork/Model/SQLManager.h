//
//  SQLManager.h
//  HomeWork
//
//  Created by Doraer on 2020/6/19.
//  Copyright © 2020 AW Cheirs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#define SAFE_BLOCK(block)           if(block)block

NS_ASSUME_NONNULL_BEGIN

@interface SQLManager : NSObject
+ (SQLManager *)sharedManager;
- (void)startDBTables;

- (void)saveUserAccount:(UserModel *)model handelComplete:(void(^ _Nullable)(BOOL result))complete;

- (void)selectAccountListHandeler:(void(^ _Nullable)(NSArray * result))complete;

- (void)selectNameOrTel:(NSString *)content handeler:(void(^ _Nullable)(NSArray * result))complete;

- (void)deleteAccountId:(NSInteger)accountId  handeler:(void(^ _Nullable)(BOOL result))complete;

- (void)updateAccount:(NSInteger)accountId userName:(NSString *)userName tel:(NSString *)tel handeler:(void(^ _Nullable)(BOOL result))complete;
@end

NS_ASSUME_NONNULL_END
