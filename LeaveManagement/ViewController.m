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
//self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue1.png"]];

    dash=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:nil];
    viewFrame=[UIScreen mainScreen].bounds;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   
    userNameField.delegate=self;
    passwordField.delegate=self;
    userNameField.text=@"manager";
    passwordField.text=@"password";
    self.navigationItem.title=@"Leave Management System";
    self.title=@"Leave Management System";
    spinner = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
}

-(void) requestFinished: (ASIHTTPRequest *) request {
    
    
    // [request responseString]; is how we capture textual output like HTML or JSON
    // [request responseData]; is how we capture binary output like images
    // Then to create an image from the response we might do something like
    // UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
    
    if (request.tag==111) {
        NSString *theJSON = [request responseString];
        NSLog(@"THE JSON %@",theJSON);
        // Now we have successfully captured the JSON ouptut of our request
        //  [self.navigationController pushViewController:objHomeViewController animated:YES];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        
        
        // NSMutableDictionary *divisionDictionary = [jsonDictionary valueForKey:@""];
        NSLog(@"accetoken dictionary %@",jsonDictionary);
        
        //NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        // NSMutableArray *tempArray=[[NSMutableArray alloc]init];
        
        
        //for (int i=0; i<divisionDictionary.count; i++) {
        accessToken=[[NSString alloc]init];
        //[accessToken stringByAppendingString:[[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"access_token"]] ]]
        accessToken=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"access_token"]];
        NSString *errorMessage=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"error_description"]];
        //  [tempArray addObject:str];
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
            
            
            NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/role?access_token=%@",accessToken];
            NSLog(@"URL STRING %@",urlString);
            NSURL *url = [NSURL URLWithString:urlString];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            request.delegate = self;
            request.tag=222;
            
            // [request setPostValue:userNameField.text forKey:@"your_key"];
            
            [request startAsynchronous];
            [self.view addSubview:spinner];
            [spinner startAnimating];
            

        }

    }
    else{
    
    
    
        NSString *theJSON = [request responseString];
        NSLog(@"THE JSON %@",theJSON);
        // Now we have successfully captured the JSON ouptut of our request
        //  [self.navigationController pushViewController:objHomeViewController animated:YES];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        
        
        // NSMutableDictionary *divisionDictionary = [jsonDictionary valueForKey:@""];
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

    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480)
        {
         
            
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.25];
                self.view.frame = CGRectMake(0,-60,320,480);
                [UIView commitAnimations];
                
            
            
        }
        
        
        else if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
         
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
- (IBAction)loginButtonAction:(id)sender {
 
    
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/oauth/token?grant_type=password&client_id=lms-client-id&client_secret=rest&username=%@&password=%@",userNameField.text,passwordField.text];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag=111;
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];
    [self.view addSubview:spinner];
    [spinner startAnimating];

    
    
//    if(userNameField.text.length==0)
//    {
//       objHomeViewController.isManagerLogin  = YES;
//    }
//    else{
//    
//       objHomeViewController.isManagerLogin   = NO;
//    
//    }
//    [self.navigationController pushViewController:objHomeViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
