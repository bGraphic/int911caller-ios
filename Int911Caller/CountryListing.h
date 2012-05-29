//
//  CountryListing.h
//  Int911Caller
//
//  Created by Benedicte Raae on 29.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryListing : NSObject

@property NSString *countryKey;
@property NSDictionary *embergencyNumbers;

- (CountryListing *) initWithKey:(NSString *) key andNumbers:(NSDictionary *) numbers;
- (NSString *)localizedCountryName;

@end
