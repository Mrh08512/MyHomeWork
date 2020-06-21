//
//  ViewController.m
//  HomeWork
//
//  Created by Doraer on 2020/6/19.
//  Copyright © 2020 AW Cheirs. All rights reserved.
//

#import "ViewController.h"
#import "UserInfoViewController.h"
#import "SQLManager.h"
#import "ItemTableViewCell.h"
#import "Alert.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray *accounts;
@property (nonatomic, strong)  NSMutableArray *searchResult;
@property (nonatomic, assign) BOOL isSearch;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SQLManager sharedManager] selectAccountListHandeler:^(NSArray * _Nonnull result) {
        if (result) {
            [self.accounts removeAllObjects];
            [self.accounts addObjectsFromArray:result];
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通许管理系统";
    self.accounts = [@[] mutableCopy];
    self.searchResult = [@[] mutableCopy];
    // select All Account
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"ItemTableViewCell"];
    [[SQLManager sharedManager] selectAccountListHandeler:^(NSArray * _Nonnull result) {
        if (result) {
            [self.accounts addObjectsFromArray:result];
            [self.tableView reloadData];
        }
    }];
    
}

- (IBAction)creatNewAccount:(UIBarButtonItem *)sender {
    
    UIStoryboard *main =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserInfoViewController *userInfoViewController =   [main instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    [self.navigationController pushViewController:userInfoViewController animated:YES];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isSearch ? _searchResult.count : _accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *datas = _isSearch ? _searchResult : _accounts;
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableViewCell"];
    UserModel *model = datas[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell configureModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserModel *model = _accounts[indexPath.row];
    UIStoryboard *main =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserInfoViewController *userInfoViewController =   [main instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    [userInfoViewController updateUserModel:model];
    [self.navigationController pushViewController:userInfoViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSearch) {
        return nil;
    }
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [Alert alertPresentTitle:@"温馨提示" detailContent:@"你确定要删除该用户吗?" incontroller:self cancel:@"取消" confirm:@"确认" cacelBlock:nil confirmBlock:^{
            UserModel *model = self.accounts[indexPath.row];
            [[SQLManager sharedManager] deleteAccountId:model.accountId handeler:^(BOOL result) {
                if (result) {
                    [self.accounts removeObject:model];
                    [self.tableView reloadData];
                }
            }];
        }];
    }];
    return @[action];
}

#pragma mark - uisearch Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    searchBar.text = @"";
    _isSearch = NO;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _isSearch = YES;
    [[SQLManager sharedManager] selectNameOrTel:searchBar.text handeler:^(NSArray * _Nonnull result) {
        NSLog(@"%@",result);
        [self.searchResult removeAllObjects];
        [self.searchResult addObjectsFromArray:result];
        [self.tableView reloadData];
    }];
    
}

@end
