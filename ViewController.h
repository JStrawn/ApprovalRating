//
//  ViewController.h
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//


#import "AppDelegate.h"
#import "ViewController.h"
#import "ResultController.h"
#import "DAO.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ViewController : UIViewController

@property (strong, nonatomic) DAO *dao;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *nameInputTextField;

- (IBAction)submitButtonPrsd:(id)sender;
- (IBAction)resultLauncher:(id)sender;

@end
