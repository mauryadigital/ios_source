//
//  EmpDetailsViewController.h
//  LeaveManagement
//
//  Created by User on 6/21/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmpDataViewController.h"
@interface EmpDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{


    NSMutableArray *empNameArray;
    UIActivityIndicatorView* spinner;
    NSMutableDictionary *empdict;
    NSArray *results;
    NSMutableArray *monthsArray;
}
@property (nonatomic,strong)IBOutlet UITableView *empListTable;

@end
