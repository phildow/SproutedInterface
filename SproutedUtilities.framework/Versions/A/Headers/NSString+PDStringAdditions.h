//
//  NSString+PDStringAdditions.h
//  SproutedUtilities
//
//  Created by Philip Dow on 5/30/06.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface NSString (PDStringAdditions)

- (BOOL) matchesRegex:(NSString*)regex;
- (BOOL) regexMatches:(NSString*)aString;

- (BOOL) isWellformedURL;
- (BOOL) isOnlyWhitespace;

- (NSArray*) substringsWithRanges:(NSArray*)ranges;
- (NSArray*) rangesOfString:(NSString*)aString options:(unsigned)mask range:(NSRange)aRange;

- (NSString*) pathSafeString;
- (BOOL) isFilePackage;
- (NSString*) stringByStrippingAttachmentCharacters;

- (NSString*) MD5Digest;

- (NSString*) pathWithoutOverwritingSelf;
- (NSString*) capitalizedStringWithoutAffectingOtherLetters;

- (NSAttributedString*) attributedStringSyntaxHighlightedForHTML;
- (NSString*) stringAsHTMLDocument:(NSString*)title;

- (NSComparisonResult) compareVersion:(NSString*)versionB;

@end
