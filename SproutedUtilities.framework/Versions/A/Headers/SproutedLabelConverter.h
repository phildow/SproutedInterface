//
//  SproutedLabelConverter.h
//  SproutedUtilities
//
//  Created by Philip Dow on 8/27/08.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface SproutedLabelConverter : NSObject {

}

+ (NSInteger) finderEquivalentForSproutedLabel:(NSInteger)value;
+ (NSInteger) sproutedEquivalentForFinderLabel:(NSInteger)value;

@end
