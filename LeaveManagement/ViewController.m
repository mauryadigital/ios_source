//
//  ViewController.m
//  LeaveManagement
//
//  Created by User on 5/12/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "DashboardViewController.h"
#import "AppDelegate.h"


@interface ViewController ()


@end

@implementation ViewController
@synthesize userNameField;
@synthesize passwordField;
@synthesize accessToken;
- (void)viewDidLoad {
    [super viewDidLoad];
      dash=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:nil];
    viewFrame=[UIScreen mainScreen].bounds;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    userNameField.delegate=self;
    passwordField.delegate=self;
    userNameField.text=@"manager";
    passwordField.text=@"password";
    passwordField.secureTextEntry=YES;
    //Setting screen
    self.navigationItem.title=@"Leave Management System";
    self.title=@"Leave Management System";
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    //Loading spinner
    spinner = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
   
}

//Getting response from the server
-(void) requestFinished: (ASIHTTPRequest *) request {
    
    if (request.tag==111) {
        //Checking credentials
        NSString *theJSON = [request responseString];
        NSLog(@"THE JSON %@",theJSON);
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        NSLog(@"accetoken dictionary %@",jsonDictionary);
        accessToken=[[NSString alloc]init];
        accessToken=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"access_token"]];
        NSString *errorMessage=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"error_description"]];
        NSLog(@"ACCESS-TOKEN :%@",accessToken);
        appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        appDelegate.accessTokenString=accessToken;
        NSLog(@"error_description :%@",appDelegate.accessTokenString);
        
        if ([errorMessage isEqualToString:@"Bad credentials"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login" message:@"Please enter valid credentials" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           userNameField.text=@"";
                                           passwordField.text=@"";
                                       }];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        else {
            //if authenticated
            NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/role?access_token=%@",accessToken];
            NSLog(@"URL STRING %@",urlString);
            NSURL *url = [NSURL URLWithString:urlString];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            request.delegate = self;
            request.tag=222;
            [request startAsynchronous];
            [self.view addSubview:spinner];
            [spinner startAnimating];
            
        }
        
    }
    else{
        
     //Getting user role
        
        NSString *theJSON = [request responseString];
        NSLog(@"THE JSON %@",theJSON);
              SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        
        
        NSLog(@"role dictionary %@",jsonDictionary);
        
        NSString *str=[jsonDictionary valueForKey:@"role"];
        NSLog(@"ROLE %@",str);
        appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        
        if ([str isEqualToString:@"ROLE_CONSULTANT"]) {
            appDelegate.isManagerLogin=NO;
        }
        else{
            
            appDelegate.isManagerLogin=YES;
            
        }
        
        [self.navigationController pushViewController:dash animated:YES];
    }
    
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //user friendly for entry in textfields
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480)
        {
            //iPhone 4
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,-60,320,480);
            [UIView commitAnimations];
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            //iPhone 5
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,-30,320,568);
            [UIView commitAnimations];
            
        }
        
    }
    
    else
    {
        //[ipad]
    }
}
- (IBAction)forgotPasswordButtonAction:(id)sender {
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,60,320,480);
            [UIView commitAnimations];
            
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,60,320,568);
            [UIView commitAnimations];
        }
    }
    else
    {
        //[ipad]
    }
    
    [textField resignFirstResponder];
    return YES;
}

//Login button action
- (IBAction)loginButtonAction:(id)sender {
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/oauth/token?grant_type=password&client_id=lms-client-id&client_secret=rest&username=%@&password=%@",userNameField.text,passwordField.text];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag=111;
    [request startAsynchronous];
    [self.view addSubview:spinner];
    [spinner startAnimating];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
