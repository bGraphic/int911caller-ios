//
//  CountryListing.m
//  Int911Caller
//
//  Created by Benedicte Raae on 29.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountryListing.h"

@implementation CountryListing

@synthesize countryKey = _countryKey;
@synthesize embergencyNumbers = _embergencyNumber;
@synthesize landlineNumbers = _landlineNumbers;
@synthesize localizedCountryName = _localizedCountryName;

- (CountryListing *) initWithKey:(NSString *) key andNumbers:(NSDictionary *) numbers {
    self = [super init];
    
    self.countryKey = key;
    self.embergencyNumbers = numbers;
    
    return self;
}

- (NSString *)localizedCountryName {
    if(self.countryKey != nil) {
        return [CountryListing localizedCountryNameFromCountryKey:self.countryKey];
    }
    
    return nil;
}

- (NSComparisonResult)compare:(CountryListing *)otherObject {
    return [[self localizedCountryName] compare:[otherObject localizedCountryName]];
}

+ (NSString *) localizedCountryNameFromCountryKey: (NSString *) countryKey {
    NSLocale *myLocale = [NSLocale currentLocale];
    NSString *countryCode = countryKey;
    NSString *localisedCountryName = [myLocale
                                      displayNameForKey:NSLocaleCountryCode value:countryCode];
    
    return localisedCountryName;
}

+ (NSString *)landlineStringFrom:(NSDictionary *)landlineDictionary 
{
    NSString *landlineString = [[NSString alloc] init];
    
    if(landlineDictionary.count == 1) {
        return [landlineString stringByAppendingFormat:@"%@", [landlineDictionary.allValues objectAtIndex:0]];
    } else {
        int i = 1;
        for(NSString *key in landlineDictionary) {
            
            NSString *countryString = [NSString stringWithFormat:@"%@ - %@", NSLocalizedString(key, nil), [landlineDictionary objectForKey:key]];
            
            if(i < landlineDictionary.count-1) {
                countryString = [countryString stringByAppendingFormat:@", "];
            } else if(i == landlineDictionary.count) {
                countryString = [NSString stringWithFormat:@"\n%@ %@.", NSLocalizedString(@"or", nil), countryString];
            }
            
            landlineString = [landlineString stringByAppendingString:countryString];
            
            i++;
        }
    }
    
    return landlineString;
}


@end
