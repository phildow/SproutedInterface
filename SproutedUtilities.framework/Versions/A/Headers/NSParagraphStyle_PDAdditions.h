//
//  NSParagraphStyle_PDAdditions.h
//  SproutedUtilities
//
//  Created by Philip Dow on 2/3/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface NSParagraphStyle (PDAdditions)

+ (NSParagraphStyle*) defaultParagraphStyleWithLineBreakMode:(NSLineBreakMode)lineBreak;
+ (NSParagraphStyle*) defaultParagraphStyleWithAlignment:(NSTextAlignment)textAlignment;

@end
