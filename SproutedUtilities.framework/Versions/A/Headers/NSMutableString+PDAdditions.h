//
//  NSMutableString (PDAdditions).h
//  SproutedUtilities
//
//  Created by Philip Dow on 7/22/06.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface NSMutableString (PDAdditions)

- (void) replaceOccurrencesOfCharacterFromSet:(NSCharacterSet*)aSet 
		withString:(NSString*)aString options:(unsigned int)mask range:(NSRange)searchRange;

@end
