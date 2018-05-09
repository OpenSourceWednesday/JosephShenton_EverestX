//
//  ServerManagmentTableViewController.m
//  PangeaIO
//
//  Created by Joseph Shenton on 17/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define kTutorialPointProductID @"removeAds"

#import "ServerManagmentTableViewController.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

@import GoogleMobileAds;

@interface ServerManagmentTableViewController () <GADInterstitialDelegate>
@property (weak, nonatomic) IBOutlet UILabel *masterConnections;
@property (weak, nonatomic) IBOutlet UILabel *extraConnections;
@property(nonatomic, strong) GADInterstitial*interstitial;
@property (nonatomic, strong) XMFTPServer *ftpServer;
@property (weak, nonatomic) IBOutlet UILabel *portTypes;

@end

@implementation ServerManagmentTableViewController

- (void)startServer
{
    // Start the server (and check for problems)
    
    NSError *error;
    
    if([httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkNoAds];
    [self checkCustomPorts];
    [self setupServers];
    [self emptyServers];
    [self startTimedTask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkCustomPorts {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"portType"]) {
        if ([[defaults objectForKey:@"WebDAVPort"] isEqual: @"9789"] && [[defaults objectForKey:@"FTPPort"] isEqual: @"2121"] && [[defaults objectForKey:@"UploadPort"] isEqual: @"3940"] && [[defaults objectForKey:@"HTTPPort"] isEqual: @"8080"]) {
            _portTypes.text = @"Default";
            [defaults setObject:@"Default" forKey:@"portType"];
            [defaults synchronize];
        } else {
            _portTypes.text = @"Custom";
            [defaults setObject:@"Custom" forKey:@"portType"];
            [defaults synchronize];
        }
    } else {
        if ([[defaults objectForKey:@"WebDAVPort"] isEqual: @"9789"] && [[defaults objectForKey:@"FTPPort"] isEqual: @"2121"] && [[defaults objectForKey:@"UploadPort"] isEqual: @"3940"] && [[defaults objectForKey:@"HTTPPort"] isEqual: @"8080"]) {
            _portTypes.text = @"Default";
            [defaults setObject:@"Default" forKey:@"portType"];
            [defaults synchronize];
        } else {
            _portTypes.text = @"Custom";
            [defaults setObject:@"Custom" forKey:@"portType"];
            [defaults synchronize];
        }
    }
}

- (void)startTimedTask
{
    NSTimer *fiveSecondTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(performBackgroundTask) userInfo:nil repeats:YES];
}

- (void)performBackgroundTask
{
//    __block NSString *activeConnections = @"0";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        activeConnections = [[NSUserDefaults standardUserDefaults] objectForKey:@"activeHTTPConnections"];
        dispatch_async(dispatch_get_main_queue(), ^{
            _masterConnections.text = [NSString stringWithFormat:@"%@ Connections", [[NSUserDefaults standardUserDefaults] objectForKey:@"activeHTTPConnections"]];
        });
    });
}

- (IBAction)masterServers:(id)sender {
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
   
    __block SCLAlertView *blockAlert = alert;
    
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    
    SCLButton *serverLogs = [alert addButton:@"Show Server Logs" actionBlock:^(void) {
        [blockAlert hideView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showServerLogs" object:nil];
    }];
    
    serverLogs.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.52 blue:0.64 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    SCLButton *installSSL = [alert addButton:@"Install SSL Certificate" actionBlock:^(void) {
        [blockAlert hideView];
        [self openScheme:@"http://udid.pro/EverestXSSL.mobileconfig"];
    }];
    
    installSSL.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.91 green:0.72 blue:0.47 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"masterServers"] isEqual: @"running"]) {
        SCLButton *openInSafari = [alert addButton:@"Open in Safari" actionBlock:^(void) {
            [blockAlert hideView];
            [self openScheme:[NSString stringWithFormat:@"https://%@", [self hostname]]];
        }];
        
        openInSafari.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.71 blue:1.00 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"masterServers"] isEqual: @"stopped"]) {
        SCLButton *button = [alert addButton:@"Start Servers" actionBlock:^(void) {
            [blockAlert hideView];
            [self startMasterServers];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            
            alert.backgroundType = SCLAlertViewBackgroundBlur;
            
            
            SCLButton *button3 = [alert addButton:@"Aight, Thanks!" actionBlock:^(void) {
                
            }];
            
            button3.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                
                return buttonConfig;
            };
            
            alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
            
            alert.iconTintColor = [UIColor whiteColor];
            
            [alert showNotice:self title:@"SSL Certificate" subTitle:@"Everest X's SSL Certificate can be found @ http://udid.pro/EverestX.p12! The password is \"EverestX\" without the quotes." closeButtonTitle:nil duration:0.0f];
        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
    }
    
    SCLButton *button1 = [alert addButton:@"List Servers" actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];

        alert.backgroundType = SCLAlertViewBackgroundBlur;

        SCLButton *button = [alert addButton:[NSString stringWithFormat:@"HTTP Server : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HTTPPort"]] actionBlock:^(void) {

        }];

        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];

            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.72 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];

            return buttonConfig;
        };

        SCLButton *button1 = [alert addButton:[NSString stringWithFormat:@"Upload Server : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UploadPort"]] actionBlock:^(void) {

        }];

        button1.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];

            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.72 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];

            return buttonConfig;
        };

        SCLButton *button2 = [alert addButton:[NSString stringWithFormat:@"FTP Server : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"FTPPort"]] actionBlock:^(void) {

        }];

        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];

            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.72 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];

            return buttonConfig;
        };

        SCLButton *button3 = [alert addButton:@"Coolio!" actionBlock:^(void) {

        }];

        button3.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];

            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];

            return buttonConfig;
        };

        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];

        alert.iconTintColor = [UIColor whiteColor];

        [alert showNotice:self title:@"Servers" subTitle:@"Here is a list of master servers & their respective ports!" closeButtonTitle:nil duration:0.0f];
    }];
    
    button1.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.38 blue:0.66 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"masterServers"] isEqual: @"running"]) {
        SCLButton *button4 = [alert addButton:@"Shutdown Servers" actionBlock:^(void) {
            [blockAlert hideView];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            
            alert.backgroundType = SCLAlertViewBackgroundBlur;
            
            SCLButton *button = [alert addButton:@"Yes, hurry up!" actionBlock:^(void) {
                [self stopMasterServers];
            }];
            
            button.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                
                return buttonConfig;
            };
            
            SCLButton *button2 = [alert addButton:@"Actually, keep them up." actionBlock:^(void) {
                
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
            
            [alert showWarning:self title:@"Shutdown Servers" subTitle:@"Are you sure?" closeButtonTitle:nil duration:0.0f];
        }];
        
        button4.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
    } else {
        
    }
    
    SCLButton *button3 = [alert addButton:@"Ah Nevermind!" actionBlock:^(void) {
        
    }];
    
    button3.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    
    [alert showNotice:self title:@"Master Server Control" subTitle:@"Control the Master Servers!" closeButtonTitle:nil duration:0.0f];
    
}

- (IBAction)extraServers:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    __block SCLAlertView *blockAlert = alert;
    
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"extraServers"] isEqual: @"stopped"]) {
        SCLButton *button = [alert addButton:@"Start Servers" actionBlock:^(void) {
            [blockAlert hideView];
            [self startExtraServers];
        }];
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
    }
    
    SCLButton *button1 = [alert addButton:@"List Servers" actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        SCLButton *button = [alert addButton:[NSString stringWithFormat:@"WebDAV Server : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"WebDAVPort"]] actionBlock:^(void) {
            
        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.72 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button3 = [alert addButton:@"Coolio!" actionBlock:^(void) {
            
        }];
        
        button3.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showNotice:self title:@"Servers" subTitle:@"Here is a list of master servers & their respective ports!" closeButtonTitle:nil duration:0.0f];
    }];
    
    button1.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.38 blue:0.66 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"extraServers"] isEqual: @"running"]) {
        SCLButton *button4 = [alert addButton:@"Shutdown Servers" actionBlock:^(void) {
            [blockAlert hideView];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            
            alert.backgroundType = SCLAlertViewBackgroundBlur;
            
            SCLButton *button = [alert addButton:@"Yes, hurry up!" actionBlock:^(void) {
                [self stopExtraServers];
            }];
            
            button.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                
                return buttonConfig;
            };
            
            SCLButton *button2 = [alert addButton:@"Actually, keep them up." actionBlock:^(void) {
                
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
            
            [alert showWarning:self title:@"Shutdown Servers" subTitle:@"Are you sure?" closeButtonTitle:nil duration:0.0f];
        }];
        
        button4.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
    } else {
        
    }
    
    SCLButton *button3 = [alert addButton:@"Ah Nevermind!" actionBlock:^(void) {
        
    }];
    
    button3.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    
    [alert showNotice:self title:@"Extra Server Control" subTitle:@"Control the Extra Servers!" closeButtonTitle:nil duration:0.0f];
}

- (IBAction)portManagement:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    __block SCLAlertView *blockAlert = alert;
    
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    
    SCLButton *HTTPButton = [alert addButton:[NSString stringWithFormat:@"HTTP Server : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HTTPPort"]] actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        UITextField *textField = [alert addTextField:@"8888"];
        
        SCLButton *button = [alert addButton:@"Set!"  validationBlock:^BOOL{
            if (textField.text.length == 0)
            {
                
                return NO;
            }
            return YES;
        } actionBlock:^{
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", textField.text] forKey:@"HTTPPort"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"Text value: %@", textField.text);
            
        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button2 = [alert addButton:@"Actually, nevermind!" actionBlock:^(void) {
            
        }];
        
        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showEdit:self title:@"Custom HTTP Port" subTitle:@"Choose a custom HTTP Port!" closeButtonTitle:nil duration:0.0f];
    }];
    
    HTTPButton.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.72 blue:0.38 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    SCLButton *UPLOADButton = [alert addButton:[NSString stringWithFormat:@"Upload Server : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UploadPort"]] actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        UITextField *textField = [alert addTextField:@"3999"];
        
        SCLButton *button = [alert addButton:@"Set!"  validationBlock:^BOOL{
            if (textField.text.length == 0)
            {
                
                return NO;
            }
            return YES;
        } actionBlock:^{
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", textField.text] forKey:@"UploadPort"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"Text value: %@", textField.text);
            
        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button2 = [alert addButton:@"Actually, nevermind!" actionBlock:^(void) {
            
        }];
        
        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showEdit:self title:@"Custom Upload Port" subTitle:@"Choose a custom Upload Port!" closeButtonTitle:nil duration:0.0f];
    }];
    
    UPLOADButton.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.72 blue:0.38 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    SCLButton *FTPButton = [alert addButton:[NSString stringWithFormat:@"FTP Server : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"FTPPort"]] actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        UITextField *textField = [alert addTextField:@"2111"];
        
        SCLButton *button = [alert addButton:@"Set!"  validationBlock:^BOOL{
            if (textField.text.length == 0)
            {
                
                return NO;
            }
            return YES;
        } actionBlock:^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", textField.text] forKey:@"FTPPort"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"Text value: %@", textField.text);
            
        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button2 = [alert addButton:@"Actually, nevermind!" actionBlock:^(void) {
            
        }];
        
        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showEdit:self title:@"Custom FTP Port" subTitle:@"Choose a custom FTP Port!" closeButtonTitle:nil duration:0.0f];
    }];
    
    FTPButton.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.72 blue:0.38 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    SCLButton *WebDAVButton = [alert addButton:[NSString stringWithFormat:@"WebDAV Server : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"WebDAVPort"]] actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        UITextField *textField = [alert addTextField:@"9777"];
        
        SCLButton *button = [alert addButton:@"Set!"  validationBlock:^BOOL{
            if (textField.text.length == 0)
            {
                
                return NO;
            }
            return YES;
        } actionBlock:^{
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", textField.text] forKey:@"WebDAVPort"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"Text value: %@", textField.text);
            
        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button2 = [alert addButton:@"Actually, nevermind!" actionBlock:^(void) {
            
        }];
        
        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showEdit:self title:@"Custom WebDAV Port" subTitle:@"Choose a custom WebDAV Port!" closeButtonTitle:nil duration:0.0f];
    }];
    
    WebDAVButton.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.72 blue:0.38 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    SCLButton *CLOSEButton = [alert addButton:@"Coolio!" actionBlock:^(void) {
        
    }];
    
    CLOSEButton.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    
    [alert showNotice:self title:@"Port Management" subTitle:@"Set custom ports for each server!" closeButtonTitle:nil duration:0.0f];
}

- (void)startMasterServers {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    [alert showWaiting:@"Starting Master Servers" subTitle:@"This may take a minute or two." closeButtonTitle:nil duration:5.0f];
    
    [self startHTTPServer];
    [self startUploadServer];
    [self startFTPServer];
    
    [alert hideView];
    [[NSUserDefaults standardUserDefaults] setObject:@"running" forKey:@"masterServers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMasterServerAddresses" object:nil];
}

- (void)stopMasterServers {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    [alert showWaiting:@"Stopping Master Servers" subTitle:@"This may take a minute or two." closeButtonTitle:nil duration:5.0f];
    
    [self stopHTTPServer];
    [self stopUploadServer];
    [self stopFTPServer];
    
    [alert hideView];
    [[NSUserDefaults standardUserDefaults] setObject:@"stopped" forKey:@"masterServers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearMasterServerAddresses" object:nil];
}

- (void)startExtraServers {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    [alert showWaiting:@"Starting Extra Servers" subTitle:@"This may take a minute or two." closeButtonTitle:nil duration:5.0f];
    
    [self startWebDAVServer];
    
    [alert hideView];
    [[NSUserDefaults standardUserDefaults] setObject:@"running" forKey:@"extraServers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showExtraServerAddresses" object:nil];
}

- (void)stopExtraServers {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    [alert showWaiting:@"Stopping Extra Servers" subTitle:@"This may take a minute or two." closeButtonTitle:nil duration:5.0f];
    
    [self stopWebDAVServer];
    
    [alert hideView];
    [[NSUserDefaults standardUserDefaults] setObject:@"stopped" forKey:@"extraServers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearExtraServerAddresses" object:nil];
}

- (void)startHTTPServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        httpServer = [[HTTPServer alloc] init];
        
        [httpServer setType:@"_http._tcp."];
        
        [httpServer setPort:443];
        
        // Serve files from our embedded Web folder
//        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
        NSLog(@"Setting document root: %@", documentsPath);
        
        [httpServer setDocumentRoot:documentsPath];
        
        [self startServer];
    
        //            NSString* websitePath = [[NSBundle mainBundle] pathForResource:@"Website" ofType:nil];
        
        [webServer addGETHandlerForBasePath:@"/" directoryPath:documentsPath indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
        
        [webServer addHandlerForMethod:@"GET" pathRegex:@"/.*\.html" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            NSDictionary* variables = [NSDictionary dictionaryWithObjectsAndKeys:@"value", @"variable", nil];
            return [GCDWebServerDataResponse responseWithHTMLTemplate:[documentsPath stringByAppendingPathComponent:request.path] variables:variables];
            
        }];
        
        [webServer addHandlerForMethod:@"GET" path:@"/" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            return [GCDWebServerResponse responseWithRedirect:[NSURL URLWithString:@"index.html" relativeToURL:request.URL] permanent:NO];
        }
         ];
//        [webServer startWithPort:8080 bonjourName:[self hostname]];
        
        NSError *error = nil;
        NSMutableDictionary* options = [NSMutableDictionary dictionary];
        [options setObject:[NSNumber numberWithInteger:[[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HTTPPort"]] integerValue]] forKey:GCDWebServerOption_Port];
        [options setValue:[self hostname] forKey:GCDWebServerOption_BonjourName];
        [options setObject:@NO forKey:GCDWebServerOption_AutomaticallySuspendInBackground];
        [webServer startWithOptions:options error:&error];
        if (error) {
            NSLog(@"Error starting webServer: %@", error);
            return;
        }
        
        NSLog(@"Visit %@ in your web browser", webServer.serverURL);
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"PangeaXRunning"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        });
    });

}

- (void)stopHTTPServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [webServer stop];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"PangeaXRunning"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        });
    });
}

- (void)startUploadServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [webUploader startWithPort:[[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UploadPort"]] integerValue] bonjourName:[self hostname]];
        
        NSLog(@"Visit %@ in your web browser", webUploader.serverURL);
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"PangeaXUploaderRunning"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        });
    });
}

- (void)stopUploadServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [webUploader stop];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"PangeaXUploaderRunning"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        });
    });
}

- (void)startFTPServer {
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // NSHomeDirectory()
    self.ftpServer = [[XMFTPServer alloc]initWithPort:(int) [[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"FTPPort"]] integerValue] withDir:documentsPath notifyObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"PangeaXFTPRunning"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)stopFTPServer {
    [self.ftpServer stopFtpServer];
    self.ftpServer = nil;
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"PangeaXFTPRunning"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)startWebDAVServer {
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _davServer = [[GCDWebDAVServer alloc] initWithUploadDirectory:documentsPath];
    [_davServer startWithPort:[[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"WebDAVPort"]] integerValue] bonjourName:[self hostname]];
    
    NSLog(@"Visit %@ in your WebDAV client", _davServer.serverURL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"PangeaXWebDAVRunning"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        });
    });
    
}

- (void)stopWebDAVServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [_davServer stop];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"PangeaXWebDAVRunning"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        });
    });
}

- (void)checkNoAds {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    static NSString* const noAds = @"noAds";
    if ([defaults boolForKey:noAds] == NO) {
        [self setupAds];
    } else {
        
    }
}

- (void)setupAds {
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-4854696776225673/9113255699"];
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
    self.interstitial.delegate = self;
}

- (void)setupServers {
    webServer = [[GCDWebServer alloc] init];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
}

- (void)emptyServers {
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"PangeaXRunning"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"PangeaXUploaderRunning"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"PangeaXFTPRunning"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"PangeaXWebDAVRunning"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasShownAd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"activeHTTPConnections"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"stopped" forKey:@"extraServers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"stopped" forKey:@"masterServers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)checkIfShownAd {
    static NSString* const hasShownAd = @"hasShownAd";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:hasShownAd] == NO) {
        if (self.interstitial.isReady) {
            [self.interstitial presentFromRootViewController:self];
            [defaults setBool:YES forKey:hasShownAd];
        } else {
            NSLog(@"Ad wasn't ready");
        }
    }
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [self checkIfShownAd];
    NSLog(@"interstitialDidReceiveAd");
}

- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen");
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen");
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}

/* ==== Host Functions ==== */

- (NSString *)hostname {
    char baseHostName[256];
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '\0';
    
#if !TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#else
    return [NSString stringWithFormat:@"%s", baseHostName];
#endif
}

- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
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
