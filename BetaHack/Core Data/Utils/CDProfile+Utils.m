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

+ (id)initWithJSON:(NSDictionary*)json name:(NSString*)name {
    
    CDProfile *profile = (CDProfile *)[NSEntityDescription insertNewObjectForEntityForName:@"CDProfile" inManagedObjectContext:[[DomainManager sharedManager] context]];
    if (profile) {
        profile.name = name;
        profile.installation = [Installation currentInstallation];
    }
    
    return profile;
}
@end
