//
//  ApprovalTableviewCell.m
//  LeaveManagement
//
//  Created by User on 6/10/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "ApprovalTableviewCell.h"

@implementation ApprovalTableviewCell
@synthesize noOfLeavesLabel,leaveTypeLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
