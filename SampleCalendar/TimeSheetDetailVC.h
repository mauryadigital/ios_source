//
//  TimeSheetDetailVC.h
//  TimeSheet
//
//  Created by kishore kumar nagalla on 31/05/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeSheetDetailVC : UIViewController


@property(nonatomic,strong) NSMutableDictionary *timesheetVODict;
@property(nonatomic,strong) NSMutableDictionary *timesheetEntryVOListDict;

@property(nonatomic,assign)BOOL isFromAdd;

- (IBAction)hoursButtonAction:(id)sender;
- (IBAction)clientPickerAction:(id)sender;


@end
