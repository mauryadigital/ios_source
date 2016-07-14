//
//  HolidayCustomCellTableViewCell.m
//  LeaveManagement
//
//  Created by User on 5/31/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "HolidayCustomCellTableViewCell.h"

@implementation HolidayCustomCellTableViewCell
@synthesize holidayNameLbl;
@synthesize holidayDateLbl;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
