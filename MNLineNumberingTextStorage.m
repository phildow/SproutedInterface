//
//  FugoCompletionTextStorage.m
//  SampleApp
//
//  Created by Masatoshi Nishikata on 13/02/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <SproutedInterface/MNLineNumberingTextStorage.h>

#define UNIQUECODE [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]


//const NSString* MarkerAttributeName			= @"MarkerAttributeName";
#define MarkerAttributeName NSToolTipAttributeName

@interface MNLineNumberingTextStorage ( NSTextStorage )


- (NSString *)string;
- (NSDictionary *)attributesAtIndex:(unsigned)index effectiveRange:(NSRangePointer)aRange;
- (void)replaceCharactersInRange:(NSRange)aRange withString:(NSString *)str;
- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)aRange;

@end



@implementation MNLineNumberingTextStorage

- (id)init {
    self = [super init];
    if (self) {
		
		// fundamental
		m_attributedString = [[NSMutableAttributedString alloc] init];
		
		
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[m_attributedString release];
	
	
    [super dealloc];
}



-(BOOL)hasBookmarkAtIndex:(unsigned)index inTextView:(NSTextView*)textView
{
	NSRange paragraphRange = 
	[textView selectionRangeForProposedRange:NSMakeRange(index, 1) granularity:NSSelectByParagraph];
	
	id attribute = [self attribute:MarkerAttributeName atIndex:NSMaxRange(paragraphRange) -1 effectiveRange:NULL];
	if( attribute != NULL )
	{
		return [attribute boolValue] ;
	}
	return NO;
}

-(void)setBookmarkAtIndex:(unsigned)index flag:(BOOL)flag  inTextView:(NSTextView*)textView
{
	NSRange paragraphRange = 
	[textView selectionRangeForProposedRange:NSMakeRange(index, 1) granularity:NSSelectByParagraph];
	
	[self addAttribute:MarkerAttributeName value:[NSNumber numberWithBool:flag] range:NSMakeRange(NSMaxRange(paragraphRange)-1,1)];
}



-(unsigned)paragraphNumberAtIndex:(unsigned)index
{
	int paragraphNumber = 1;
	NSString* str = [self string];
	
	unsigned hoge;
	for( hoge = 0; hoge < [str length]; hoge ++ )
	{
		if( index <= hoge )
			break;
		
		unichar	characterToCheck = [str characterAtIndex:hoge];
		
		if (characterToCheck == '\n' || characterToCheck == '\r' ||
			characterToCheck == 0x2028 || characterToCheck == 0x2029)
			
			paragraphNumber++;
		
	}
	
	return paragraphNumber;
	
}

@end


//  ######## fundamental subclassing ##########
@implementation MNLineNumberingTextStorage (NSTextStorage)

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
	
    [m_attributedString replaceCharactersInRange:range withString:str];
    
    int lengthChange = [str length] - range.length;
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:lengthChange];
	
}


- (NSString *)string
{
    return [m_attributedString string];
}

- (NSDictionary *)attributesAtIndex:(unsigned)index effectiveRange:(NSRangePointer)aRange
{
    return [m_attributedString attributesAtIndex:index effectiveRange:aRange];
}



- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)range
{
    [m_attributedString setAttributes:attributes range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
	
}


@end

