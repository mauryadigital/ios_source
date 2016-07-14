//
//  LoginVC.h
//  CRMS
//
//  Created by kishore kumar nagalla on 03/03/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"
@interface LoginVC : UIViewController

- (IBAction)loginButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

