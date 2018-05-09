//
//  ViewController.h
//  Lilian
//
//  Created by Joseph on 12/1/18.
//  Copyright © 2018 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebUploader.h"
#import "BTBlurredStatusBar.h"
#import "GCDWebDAVServer.h"
#import <StoreKit/StoreKit.h>
#import "SCLAlertView.h"
#import "SSZipArchive.h"
#import <unistd.h>
#import "XMFTPServer.h"
#import "PangeaIO-Swift.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@import SafariServices;

@interface ViewController : UIViewController <SKProductsRequestDelegate,SKPaymentTransactionObserver> {
    SKProductsRequest *productsRequest;
    NSArray *validProducts;
}


@end

