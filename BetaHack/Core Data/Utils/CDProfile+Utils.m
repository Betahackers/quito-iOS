//
//  CDProfile.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDProfile+Utils.h"
#import "DomainManager.h"

@implementation CDProfile (Utils)

+ (id)initWithJSON:(NSDictionary*)json {
    
    CDProfile *profile = (CDProfile *)[NSEntityDescription insertNewObjectForEntityForName:@"CDProfile" inManagedObjectContext:[[DomainManager sharedManager] context]];
    if (profile) {
        
        profile.installation = [Installation currentInstallation];
        
        profile.identifier = [[json objectForKey:@"id"] intValue];
        [profile updateWithJSON:json];
    }
    
    return profile;
}

- (void)updateWithJSON:(NSDictionary*)json {
    
    NSString *firstName = [json objectForKey:@"first_name"];
    self.firstName = firstName;
    
    NSString *lastName = [json objectForKey:@"last_name"];
    if (lastName != (NSString *)[NSNull null]) {
        self.lastName = lastName;
    }
    
    NSString *expertIn = [json objectForKey:@"expert_in"];
    if (expertIn != (NSString *)[NSNull null]) {
        self.expertIn = expertIn;
    }
    
    NSString *biography = [json objectForKey:@"about"];
    if (biography != (NSString *)[NSNull null]) {
        self.biography = biography;
    }
    
    NSString *hometown = [json objectForKey:@"nationality"];
    if (hometown != (NSString *)[NSNull null]) {
        self.hometown = hometown;
    }
    
    NSString *jobTitle = [json objectForKey:@"profession"];
    if (jobTitle != (NSString *)[NSNull null]) {
        self.jobTitle = jobTitle;
    }
}

- (NSString*)displayName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (UIImage*)profileImage {
    return [UIImage imageNamed:@"Temp_ProfilePhoto2.jpg"];
}

@end
