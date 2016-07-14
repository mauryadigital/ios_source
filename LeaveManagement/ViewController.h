//
//  ViewController.h
//  LeaveManagement
//
//  Created by User on 5/12/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "DashboardViewController.h"
@class AppDelegate;
@class HomeTabViewController;
@interface ViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>
{

    DashboardViewController *dash;
    AppDelegate *appDelegate;
    HomeTabViewController *homeTab;
    UIActivityIndicatorView *spinner;
    CGRect viewFrame;
}

@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic)NSString *accessToken;

@end
