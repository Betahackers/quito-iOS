//
//  NSDate.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

#pragma mark - date formatting
- (NSString*)formatWithType:(DateFormatType)format {
    
    switch (format) {
        case kDateFormat_MM_dd_yyyy_at_hh_mm_AM: {
            
            NSString *dateFormat = [self format:@"MM/dd/yyyy"];
            NSString *timeFormat = [self format:@"hh:mm a"];
            return [NSString stringWithFormat:@"%@ at %@", dateFormat, timeFormat];
            break;
        }
            
        default:
            break;
    }
}

- (NSString*)format:(NSString*)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSString *stringFromDate = [formatter stringFromDate:self];
    return stringFromDate;
}

- (NSString *)formatRelative {
    
    //the date formate will be one of these
    //Today, hh:mm AMPM
    //MMMM D, hh:mm AMPM
    //MMMM D YYYY, hh:mm AMPM
	
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	NSDate *midnightEndOfToday = [midnight dateByAddingDays:1];
    
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
	NSString *displayString = nil;
	
    //if the date is today
    if ([self isBetweenInclusiveDate:midnight andDate:midnightEndOfToday]) {
        [displayFormatter setDateFormat:@"'Today, ' h:mm a"]; // at 11:30 am
    } else {
        
        //if the date is during this year, ignore the year part
        // check if same calendar year
        NSInteger thisYear = [offsetComponents year];
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
        NSInteger thatYear = [dateComponents year];
        if (thatYear >= thisYear) {
            [displayFormatter setDateFormat:@"MMM d',' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"MMM d yyyy',' h:mm a"]; // at 11:30 am
        }
    }
    
	// use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:self];
	return displayString;
}

#pragma mark - dateWithoutTime
- (NSDate *)dateWithoutTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDateComponents* comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

#pragma mark - dateByAdding
- (NSDate*)dateByAddingMonths:(int)months {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *monthComponent = [[NSDateComponents alloc] init];
    monthComponent.month = months;
    
    return [gregorian dateByAddingComponents:monthComponent toDate:self options:0];
}

- (NSDate*)dateByAddingDays:(int)days {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    
    return [gregorian dateByAddingComponents:dayComponent toDate:self options:0];
}

- (NSDate*)dateByAddingHours:(int)hours {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *hourComponent = [[NSDateComponents alloc] init];
    hourComponent.hour = hours;
    
    return [gregorian dateByAddingComponents:hourComponent toDate:self options:0];
}

- (NSDate*)dateByAddingMinutes:(int)minutes {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *minuteComponent = [[NSDateComponents alloc] init];
    minuteComponent.minute = minutes;
    
    return [gregorian dateByAddingComponents:minuteComponent toDate:self options:0];
}

#pragma mark - isDate
- (bool)isBetweenDate:(NSDate*)firstDate andDate:(NSDate*)secondDate {
    
    //this function will return true is "myDate" is between the firstDate and secondDate
    //it will be false if myDate is the same as either of the other two
    
    if (([self compare:firstDate] == NSOrderedDescending) &&
        ([self compare:secondDate] == NSOrderedAscending)) {
        
        return YES;
    } else {
        return NO;
    }
}

- (bool)isBetweenInclusiveDate:(NSDate*)firstDate andDate:(NSDate*)secondDate {
    
    //this function will return true is "myDate" is between the firstDate and secondDate
    //it will be false if myDate is the same as either of the other two
    
    if (([self compare:firstDate] == NSOrderedDescending || [self compare:firstDate] == NSOrderedSame) &&
        [self compare:secondDate] == NSOrderedAscending) {
        
        return YES;
    } else {
        return NO;
    }
}

- (bool)isEarlierThanDate:(NSDate*)firstDate {
    
    if ([self compare:firstDate] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

- (bool)isEarlierThanOrSameAsDate:(NSDate*)firstDate {
    
    if ([self compare:firstDate] == NSOrderedAscending || [self compare:firstDate] == NSOrderedSame ) {
        return YES;
    } else {
        return NO;
    }
}

- (bool)isSameAsDate:(NSDate*)firstDate {
    
    if ([self compare:firstDate] == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

- (int)daysSinceFirstOfMonth {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    return (int)[currentCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self] - 1;
}

- (int)daysSinceFirstOfYear {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    return (int)[currentCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self] - 1;
}

@end
