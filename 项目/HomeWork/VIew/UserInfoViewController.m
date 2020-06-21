//
//  UserInfoViewController.m
//  HomeWork
//
//  Created by Doraer on 2020/6/19.
//  Copyright © 2020 AW Cheirs. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SQLManager.h"
#import "Alert.h"
BOOL flatMapObjectIsNull(id object)
{
    if (object)
    {
        if ([object isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)object;
            if ([array count] > 0)
            {
                return NO;
            }else
            {
                return YES;
            }
        }else if ([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)object;
            if ([[dictionary allKeys] count] > 0)
            {
                return NO;
            }else
            {
                return YES;
            }
        }else if ([object isKindOfClass:[NSString class]])
        {
            NSString *temp = (NSString *)object;
            NSString *string =  [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([string length] > 0)
            {
                if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"(NULL)"] || [string isEqualToString:@"null"] || [string isEqualToString:@"NULL"])
                {
                    return YES;
                }else
                {
                    return NO;
                }
            } else {
                return YES;
            }
        }else if ([object isKindOfClass:[NSNumber class]])
        {
            NSNumber *number = (NSNumber *)object;
            if ([number isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else if ([object isKindOfClass:[NSNull class]]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return YES;
}


@interface UserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *workAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *telePhoneTextField;
@property (nonatomic, strong)  UserModel *updateUser;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_updateUser) {
        _emailTextFiled.enabled = _workAddressTextField.enabled = NO;
        _userTextField.text = _updateUser.userName;
        _emailTextFiled.text = _updateUser.email;
        _workAddressTextField.text = _updateUser.address;
        _telePhoneTextField.text = _updateUser.tel;
        [_confirmButton setTitle:@"更新" forState:0];
    }
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)confirmAction:(UIButton *)sender {
    if (flatMapObjectIsNull(_userTextField.text)
        || flatMapObjectIsNull(_emailTextFiled.text)
        || flatMapObjectIsNull(_workAddressTextField.text) || flatMapObjectIsNull(_telePhoneTextField.text)) {
        
        
    }else {
        if (_updateUser) {
            [self updateInfo];
        }else {
            [self creatNewAccount];
        }

    }
}

- (void)updateInfo {
    [[SQLManager sharedManager] updateAccount:_updateUser.accountId userName:_userTextField.text tel:_telePhoneTextField.text handeler:^(BOOL result) {
        if (result) {
            [Alert alertPresentTitle:@"用户信息更新成功!" detailContent:nil incontroller:self cancel:nil confirm:@"确认" cacelBlock:nil confirmBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            [Alert alertPresentTitle:@"信息更新失败～～～～" detailContent:nil incontroller:self cancel:nil confirm:@"确认" cacelBlock:nil confirmBlock:^{
                
            }];
        }
    }];
}

- (void)creatNewAccount {
    UserModel *userModel = [UserModel new];
    userModel.userName = _userTextField.text;
    userModel.email = _emailTextFiled.text;
    userModel.address = _workAddressTextField.text;
    userModel.tel = _telePhoneTextField.text;
    [[SQLManager sharedManager] saveUserAccount:userModel handelComplete:^(BOOL result) {
        if (result) {
            [Alert alertPresentTitle:@"创建成功!" detailContent:nil incontroller:self cancel:nil confirm:@"确认" cacelBlock:nil confirmBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            [Alert alertPresentTitle:@"创建失败～～～～" detailContent:nil incontroller:self cancel:nil confirm:@"确认" cacelBlock:nil confirmBlock:^{
                
            }];
        }
    }];
}

- (void)updateUserModel:(UserModel *)userModel {
    _updateUser = userModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


