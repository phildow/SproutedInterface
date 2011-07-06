//
//  PDAnnotatedTextStorage.h
//  SproutedInterface
//
//  Created by Philip Dow on 5/24/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>
#import <SproutedInterface/MNLineNumberingTextStorage.h>

@interface PDAnnotatedTextStorage : MNLineNumberingTextStorage {

}

-(BOOL)hasBookmarkAtIndex:(unsigned)index inTextView:(NSTextView*)textView effectiveRange:(NSRangePointer)aRange;

@end
