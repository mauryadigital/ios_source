//
//  AppDelegate.h
//  LeaveManagement
//
//  Created by User on 5/12/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(strong, nonatomic)ViewController *objViewController;
@property(strong,nonatomic)UINavigationController *objNavigationController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)NSString *accessTokenString;
@property(nonatomic)int monthNumber;
@property(nonatomic)BOOL isManagerLogin;
@property(nonatomic)BOOL isHistory;

@property (strong, nonatomic)NSMutableDictionary *leavesDictionary;

//@property(nonatomic,strong) NSMutableArray *holidayDatesArray;

@end

