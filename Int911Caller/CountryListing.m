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
@synthesize localizedCountryName = _localizedCountryName;

- (CountryListing *) initWithKey:(NSString *) key andNumbers:(NSDictionary *) numbers {
    self = [super init];
    
    self.countryKey = key;
    self.embergencyNumbers = numbers;
    
    return self;
}

- (NSString *)localizedCountryName {
    if(self.countryKey != nil) {
        NSLocale *myLocale = [NSLocale currentLocale];
        NSString *countryCode = self.countryKey;
        NSString *localisedCountryName = [myLocale
                                          displayNameForKey:NSLocaleCountryCode value:countryCode];
        
        return localisedCountryName;
    }
    
    return nil;
}

- (NSComparisonResult)compare:(CountryListing *)otherObject {
    return [[self localizedCountryName] compare:[otherObject localizedCountryName]];
}


@end
