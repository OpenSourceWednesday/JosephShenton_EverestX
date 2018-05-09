//
//  FileProviderEnumerator.h
//  ImportFiles
//
//  Created by Joseph Shenton on 18/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import <FileProvider/FileProvider.h>

@interface FileProviderEnumerator : NSObject <NSFileProviderEnumerator>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithEnumeratedItemIdentifier:(NSFileProviderItemIdentifier)enumeratedItemIdentifier;

@property (nonatomic, readonly, strong) NSFileProviderItemIdentifier enumeratedItemIdentifier;

@end
