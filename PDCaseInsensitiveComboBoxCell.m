//
//  PDCaseInsensitiveComboBox.m
//  SproutedInterface
//
//  Created by Philip Dow on 3/17/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDCaseInsensitiveComboBoxCell.h>

@implementation PDCaseInsensitiveComboBoxCell

-(NSString*)completedString:(NSString*)substring
{
	if([self usesDataSource])
	{
		return[super completedString:substring];
	}
	else //basicallydowhatcompleteshoulddo--becaseinsensitive.
	{
		NSArray* currentList=[self objectValues];
		NSEnumerator* theEnum=[currentList objectEnumerator];
		id eachString;
		int maxLength=0;
		NSString* bestMatch=@"";

		while(nil!=(eachString=[theEnum nextObject]))
		{
			NSString* commonPrefix= [eachString commonPrefixWithString:substring options:NSCaseInsensitiveSearch];
			if([commonPrefix length]>=[substring length]&&[commonPrefix length]>maxLength)
			{
				maxLength=[commonPrefix length];
				bestMatch=eachString;
				break;

				//Build match string based on what user has typed so far, to show changes in capitalization.
				//bestMatch=[NSString stringWithFormat:@"%@%@",substring, [eachString substringFromIndex:[substringlength]]];
			}
		}
		return bestMatch;
	}
}

@end