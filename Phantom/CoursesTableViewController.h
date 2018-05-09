//
//  CoursesTableViewController.h
//  PangeaIO
//
//  Created by Joseph Shenton on 5/3/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "SCLAlertView.h"

@interface CoursesTableViewController : UITableViewController <SKProductsRequestDelegate,SKPaymentTransactionObserver> {
    SKProductsRequest *productsRequest;
    NSArray *validProducts;
}

@end
