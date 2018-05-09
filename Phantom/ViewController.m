//
//  ViewController.m
//  Lilian
//
//  Created by Joseph on 12/1/18.
//  Copyright © 2018 Joseph. All rights reserved.
//

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define kTutorialPointProductID @"removeAds"

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *serverAddresses;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.tabBarController.tabBar.layer.shadowRadius = 12;
    self.tabBarController.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBarController.tabBar.layer.shadowOpacity = 0.12;
    self.tabBarController.tabBar.shadowImage = [[UIImage alloc] init];
    self.tabBarController.tabBar.backgroundImage = [[UIImage alloc] init];
    self.tabBarController.tabBar.translucent = false;
//    self.tabBarController.tabBar.shadowImage = [[UIImage alloc] init];
    [self checkFirstLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMasterServerAddresses) name:@"showMasterServerAddresses" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMasterServerAddresses) name:@"clearMasterServerAddresses" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showExtraServerAddresses) name:@"showExtraServerAddresses" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearExtraServerAddresses) name:@"clearExtraServerAddresses" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewServerLogs) name:@"showServerLogs" object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewServerLogs {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"serverLogsNav"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showMasterServerAddresses {
    if (![_serverAddresses.text isEqual: @""]) {
        _serverAddresses.text = [NSString stringWithFormat:@"%@\nHTTPS: %@:443\nHTTP: %@:%@\nUpload: %@:%@\nFTP: %@:%@ - Any Username & Password", _serverAddresses.text, [self hostname], [self hostname], [[NSUserDefaults standardUserDefaults] objectForKey:@"HTTPPort"], [self hostname], [[NSUserDefaults standardUserDefaults] objectForKey:@"UploadPort"], [self getIPAddress], [[NSUserDefaults standardUserDefaults] objectForKey:@"FTPPort"]];
    } else {
        _serverAddresses.text = [NSString stringWithFormat:@"HTTPS: %@:443\nHTTP: %@:%@\nUpload: %@:%@\nFTP: %@:%@ - Any Username & Password", [self hostname], [self hostname], [[NSUserDefaults standardUserDefaults] objectForKey:@"HTTPPort"], [self hostname], [[NSUserDefaults standardUserDefaults] objectForKey:@"UploadPort"], [self getIPAddress], [[NSUserDefaults standardUserDefaults] objectForKey:@"FTPPort"]];
    }
}

- (void)clearMasterServerAddresses {
    NSString *currentAddresses = _serverAddresses.text;
    currentAddresses = [currentAddresses stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"HTTPS: %@:443\nHTTP: %@:%@\nUpload: %@:%@\nFTP: %@:%@ - Any Username & Password", [self hostname], [self hostname], [[NSUserDefaults standardUserDefaults] objectForKey:@"HTTPPort"], [self hostname], [[NSUserDefaults standardUserDefaults] objectForKey:@"UploadPort"], [self getIPAddress], [[NSUserDefaults standardUserDefaults] objectForKey:@"FTPPort"]] withString:@""];
    
    _serverAddresses.text = currentAddresses;
}

- (void)showExtraServerAddresses {
    if (![_serverAddresses.text isEqual: @""]) {
        _serverAddresses.text = [NSString stringWithFormat:@"%@\nWebDAV: %@:%@", _serverAddresses.text, [self hostname], [[NSUserDefaults standardUserDefaults] objectForKey:@"WebDAVPort"]];
    } else {
        _serverAddresses.text = [NSString stringWithFormat:@"WebDAV: %@:%@", [self hostname], [[NSUserDefaults standardUserDefaults] objectForKey:@"WebDAVPort"]];
    }
}

- (void)clearExtraServerAddresses {
    NSString *currentAddresses = _serverAddresses.text;
    currentAddresses = [currentAddresses stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"WebDAV: %@:%@", [self hostname], [[NSUserDefaults standardUserDefaults] objectForKey:@"WebDAVPort"]] withString:@""];
    
    _serverAddresses.text = currentAddresses;
}

- (void)checkFirstLoad {
    static NSString* const hasRunAppOnceKey = @"hasRunAppOnceKey";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:hasRunAppOnceKey] == NO)
    {
        NSString *destinationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *directory = destinationPath;
        NSError *error = nil;
        for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
            BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
            if (!success || error) {
                // it failed.
            }
        }
        
        NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"zip"];
        [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
        [defaults setBool:YES forKey:hasRunAppOnceKey];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        [alert showNotice:@"Welcome!" subTitle:[NSString stringWithFormat:@"Everest X is a unique one of a kind iOS multilingual (Multiple Languages) code editor with in-built servers.\n\nEverest X includes a file manager to upload and download files & an IN-APP File Manager & Code Editor.\n\nEverest X includes a HTTP Server, NodeJS Server (Soon) & PHP 7.2 Server (Soon)!\n\nAs Everest X is a free app it relies on ads to fund its development and pay for its AppStore fees."] closeButtonTitle:@"Ok!" duration:0.0f];
    }
    
    static NSString* const hasNewPorts = @"hasNewPorts";

    if ([defaults boolForKey:hasNewPorts] == NO)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", 8080] forKey:@"HTTPPort"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", 3940] forKey:@"UploadPort"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", 2121] forKey:@"FTPPort"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", 9789] forKey:@"WebDAVPort"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Default" forKey:@"portType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [defaults setBool:YES forKey:hasNewPorts];
    }
    
    static NSString* const hasSetTheme = @"hasSetTheme";
    
    if ([defaults boolForKey:hasSetTheme] == NO) {
        [defaults setObject:@"atom-one-dark" forKey:@"editorTheme"];
        [defaults synchronize];
        [defaults setBool:YES forKey:hasSetTheme];
    }
    
    static NSString* const noAds = @"noAds";
    if ([defaults boolForKey:noAds] == NO) {
        //if ([[self hostname] isEqual: @"Joseph-iPhone.local"]) {
        //    [defaults setBool:YES forKey:noAds];
        //} else {
            [self fetchAvailableProducts];
        //}
    }
    
    static NSString* const knowsSwipeBack = @"knowsSwipeBack";
    if ([defaults boolForKey:knowsSwipeBack] == NO) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        [alert showNotice:@"Did you know?" subTitle:[NSString stringWithFormat:@"Did you know, to go to the previous directory in Everest X all you need to do is swipe back! Yep! That's it!"] closeButtonTitle:@"WOW!" duration:0.0f];
        [defaults setBool:YES forKey:knowsSwipeBack];
    } else {
        
    }
}

- (void)checkNoAds {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    static NSString* const noAds = @"noAds";
    if ([defaults boolForKey:noAds] == NO) {
//        [self setupAds];
    } else {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

/* ==== IN APP PURCHASE ==== */
-(void)fetchAvailableProducts {
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:kTutorialPointProductID,nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (BOOL)canMakePurchases {
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseMyProduct:(SKProduct*)product {
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        alert.customViewColor = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showError:self title:@"Dang it!" subTitle:@"Purchasing is disabled on your device!" closeButtonTitle:@"Damn! Thanks G." duration:0.0f]; // Error
    }
}
- (void)purchaseNoAds {
    [self purchaseMyProduct:[validProducts objectAtIndex:0]];
}

- (void)restoreMyProduct:(SKProduct*)product {
    if ([self canMakePurchases]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    } else {
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        alert.customViewColor = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showError:self title:@"Ah Sugar!" subTitle:@"Restoring purchases are disabled on your device!" closeButtonTitle:@"Rats! Thanks G." duration:0.0f]; // Error
    }
}
- (void)restoreNoAds {
    [self restoreMyProduct:[validProducts objectAtIndex:0]];
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    static NSString* const noAds = @"noAds";
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
                
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:kTutorialPointProductID]) {
                    NSLog(@"Purchased ");
                    
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    
                    alert.backgroundType = SCLAlertViewBackgroundBlur;
                    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
                    
                    alert.iconTintColor = [UIColor whiteColor];
                    
                    [alert showSuccess:self title:@"Success!" subTitle:@"Ads have been removed! Thank you for your purchase!" closeButtonTitle:@"Ok!" duration:0.0f];
                    [defaults setBool:YES forKey:noAds];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                if (true) {
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    
                    alert.backgroundType = SCLAlertViewBackgroundBlur;
                    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
                    
                    alert.iconTintColor = [UIColor whiteColor];
                    
                    [alert showSuccess:self title:@"Success!" subTitle:@"Your purchase has been restore and ads have been removed! Thank you for using PangeaX!" closeButtonTitle:@"Ok!" duration:0.0f];
                    [defaults setBool:YES forKey:noAds];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase failed ");
                //                if (true) {
                //                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                //
                //                    [alert showError:self title:@"Oops!" subTitle:@"The purchase has failed due to an unknown error! Please try again later!" closeButtonTitle:@"Ok" duration:0.0f]; // Error
                //                }
                break;
            default:
                break;
        }
    }
}

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response {
    SKProduct *validProduct = nil;
    NSInteger count = [response.products count];
    
    if (count>0) {
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
        
        if ([validProduct.productIdentifier
             isEqualToString:kTutorialPointProductID]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            
            alert.backgroundType = SCLAlertViewBackgroundBlur;
            alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
            
            alert.iconTintColor = [UIColor whiteColor];
            
            SCLButton *button = [alert addButton:@"Sweet! Purchase" actionBlock:^(void) {
                [self purchaseNoAds];
            }];
            
            button.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                
                return buttonConfig;
            };
            
            SCLButton *button2 = [alert addButton:@"Heck yeah! Restore Purchase" actionBlock:^(void) {
                [self restoreNoAds];
            }];
            
            button2.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.38 blue:0.66 alpha:1.0];
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                
                return buttonConfig;
            };
            
            SCLButton *button3 = [alert addButton:@"Nah I'm good!" actionBlock:^(void) {
                
            }];
            
            button3.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                
                return buttonConfig;
            };
            
            [alert showSuccess:self title:validProduct.localizedTitle subTitle:[NSString stringWithFormat:@"%@\nFor: %@", validProduct.localizedDescription, validProduct.price] closeButtonTitle:nil duration:0.0f];
        }
    } else {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        alert.customViewColor = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showError:self title:@"Shoot!" subTitle:@"It seems there are no available products! Come back later!" closeButtonTitle:@"Damn! Aight G." duration:0.0f]; // Error
    }
    
}

@end
