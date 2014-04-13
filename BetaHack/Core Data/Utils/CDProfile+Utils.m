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
    
    self.firstName = [json objectForKey:@"first_name"];
    self.lastName = [json objectForKey:@"last_name"];
}

- (NSString*)displayName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (UIImage*)profileImage {
    return [UIImage imageNamed:@"Temp_ProfilePhoto.png"];
}

@end
