//
//  NSDate.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

typedef enum {
    kDateFormat_MM_dd_yyyy_at_hh_mm_AM = 1
} DateFormatType;

- (NSString*)formatWithType:(DateFormatType)format;
- (NSString*)format:(NSString*)format;
- (NSString *)formatRelative;

- (NSDate *)dateWithoutTime;

- (NSDate*)dateByAddingMonths:(int)months;
- (NSDate*)dateByAddingDays:(int)days;
- (NSDate*)dateByAddingHours:(int)hours;
- (NSDate*)dateByAddingMinutes:(int)minutes;

- (bool)isBetweenDate:(NSDate*)firstDate andDate:(NSDate*)secondDate;
- (bool)isBetweenInclusiveDate:(NSDate*)firstDate andDate:(NSDate*)secondDate;
- (bool)isEarlierThanDate:(NSDate*)firstDate;
- (bool)isEarlierThanOrSameAsDate:(NSDate*)firstDate;
- (bool)isSameAsDate:(NSDate*)firstDate;

- (int)daysSinceFirstOfMonth;
- (int)daysSinceFirstOfYear;
@end
