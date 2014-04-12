//
//  NSString.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "NSString+Utils.h"
#import "DomainManager.h"

@implementation NSString (Utils)

- (BOOL)containsString:(NSString*)substring {
    
    if ([self rangeOfString:substring].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

- (NSArray*)split {
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
    for (int i=0; i < [self length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
        [characters addObject:ichar];
    }
    return [NSArray arrayWithArray:characters];
}

- (NSString*)reverseString {
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[self length]];
    [self enumerateSubstringsInRange:NSMakeRange(0,[self length]) options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [reversedString appendString:substring];
    }];
    return [NSString stringWithString:reversedString];
}

- (NSString*)removeSpaces {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (CGRect)sizeOfTextWithFont:(UIFont*)font width:(CGFloat)width {
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self attributes:attributesDictionary];
    
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    CGRect rect = [string boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    return rect;
}
@end
