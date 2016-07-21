//
//  EmpDataViewController.h
//  LeaveManagement
//
//  Created by User on 6/21/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApprovalTableviewCell;
@interface EmpDataViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{

    NSMutableArray *leavesArray;
    NSMutableArray *leaveTypeArray;
    
}
@property (nonatomic, strong)NSMutableDictionary *empDataDictionary;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *designationLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;

@property (strong, nonatomic) IBOutlet UITableView *leavesTable;
@property (strong, nonatomic) IBOutlet UIImageView *employeeImageView;
@end
