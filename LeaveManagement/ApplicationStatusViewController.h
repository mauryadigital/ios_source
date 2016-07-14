//
//  ApplicationStatusViewController.h
//  LeaveManagement
//
//  Created by User on 5/17/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApprovedCellTableViewCell;
@interface ApplicationStatusViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray *dateAppliedArray;
    NSMutableArray *noOfLeavesArray;
    NSMutableArray *statusArray;

    UILabel *dateAppliedLabel;
    UILabel *noOfLeavesLabel;
    UILabel *statusLabel;
    UIActivityIndicatorView *spinner;


}
@property (strong, nonatomic) IBOutlet UITableView *applicationStatusTable;
@property (nonatomic)BOOL isManagerLogin;
@end
