//
//  CDProfile.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDProfile.h"
#import "DomainEnums.h"


@interface CDProfile (Utils)

+ (id)initWithJSON:(NSDictionary*)json;
- (void)updateWithJSON:(NSDictionary*)json;

- (NSString*)displayName;
- (NSString*)shortDisplayName;

- (UIImage*)profileImage;

- (NSDate*)updatedDate;
- (void)setUpdatedDate:(NSDate*)updatedDate;

- (void)fetchProfilePhoto:(void (^)(NSError *error))completion;

@end



