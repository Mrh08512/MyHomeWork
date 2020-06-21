//
//  SQLManager.m
//  HomeWork
//
//  Created by Doraer on 2020/6/19.
//  Copyright © 2020 AW Cheirs. All rights reserved.
//

#import "SQLManager.h"
#import <FMDB.h>

static NSString *DBName = @"work.db";

/// cuuretn no use
#define kTableName @"account_db"


//,关键字VIDEO
#define ACCOUNT_SQL @"CREATE TABLE IF NOT EXISTS " kTableName"(\
'ID' INTEGER PRIMARY KEY AUTOINCREMENT,\
'user_name' VARCHAR(250,0),\
'user_email' VARCHAR(250,0),\
'user_address' VARCHAR(250,0),\
'user_tel' VARCHAR(250,0)\
)"


@interface SQLManager()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSString *dbPath;
@end


@implementation SQLManager
static SQLManager * dbShare = nil;
+ (SQLManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbShare = [[SQLManager alloc] init];
    });
    return dbShare;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self openDataBase];
    }
    return self;
}

/// 创建打开数据库
- (void)openDataBase {
    [self dbClose];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
 
    NSFileManager *fmManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL exit = [fmManager fileExistsAtPath:filePath isDirectory:&isDir];//指示一个文件或者一个路径是否存在于特定的路径之下
    if (!exit || !isDir) {
        [fmManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    self.dbPath = [filePath stringByAppendingPathComponent:DBName];
    self.queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    self.db = [self.queue valueForKey:@"_db"];
}

- (void)dbClose {
    if ([self.db open]) {
        [self.queue close];
        [self.db close];
        self.db = nil;
    }
}


- (void)startDBTables {
    [self sqlExcueInsertWithUpdate:ACCOUNT_SQL parameter:nil complete:^(BOOL result) {
        if (!result) {
            NSLog(@"创建表失败");
        }
    }];
}


#pragma mark - 数据处理
- (void)saveUserAccount:(UserModel *)model handelComplete:(void(^ _Nullable)(BOOL result))complete {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(user_name,user_email,user_address,user_tel) VALUES(?,?,?,?)",kTableName];
    /// 写入的数据
    NSArray *datas = @[FlatmapNilOrContent(model.userName)
                       ,FlatmapNilOrContent(model.email)
                       ,FlatmapNilOrContent(model.address)
                       ,FlatmapNilOrContent(model.tel)];
    [self sqlExcueInsertWithUpdate:sql parameter:datas complete:^(BOOL result) {
        SAFE_BLOCK(complete)(result);
    }];
}


- (void)selectAccountListHandeler:(void(^ _Nullable)(NSArray * result))complete{
    NSString* sql= [NSString stringWithFormat:@"SELECT * FROM %@ order by id desc",kTableName];
    NSMutableArray *datas = [@[] mutableCopy];
    [self sqlExcurSelect:sql parameter:nil complete:^(FMResultSet * result) {
          while ([result next]) {
              UserModel *model = [UserModel new];
              model.accountId = [result intForColumn:@"ID"];
              model.userName = [result stringForColumn:@"user_name"];
              model.email = [result stringForColumn:@"user_email"];
              model.address = [result stringForColumn:@"user_address"];
              model.tel = [result stringForColumn:@"user_tel"];
              [datas addObject: model];
          }
          [result close];
    }];
    SAFE_BLOCK(complete)(datas);
}


- (void)selectNameOrTel:(NSString *)content handeler:(void(^ _Nullable)(NSArray * result))complete {
    NSString* sql= [NSString stringWithFormat:@"SELECT * FROM %@ where user_name= '%@' or user_tel = '%@' order by ID desc",kTableName,content, content];
    NSMutableArray *datas = [@[] mutableCopy];
    [self sqlExcurSelect:sql parameter:nil complete:^(FMResultSet * result) {
          while ([result next]) {
              UserModel *model = [UserModel new];
              model.accountId = [result intForColumn:@"ID"];
              model.userName = [result stringForColumn:@"user_name"];
              model.email = [result stringForColumn:@"user_email"];
              model.address = [result stringForColumn:@"user_address"];
              model.tel = [result stringForColumn:@"user_tel"];
              [datas addObject: model];
          }
          [result close];
    }];
    SAFE_BLOCK(complete)(datas);
}

- (void)deleteAccountId:(NSInteger)accountId  handeler:(void(^ _Nullable)(BOOL result))complete {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID = %ld",kTableName, accountId];
    [self sqlExcueInsertWithUpdate:sql parameter:nil complete:^(BOOL result) {
        SAFE_BLOCK(complete)(result);
    }];
}

- (void)updateAccount:(NSInteger)accountId userName:(NSString *)userName tel:(NSString *)tel handeler:(void(^ _Nullable)(BOOL result))complete {
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET user_name = '%@', user_tel='%@' WHERE ID = %ld",kTableName, userName, tel, accountId];
    [self sqlExcueInsertWithUpdate:sql parameter:nil complete:^(BOOL result) {
        SAFE_BLOCK(complete)(result);
    }];
}


#pragma mark -- 查询和写入事物
/// Update Insert
- (void)sqlExcueInsertWithUpdate:(NSString *)sql parameter:(NSArray *)argument complete:(void(^ _Nullable)(BOOL result))complete {
    if (self.queue) {
         __block BOOL result;
         [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
             result = [db executeUpdate:sql withArgumentsInArray:argument];
        }];
        SAFE_BLOCK(complete)(result);
    }
}

- (void)sqlExcurSelect:(NSString *)sql parameter:(NSArray *)argument complete:(void(^ _Nullable)(FMResultSet *result))complete {
    if (self.queue) {
        __block FMResultSet *result;
         [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
             result = [db executeQuery:sql withArgumentsInArray:argument];
             
        }];
        SAFE_BLOCK(complete)(result);
    }
}


id FlatmapNilOrContent(NSString *content) {
    if (content) {
        return content;
    } else {
        return [NSNull null];
    }
}

@end
