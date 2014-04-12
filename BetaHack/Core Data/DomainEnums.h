//
//  DomainEnums.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DomainEnums : NSObject

typedef enum {
    kFontWeightRegular,
    kFontWeightBold,
    kFontWeightLight
} FontWeight;

typedef enum {
    kFilterGroupEmotion,
    kFilterGroupCategory
} FilterGroup;

typedef enum {
    kFilterEmotion1,
    kFilterEmotion2,
    kFilterEmotion3,
    kFilterEmotion4,
    kFilterEmotion5,
    kFilterEmotion6,
    kFilterEmotion7,
    kFilterEmotion8,
    kFilterCategory1,
    kFilterCategory2,
    kFilterCategory3,
    kFilterCategory4,
    kFilterCategory5,
    kFilterCategory6,
    kFilterCategory7,
    kFilterCategory8
} FilterType;

@end