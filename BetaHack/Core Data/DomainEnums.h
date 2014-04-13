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
    kFontWeightBold
} FontWeight;

typedef enum {
    kFilterGroupEmotion,
    kFilterGroupCategory,
    kFilterGroupProfile
} FilterGroup;

typedef enum {
    kFilterEmotionIllegal,
    kFilterEmotionSociable,
    kFilterEmotionAdventure,
    kFilterEmotionActive,
    kFilterEmotionCultural,
    kFilterEmotionRomantic,
    kFilterEmotionRelaxed,
    kFilterEmotionSolitary,
    kFilterCategoryEat,
    kFilterCategoryDrink,
    kFilterCategoryHealthyLife,
    kFilterCategoryCulture,
    kFilterCategoryShopping,
    kFilterCategoryDancing,
    kFilterCategoryLiveMusic,
    kFilterCategoryWalks
} FilterType;

@end