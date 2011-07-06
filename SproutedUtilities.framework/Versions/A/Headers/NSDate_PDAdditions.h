//
//  NSDate_PDAdditions.h
//  SproutedUtilities
//
//  Created by Phil Dow on 1/10/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface NSDate (PDAdditions)

- (BOOL) fallsOnSameDay:(NSDate*)aDate;
- (NSString*) descriptionAsDifferenceBetweenDate:(NSDate*)aDate;

@end
