//
//  LiveFilterView.m
//  youxibang
//
//  Created by jiazhuo1 on 2018/4/24.
//

#import "LiveFilterView.h"
#import <Masonry/Masonry.h>
#import "LiveFilterTableViewCell.h"
#import <Colours/Colours.h>

@implementation LiveFilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame WithFilterArray:(NSArray *)filterArray AndSelectedIndexArray:(NSMutableArray *)selectedArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.filterArray = filterArray;
        selectedIndexArray = selectedArray;
    }
    return self;
}

- (void)tapBlackView {
    if (self.dismissFilterBlock) {
        self.dismissFilterBlock(selectedIndexArray);
    }
}

- (void)configUI {
    CGFloat screen_width = UIScreen.mainScreen.bounds.size.width;
    CGFloat screen_height = UIScreen.mainScreen.bounds.size.height;
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+40, screen_width, screen_height-40-64)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBlackView)];
    self.blackView.userInteractionEnabled = YES;
    [self.blackView addGestureRecognizer:tap];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableview];
    
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor colorFromHexString:@"777777"] forState:UIControlStateNormal];
    [self addSubview:clearBtn];
    clearBtn.backgroundColor = UIColor.whiteColor;
    [clearBtn addTarget:self action:@selector(clearFilter) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:confirmBtn];
    confirmBtn.backgroundColor = [UIColor colorFromHexString:@"4382ec"];
    [confirmBtn addTarget:self action:@selector(confirmFilter) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:lineLabel];
    lineLabel.backgroundColor = [UIColor colorFromHexString:@"cccccc"];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(screen_width/2, 52));
    }];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.size.equalTo(clearBtn);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(clearBtn.mas_top);
    }];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self);
        make.bottom.mas_equalTo(lineLabel.mas_top);
    }];
}

- (void)clearFilter {
    for (int i=0; i<selectedIndexArray.count; i++) {
        [selectedIndexArray replaceObjectAtIndex:i withObject:@(9999)];
    }
    [self.tableview reloadData];
}

- (void)confirmFilter {
    if (self.confirmFilterBlock) {
        self.confirmFilterBlock(selectedIndexArray);
    }
    [self dismiss];
}

- (void)show {
    [self configUI];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.blackView.alpha = 0.5;
            self.alpha = 1;
        }completion:^(BOOL finished) {
            self.blackView.hidden = NO;
        }];
    });
}

- (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.blackView.alpha = 0;
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.blackView.hidden = YES;
            [self removeFromSuperview];
            [self.blackView removeFromSuperview];
        }];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [[self.filterArray[indexPath.row] allValues].lastObject count];
    if (count%3 == 0) {
        count = (count/3);
    }
    else {
        count = (count/3 + 1);
    }
    return count*30+(count-1)*15+30+34;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    LiveFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LiveFilterTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.typeLabel.text = [self.filterArray[indexPath.row] allKeys].lastObject;
    cell.typeNameArray = [self.filterArray[indexPath.row] allValues].lastObject;
    cell.selectedIndex = [selectedIndexArray[indexPath.row] integerValue];
    cell.selectedTypeBlock = ^(NSInteger index) {
        [selectedIndexArray replaceObjectAtIndex:indexPath.row withObject:@(index)];
    };
    return cell;
}

@end
