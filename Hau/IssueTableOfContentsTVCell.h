//
//  IssueTableOfContentsTVCell.h
//  Hau
//
//  Created by Andrew on 7/7/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueTableOfContentsTVCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorsLabel;
@property (nonatomic, weak) IBOutlet UILabel *pagesLabel;
@property (nonatomic, weak) IBOutlet UILabel *hasPDFLabel;

- (void)setPdfFileURL:(NSString *)pdfFileURL;

@end
