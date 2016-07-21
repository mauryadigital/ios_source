//
//  ChangePasswordsViewController.h
//  LeaveManagement
//
//  Created by User on 7/19/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ChangePasswordsViewController : UIViewController<UITextFieldDelegate>
{
    UILabel *oldPasswordLbl;
    
    UILabel *newPasswordLbl;
    UILabel *confirmPasswordLbl;
    UIButton *submit;
    UITextField *oldPasswordTxtFld;
    UITextField *newPasswordTxtFld;
    UITextField *confirmPasswordTxtFld;
    UIButton *submitButton;

    
}
@end
