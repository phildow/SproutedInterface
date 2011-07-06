//
//  PDAnnotatedTextStorage.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/24/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDAnnotatedTextStorage.h>

#define MarkerAttributeName NSToolTipAttributeName

@implementation PDAnnotatedTextStorage

-(BOOL)hasBookmarkAtIndex:(unsigned)index inTextView:(NSTextView*)textView
{
	//NSRange paragraphRange = 
	//[textView selectionRangeForProposedRange:NSMakeRange(index, 1) granularity:NSSelectByParagraph];
	
	//NSLog(@"%@ %s - %i, %i", [self className], _cmd, NSMaxRange(paragraphRange) -1);
	
	//id attribute = [self attribute:MarkerAttributeName atIndex:NSMaxRange(paragraphRange) -1 effectiveRange:NULL];
	id attribute = [self attribute:MarkerAttributeName atIndex:index effectiveRange:NULL];
	if( attribute != NULL )
		return YES;
	else
		return NO;
}

-(BOOL)hasBookmarkAtIndex:(unsigned)index inTextView:(NSTextView*)textView effectiveRange:(NSRangePointer)aRange
{
	//NSRange paragraphRange = 
	//[textView selectionRangeForProposedRange:NSMakeRange(index, 1) granularity:NSSelectByParagraph];
	
	//NSLog(@"%@ %s - %i, %i", [self className], _cmd, NSMaxRange(paragraphRange) -1);
	
	id attribute = [self attribute:MarkerAttributeName atIndex:index effectiveRange:aRange];
	if( attribute != NULL )
		return YES;
	else
		return NO;
}

-(void)setBookmarkAtIndex:(unsigned)index flag:(BOOL)flag  inTextView:(NSTextView*)textView
{
	NSRange paragraphRange = 
	[textView selectionRangeForProposedRange:NSMakeRange(index, 1) granularity:NSSelectByParagraph];
	
	[self addAttribute:MarkerAttributeName value:@"My Comment" range:NSMakeRange(NSMaxRange(paragraphRange)-1,1)];
}

@end
