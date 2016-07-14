//
//  AvailableLeavesViewController.h
//  LeaveManagement
//
//  Created by User on 7/4/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailableLeavesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{


    UIActivityIndicatorView *spinner;
    NSMutableArray *leavesArray;
    NSMutableArray *leaveTypeArray;

}
@property (strong, nonatomic) IBOutlet UITableView *availableLeavesTable;

@property (strong, nonatomic) UITextView *leaveGuideTextView;
@end
