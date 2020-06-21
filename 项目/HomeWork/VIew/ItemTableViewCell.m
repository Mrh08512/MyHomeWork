//
//  ItemTableViewCell.m
//  HomeWork
//
//  Created by Doraer on 2020/6/20.
//  Copyright © 2020 AW Cheirs. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureModel:(UserModel *)user {
    _nameLabel.text = user.userName;
    _telLabel.text = user.tel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
