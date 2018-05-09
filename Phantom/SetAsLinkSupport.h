//
//  SetAsLinkSupport.h
//  PangeaIO
//
//  Created by Joseph Shenton on 16/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (SetAsLinkSupport)

- (BOOL)setAsLink:(NSString*)textToFind linkURL:(NSString*)linkURL;

@end
