//
//  CoursesTableViewController.m
//  PangeaIO
//
//  Created by Joseph Shenton on 5/3/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "CoursesTableViewController.h"
#define phpCourseID @"phpCourse"
#define allCoursesID @"allCourses"

@interface CoursesTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *unlockedAllStatus;
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@end

@implementation CoursesTableViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    static NSString* const AllCourses = @"hasAllCourses";
    if ([defaults boolForKey:AllCourses] == NO) {
        
    } else {
        _unlockedAllStatus.text = @"All courses unlocked!";
        _allButton.enabled = false;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unlockAllCourses:(UIButton *)sender {
    [self fetchAvailableProducts2];
}

- (IBAction)showHTMLCourse:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"FrontEnd" forKey:@"viewCourse"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showHTMLBeginners" object:nil];
}

- (IBAction)showPHPCourse:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    static NSString* const PHPCourse = @"hasPHPCourse";
    static NSString* const AllCourses = @"hasAllCourses";
    if ([defaults boolForKey:PHPCourse] == NO || [defaults boolForKey:AllCourses] == NO) {
        [self fetchAvailableProducts];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"PHP" forKey:@"viewCourse"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showHTMLBeginners" object:nil];
    }
}

/* ==== IN APP PURCHASE ==== */
-(void)fetchAvailableProducts {
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:phpCourseID,nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

-(void)fetchAvailableProducts2 {
    NSSet *productIdentifiers = [NSSet setWithObjects:allCoursesID,nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
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
- (void)purchasePHPCourse {
    [self purchaseMyProduct:[validProducts objectAtIndex:0]];
}

- (void)purchaseAllCourses {
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
- (void)restorePHPCourse {
    [self restoreMyProduct:[validProducts objectAtIndex:0]];
}

- (void)restoreAllCourse {
    [self restoreMyProduct:[validProducts objectAtIndex:0]];
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    static NSString* const PHPCourse = @"hasPHPCourse";
    static NSString* const AllCourses = @"hasAllCourses";
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
                
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:phpCourseID]) {
                    NSLog(@"Purchased ");
                    
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    
                    alert.backgroundType = SCLAlertViewBackgroundBlur;
                    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
                    
                    alert.iconTintColor = [UIColor whiteColor];
                    
                    [alert showSuccess:self title:@"Success!" subTitle:@"You've unlocked the PHP Course! Thank you for your purchase!" closeButtonTitle:@"Ok!" duration:0.0f];
                    [defaults setBool:YES forKey:PHPCourse];
                }
                if ([transaction.payment.productIdentifier
                     isEqualToString:allCoursesID]) {
                    NSLog(@"Purchased ");
                    
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    
                    alert.backgroundType = SCLAlertViewBackgroundBlur;
                    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
                    
                    alert.iconTintColor = [UIColor whiteColor];
                    
                    [alert showSuccess:self title:@"Success!" subTitle:@"You've unlocked all future and current courses! Thank you for your purchase!" closeButtonTitle:@"Ok!" duration:0.0f];
                    [defaults setBool:YES forKey:AllCourses];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                if ([transaction.payment.productIdentifier isEqualToString:PHPCourse]) {
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    
                    alert.backgroundType = SCLAlertViewBackgroundBlur;
                    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
                    
                    alert.iconTintColor = [UIColor whiteColor];
                    
                    [alert showSuccess:self title:@"Success!" subTitle:@"Your purchase has been restore and the PHP Course has been unlocked! Thank you for using Everest X!" closeButtonTitle:@"Ok!" duration:0.0f];
                    [defaults setBool:YES forKey:PHPCourse];
                }
                
                if ([transaction.payment.productIdentifier isEqualToString:AllCourses]) {
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    
                    alert.backgroundType = SCLAlertViewBackgroundBlur;
                    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
                    
                    alert.iconTintColor = [UIColor whiteColor];
                    
                    [alert showSuccess:self title:@"Success!" subTitle:@"Your purchase has been restore and all courses future and current have been unlocked! Thank you for using Everest X!" closeButtonTitle:@"Ok!" duration:0.0f];
                    [defaults setBool:YES forKey:AllCourses];
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
             isEqualToString:phpCourseID]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            
            alert.backgroundType = SCLAlertViewBackgroundBlur;
            alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
            
            alert.iconTintColor = [UIColor whiteColor];
            
            SCLButton *button = [alert addButton:@"Sweet! Purchase" actionBlock:^(void) {
                [self purchasePHPCourse];
            }];
            
            button.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                
                return buttonConfig;
            };
            
            SCLButton *button2 = [alert addButton:@"Heck yeah! Restore Purchase" actionBlock:^(void) {
                [self restorePHPCourse];
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
        
        validProduct = [response.products objectAtIndex:0];
        
        if ([validProduct.productIdentifier
             isEqualToString:allCoursesID]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            
            alert.backgroundType = SCLAlertViewBackgroundBlur;
            alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
            
            alert.iconTintColor = [UIColor whiteColor];
            
            SCLButton *button = [alert addButton:@"Sweet! Purchase" actionBlock:^(void) {
                [self purchaseAllCourses];
            }];
            
            button.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                
                return buttonConfig;
            };
            
            SCLButton *button2 = [alert addButton:@"Heck yeah! Restore Purchase" actionBlock:^(void) {
                [self restoreAllCourse];
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
