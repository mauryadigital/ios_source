//
//  HolidayCustomCellTableViewCell.h
//  LeaveManagement
//
//  Created by User on 5/31/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HolidayCustomCellTableViewCell : UITableViewCell
@property (strong, nonatomic)IBOutlet UIImageView *holidayImage;
@property (strong, nonatomic)IBOutlet UILabel *holidayNameLbl;
@property (strong, nonatomic)IBOutlet UILabel *holidayDateLbl;

@end
