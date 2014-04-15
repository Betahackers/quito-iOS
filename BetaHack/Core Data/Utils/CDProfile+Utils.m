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
        
        profile.lastName = @"";
        profile.expertIn = @"being an expert.";
        profile.biography = @"Betahaus member with a passion for life.";
        profile.hometown = @"Barcelona, Catalunya";
        profile.jobTitle = @"FromTo team member";
        
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
    if (expertIn != nil) {
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
        
        NSString *twitter = [json objectForKey:@"twitter_handle"];
        if (twitter != (NSString *)[NSNull null]) {
            self.twitter = twitter;
        }
        
        NSString *url = [json objectForKey:@"website_url"];
        if (url != (NSString *)[NSNull null]) {
            self.url = url;
        }
    }
}

- (NSString*)displayName {
    
    NSMutableString *displayName = [NSMutableString stringWithString:self.firstName];
    if (self.lastName.length > 0) {
        [displayName appendFormat:@" %@", self.lastName];
    }
    return displayName;
}

- (UIImage*)profileImage {
    return [UIImage imageNamed:@"Temp_ProfilePhoto2.jpg"].grayscaleImage;
}

@end
