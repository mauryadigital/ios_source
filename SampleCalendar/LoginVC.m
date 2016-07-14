//
//  LoginVC.m
//  CRMS
//
//  Created by kishore kumar nagalla on 03/03/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import "LoginVC.h"
#import "HomeVC.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface LoginVC ()<UITextFieldDelegate>{
    UIActivityIndicatorView*    activityindicator;
}
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginButton.layer.cornerRadius = 5;
    self.navigationController.navigationBarHidden = YES;
    activityindicator= [[UIActivityIndicatorView alloc]init];
    activityindicator.layer.cornerRadius =6;
    activityindicator.backgroundColor = [UIColor colorWithRed:229/255.0 green:47/255.0 blue:24/255.0 alpha:1];
    [activityindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    activityindicator.frame=CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-60)/2-64, 100, 60);

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated{
    
    
    
    self.navigationController.navigationBarHidden = YES;
    
    _username.text=@"";
    _password.text=@"";
}



- (IBAction)loginButtonAction:(id)sender {
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    

   /* HomeVC *  vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeVC"];
    [self.navigationController pushViewController:vc animated:YES];

    return;
    */
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    
    if (_username.text.length>0 && _password.text.length>0) {
        
    }else{
        if(_username.text.length==0 && _password.text.length == 0){
            [[[UIAlertView alloc] initWithTitle:@"Please enter valid username, password" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

            return;
            
        }else if (_username.text==0) {
            [[[UIAlertView alloc] initWithTitle:@"Please enter valid username" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

            return;

        }else if (_password.text.length==0){
            [[[UIAlertView alloc] initWithTitle:@"Please enter valid password" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

            return;


        }

    }
    
    
    /*if ([_username.text isEqualToString:@"admin"] && [_password.text isEqualToString:@"admin"]) {
        appDelegate.userTag = MANAGER_TAG;
    }else if ([_username.text isEqualToString:@"user"] && [_password.text isEqualToString:@"user"]) {
        appDelegate.userTag = CONSULTANT_TAG;
    }else{
        
        [[[UIAlertView alloc] initWithTitle:@"Please enter valid username, password" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
        return;
    }*/
    
    [self.view addSubview:activityindicator];
    [activityindicator startAnimating];
    
    NSURL *loginUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.43.75:418/tms/oauth/token?grant_type=password&client_id=tms-client-id&client_secret=rest&username=%@&password=%@",_username.text,_password.text]];
    
    NSURLSessionConfiguration *configaraiton = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configaraiton];

    NSURLRequest *request = [NSURLRequest requestWithURL:loginUrl];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"%@",responseObject);
//            /{"access_token":"fd80e273-7f0e-42ba-b86a-3859453328b7","token_type":"bearer","refresh_token":"5beaa7ba-4833-4ef7-bfb0-8803936dc681","expires_in":299,"scope":"read trust write"}
            NSString *accessToken = [responseObject valueForKey:@"access_token"];
            
            

            NSURLSessionConfiguration *configaration = [NSURLSessionConfiguration defaultSessionConfiguration];

            AFURLSessionManager*manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configaration];
            
            NSURLSessionDataTask *task  = [manager dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.43.75:418/tms/rest/role?access_token=%@&date=",accessToken]]] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                //{"role":"ROLE_MANAGER"}
                //ROLE_ADMIN
                NSLog(@"%@",responseObject);
                [activityindicator removeFromSuperview];

                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                
                if (httpResponse.statusCode == 200) {
                    NSString *role = [responseObject valueForKey:@"role"];
                    NSString *username = [responseObject valueForKey:@"userName"];
               
                    [[NSUserDefaults standardUserDefaults]setValue:role?role:@"" forKey:@"ROLE"];
                    [[NSUserDefaults standardUserDefaults]setValue:username?username:@"" forKey:@"username"];

                    
//                    if([role isEqualToString:@"ROLE_CONSULTANT"]){
//                        appDelegate.userTag = CONSULTANT_TAG;
//                       
//                    }else{
//                        appDelegate.userTag = MANAGER_TAG;
//                        [[NSUserDefaults standardUserDefaults]setInteger:MANAGER_TAG forKey:@"ROLE"];
//
//
//                    }
              
                    [[NSUserDefaults standardUserDefaults]setValue:accessToken forKey:@"access_token"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    HomeVC *  vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeVC"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"Server not respond" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

                }
                
                

                
            }];
            
            [task resume];
            
            
            
        }else{
            
            [activityindicator removeFromSuperview];

            NSLog(@"error: %@",error);

            [[[UIAlertView alloc] initWithTitle:@"Please enter valid credentials" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
 
        }
        
        
    }];
    
    [dataTask resume];
    
    
 /*
  
    */
    

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return  YES;
}



@end
