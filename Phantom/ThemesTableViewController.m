//
//  ThemesTableViewController.m
//  PangeaIO
//
//  Created by Joseph Shenton on 3/3/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "ThemesTableViewController.h"

@interface ThemesTableViewController ()

@end

@implementation ThemesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)setAtomOneDark:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"atom-one-dark" forKey:@"editorTheme"];
    [defaults synchronize];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    
    SCLButton *button2 = [alert addButton:@"Awesome!" actionBlock:^(void) {
        
    }];
    
    button2.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    
    [alert showSuccess:self title:@"Theme Changed!" subTitle:@"WooHoo! Theme was successfully changed" closeButtonTitle:nil duration:0.0f];
}

- (IBAction)setAtomOneLight:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"atom-one-light" forKey:@"editorTheme"];
    [defaults synchronize];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    
    SCLButton *button2 = [alert addButton:@"Awesome!" actionBlock:^(void) {
        
    }];
    
    button2.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    
    [alert showSuccess:self title:@"Theme Changed!" subTitle:@"WooHoo! Theme was successfully changed" closeButtonTitle:nil duration:0.0f];
}

- (IBAction)setMonokai:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"monokai-sublime" forKey:@"editorTheme"];
    [defaults synchronize];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    
    SCLButton *button2 = [alert addButton:@"Awesome!" actionBlock:^(void) {
        
    }];
    
    button2.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    
    [alert showSuccess:self title:@"Theme Changed!" subTitle:@"WooHoo! Theme was successfully changed" closeButtonTitle:nil duration:0.0f];
}

- (IBAction)setHopscotch:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"hopscotch" forKey:@"editorTheme"];
    [defaults synchronize];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    
    SCLButton *button2 = [alert addButton:@"Awesome!" actionBlock:^(void) {
        
    }];
    
    button2.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    
    [alert showSuccess:self title:@"Theme Changed!" subTitle:@"WooHoo! Theme was successfully changed" closeButtonTitle:nil duration:0.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
