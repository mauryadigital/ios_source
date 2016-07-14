//
//  ApprovedCellTableViewCell.m
//  LeaveManagement
//
//  Created by User on 6/27/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "ApprovedCellTableViewCell.h"

@implementation ApprovedCellTableViewCell
@synthesize nameLabel,dmentLabel,statusLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
