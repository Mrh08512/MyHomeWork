//
//  ItemTableViewCell.h
//  HomeWork
//
//  Created by Doraer on 2020/6/20.
//  Copyright © 2020 AW Cheirs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
- (void)configureModel:(UserModel *)user;
@end

NS_ASSUME_NONNULL_END
