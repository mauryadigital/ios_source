//
//  ApprovedCellTableViewCell.h
//  LeaveManagement
//
//  Created by User on 6/27/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApprovedCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *dmentLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@end
