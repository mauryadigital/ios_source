//
//  DashboardViewController.h
//  LeaveManagement
//
//  Created by User on 5/27/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangePasswordsViewController.h"
@class EmpDetailsViewController;
@interface DashboardViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{

    
    UIPickerView *popupPicker;
    UIToolbar*toolBar;
    NSMutableArray* popupPickerArray;
    UICollectionView *_collectionView;
    NSMutableArray *imagesArray;
    NSMutableArray *labelsArray;
    NSMutableDictionary *jsonDictionary;
    NSString *paidLeavesString;
    NSString *earnedLeavesString;
    UIActivityIndicatorView *spinner;
    NSMutableArray *imagesArray1;
    NSMutableArray *labelsArray1;
    NSString* empId;
    UIButton *settingsBtn;
    ChangePasswordsViewController *changePwd;
UIView *settingsView;

}
@property (strong, nonatomic) IBOutlet UIView *popup;
@property (strong, nonatomic) IBOutlet UILabel *totalLeavesLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainingLeavesLabel;
@property (strong, nonatomic) IBOutlet UILabel *casualLeavesLabel;
@property (strong, nonatomic) IBOutlet UILabel *sickLeavesLabel;

//Emp details
@property (strong, nonatomic) IBOutlet UILabel *empNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *empIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *empDesignationLabel;




@property (strong, nonatomic) IBOutlet UITextField *popupViewPickerTextField;
@property (strong, nonatomic) IBOutlet UITextField *popupViewPickerValue;
@property (strong, nonatomic) IBOutlet UIButton *popupOkButton;
@property (strong, nonatomic) IBOutlet UIButton *approveLeavesButton;
@property(nonatomic) BOOL isManagerLogin;
@property (strong, nonatomic) NSMutableDictionary *jsonDictionary;

@end
