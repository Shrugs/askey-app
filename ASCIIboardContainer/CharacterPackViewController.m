//
//  CharacterPackViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "CharacterPackViewController.h"
#import "Config.h"
#import "UIImage+ASCII.h"
#import <Masonry.h>
#import "CharacterPackButton.h"

#define SCROLL_VIEW_HEIGHT 300
#define TEXTVIEW_OFFSET 10

@interface CharacterPackViewController ()

@end

@implementation CharacterPackViewController

- (id)initWithCharacterPacks:(NSArray *)packs andPurchased:(BOOL)purchased {
    self = [super init];
    if (self) {
        _packs = packs;
        _isPurchased = purchased;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = ASKEY_BACKGROUND_COLOR;
    self.view.backgroundColor = ASKEY_BACKGROUND_COLOR;

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    _textViewScrollView = [[UIScrollView alloc] init];

    int totalCapacity = 0;
    for (NSMutableDictionary *_pack in _packs) {
        totalCapacity += [[_pack objectForKey:@"packs"] count];
    }

    _textViews = [[NSMutableArray alloc] initWithCapacity:totalCapacity];
    for (NSMutableDictionary *_pack in _packs) {
        for (NSMutableDictionary *pack in [_pack objectForKey:@"packs"]) {
            UITextView *tv = [[UITextView alloc] init];
            tv.scrollEnabled = NO;
            tv.backgroundColor = ASKEY_BACKGROUND_COLOR;
            [tv setTextColor:[UIColor blackColor]];

            // get ascii
            BOOL isMail = [[_pack objectForKey:@"keyName"] isEqualToString:@"mail"];

            [self setTextForTextView:tv andPack:pack andIsMail:isMail];

            [tv setFont:[UIFont fontWithName:ASKEY_TITLE_FONT size:isMail ? 12 : 20]];

            [_textViewScrollView addSubview:tv];
            [_textViews addObject:tv];
        }
    }

    _textViewScrollView.contentSize = CGSizeMake(0, _textViewScrollView.contentSize.height);
    [_scrollView addSubview:_textViewScrollView];

    [_textViewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView).offset(SMALL_HEADER_HEIGHT);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@(SCROLL_VIEW_HEIGHT));
    }];

    // title and description
    UILabel *title = [[UILabel alloc] init];
    [title setFont:[UIFont fontWithName:ASKEY_TITLE_FONT size:30]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0]];

    _keyName = [_packs count] > 1 ? @"bundle" : [[_packs objectAtIndex:0] objectForKey:@"keyName"];

    NSString *largePackName = [_keyName uppercaseString];
    NSString *titleKey = [NSString stringWithFormat:@"%@_PACK", largePackName];
    [title setText:NSLocalizedString(titleKey, nil)];

    [_scrollView addSubview:title];

    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textViewScrollView.mas_bottom).offset(15);
        make.left.and.right.equalTo(self.view);
    }];

    UILabel *description = [[UILabel alloc] init];
    [description setFont:[UIFont fontWithName:ASKEY_TITLE_FONT size:16]];
    [description setTextAlignment:NSTextAlignmentCenter];
    description.numberOfLines = 10;

    [description setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];

    NSString *descKey = [NSString stringWithFormat:@"%@_PACK_DESCRIPTION", largePackName];

    NSString *text = NSLocalizedString(descKey, nil);

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:15];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [text length])];

    description.attributedText = attributedString;

    [_scrollView addSubview:description];

    [description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];

    CharacterPackButton *buyButton = [[CharacterPackButton alloc] initWithText:[NSString stringWithFormat:@"%@ %@",
                                                                                NSLocalizedString(@"BUY_PACK", nil),
                                                                                NSLocalizedString(titleKey, nil)]
                                                                 andBackground:[NSString stringWithFormat:@"%@bg_large", _keyName]
                                                                     purchased:_isPurchased];
    [buyButton addTarget:self action:@selector(purchasePack) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:buyButton];

    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(description.mas_bottom).offset(15);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.width.equalTo(self.view).multipliedBy(LARGE_BUTTON_RATIO);
        make.centerX.equalTo(self.view);
    }];

}

- (void)setTextForTextView:(UITextView *)tv andPack:(NSMutableDictionary *)pack andIsMail:(BOOL)isMail
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        CGSize numBlocks = CGSizeMake([[pack objectForKey:@"width"] integerValue],
                                      [[pack objectForKey:@"height"] integerValue]);
        NSString *text = [[UIImage imageNamed:@"example_template"] getASCIIWithResolution:numBlocks andChars:[pack objectForKey:@"chars"] andIsHardwrapped:isMail];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self setText:text andLayoutTextView:tv];
        });

    });

}

- (void)purchasePack
{
    
}

- (void) setText:(NSString *)text andLayoutTextView:(UITextView *)tv
{
    [tv setText:text];
    float fullWidth = _textViewScrollView.contentSize.width;

    CGSize textViewSize = [tv sizeThatFits:CGSizeMake(FLT_MAX, SCROLL_VIEW_HEIGHT)];
    float width = textViewSize.width + TEXTVIEW_OFFSET;

    tv.frame = CGRectMake(fullWidth,
                          0,
                          width,
                          _textViewScrollView.frame.size.height);

    fullWidth += width + TEXTVIEW_OFFSET;

    _textViewScrollView.contentSize = CGSizeMake(fullWidth, _textViewScrollView.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
