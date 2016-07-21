//
//  ApplyViewController.h
//  LeaveManagement
//
//  Created by User on 5/16/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface ApplyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>
{
    NSInteger nSectionIndex;
    NSInteger nIndex;
    CGRect applyLeaveTableframe;
    CGRect footerFrame;
    
    //Picker
    UITextField *myTextField;
    UIPickerView *myPickerView;
    NSMutableArray *pickerArray;
    NSMutableArray *reasonspickerArray;
    UIToolbar *toolBar;
    UIDatePicker *datePicker;
    UITextField *dateTextField;
    UITextField *toDateTextField;
    UITextField *numberOfDaysTextField;
    UILabel *userMsg;
    UIDatePicker *toDatePicker;
    UITextField *EidTextbox;
    NSDateFormatter *dateFormatter;
    UITextField *appliedDateTextbox;
    UITextView *Reasontextbox;
    UIActivityIndicatorView *spinner;
    NSString* empInformationId;
    UITextField *commonReasonTextField;
    NSMutableDictionary *leavesDictionary;
    NSDate *fromDate;
    
}
@property (strong, nonatomic) IBOutlet UITableView *applyLeaveTable;
@property (strong, nonatomic) NSMutableArray *empDetailsArray;
@property (nonatomic) NSString* empInformationId;
@property (strong, nonatomic) NSMutableDictionary *leavesDictionary;

@end
