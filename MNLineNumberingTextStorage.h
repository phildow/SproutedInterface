
#import <Cocoa/Cocoa.h>

extern const NSString* MarkerAttributeName;

@interface MNLineNumberingTextStorage : NSTextStorage
{
	NSMutableAttributedString *m_attributedString;
	
	
	
	
}

-(BOOL)hasBookmarkAtIndex:(unsigned)index inTextView:(NSTextView*)textView;
	// Check if the paragraph contains index is bookmarked.

-(void)setBookmarkAtIndex:(unsigned)index flag:(BOOL)flag  inTextView:(NSTextView*)textView;
	// Set bookmark to the paragraph contains index.

	// ** note **  
	// Bookmarks are added to paragraphs, not characters.
	// A bookmark is stored as an attribute 'MarkerAttributeName' embedded to return code. 


-(unsigned)paragraphNumberAtIndex:(unsigned)index;
	// return paragraph number contains index




@end
