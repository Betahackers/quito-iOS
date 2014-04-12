//
//  NSString.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

- (BOOL)containsString:(NSString*)substring;
- (NSArray*)split;
- (NSString*)reverseString;
- (NSString*)removeSpaces;

- (CGRect)sizeOfTextWithFont:(UIFont*)font width:(CGFloat)width;
@end