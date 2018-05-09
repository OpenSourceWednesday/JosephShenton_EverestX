//
//  SetAsLinkSupport.m
//  PangeaIO
//
//  Created by Joseph Shenton on 16/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "SetAsLinkSupport.h"

@implementation NSMutableAttributedString (SetAsLinkSupport)

- (BOOL)setAsLink:(NSString*)textToFind linkURL:(NSString*)linkURL {
    
    NSRange foundRange = [self.mutableString rangeOfString:textToFind];
    if (foundRange.location != NSNotFound) {
        [self addAttribute:NSLinkAttributeName value:linkURL range:foundRange];
        return YES;
    }
    return NO;
}

@end
