//
//  AddMoneyViewController.m
//  hongbao
//
//  Created by 高广校 on 15/8/3.
//  Copyright (c) 2015年 wang shuguan. All rights reserved.
//

#import "AddMoneyViewController.h"
#import <StoreKit/StoreKit.h>
#import "AndyDropDownList.h"
#import "TESTDATA.h"
#import "YQPayMethodModel.h"
#import "EntityCatalog.h"
#import "EntityGoods.h"
typedef enum : NSUInteger{
    IAP0p12 = 112,
    IAP1p30 = 130,
    IAP3p45 = 145,
    IAP4p60 = 160,
    IAP5p108= 1108,
}buyCoinsTag;

#define ProductID_IAP0p12 @"112"//
#define ProductID_IAP1p30 @"130" //
#define ProductID_IAP3p45 @"145" //
#define ProductID_IAP4p60 @"160" //
#define ProductID_IAP5p108 @"1108" //

@interface AddMoneyViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver,AndyDropDownDelegate>
{
    NSArray *flowsArray;
    //    BmobObject *gameScore;//保存数据的模型
    NSMutableArray *showCategory;
    NSString *zfbOederId;
}
/**购买的类型*/
@property(nonatomic,assign)NSInteger buyType;
/**付费的类型1支付宝、2内购*/
@property(nonatomic,strong)NSString *type;
/**下拉选择购买选项的菜单*/
@property (nonatomic, strong) AndyDropDownList *list;
/**记录商品是否添加进列表，如果添加了，在交易记录中就可以更交易成功，否则只是完成*/
@property (nonatomic ,strong)EntityGoods *selectGoods;
@end

@implementation AddMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    showCategory = [NSMutableArray new];
    
    //
//    _type = @"2";
    //查询支付方式
    [Service loadBmobObjectByParameters:@{} andByStoreName:@"AppConfigStore" constructingBodyWithBlock:^(CGDataResult *obj, BOOL b) {
        if (b) {
            YQPayMethodModel *pay = [YQPayMethodModel mj_objectWithKeyValues:obj.data];
            
            if ([pay.isAppLocalPay isEqualToString:@"1"]) {
                self->_touchViewOnUnionpay.hidden = NO;
            }
            
            if ([pay.isThirdEnable isEqualToString:@"1"]) {
                self->_type = @"1";
                self->_touchView.hidden = NO;
            }else{
                self->_type = @"2";
            }
            
            [self payType:self->_type];
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [_touchView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapUnion = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewUnionpay:)];
    [_touchViewOnUnionpay addGestureRecognizer:tapUnion];
    
    [self.view addSubview:self.list];
    CGDataResult *r = [TESTDATA testData:@"EntityPay.json"];
    if (r.status.boolValue) {
        EntityCatalog *catalogLog = [EntityCatalog mj_objectWithKeyValues:r.data];
        flowsArray = catalogLog.flows;
        [flowsArray enumerateObjectsUsingBlock:^(EntityGoods *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [showCategory addObject:obj.v];
        }];
        [self updatePointGoodsData:[catalogLog.flows firstObject]];
        
    }
}
#pragma mark - view
-(AndyDropDownList *)list{
    if (!_list){
        _list = [[AndyDropDownList alloc]initWithListDataSource:@[@"12RMB",@"30RMB",@"45RMB",@"60RMB",@"108RMB"] rowHeight:35 indexy:65 view:nil];
        _list.delegate = self;
    }
    return _list;
}
#pragma mark - AndyDropDownList delegate
-(void)dropDownListParame:(NSString *)aStr andViewAndy:(AndyDropDownList *)andyDropDownList{
    [flowsArray enumerateObjectsUsingBlock:^(EntityGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.v isEqualToString:aStr]) {
            [self updatePointGoodsData:obj];
            //            self.buyType = [obj.Id integerValue];
        }
    }];
}
//更新商品数据
-(void)updatePointGoodsData:(EntityGoods *)goodsInfo{
    
    _textFieldMoney.text = goodsInfo.inprice;//显示价格
    
    self.selectGoods = goodsInfo;
    
    self.buyType = [goodsInfo.Id integerValue];
}

-(void)tapView:(UITapGestureRecognizer *)sender{
    
    _type = @"1";
    [self payType:_type];
}
-(void)tapViewUnionpay:(UITapGestureRecognizer *)sender{
    _type  = @"2";
    [self payType:_type];
}

-(void)payType:(NSString *)type{
    if ([self.type isEqualToString:@"1"]) {
        _btZhifu.selected = YES;
        _btImageViewUnionpay.selected = NO;
        //        _btImageViewUnionpay.hidden = YES;
    }else{
        _btZhifu.selected = NO;
        _btImageViewUnionpay.selected = YES;
        
    }
}

- (IBAction)btnClick:(UIButton *)button{
    CGRect rectDropFram = self.list.frame;
    [self.list setShowData:showCategory];
    self.list.frame = rectDropFram;
    [self.list showList:self.list.frame.origin.y];
    
}
- (IBAction)nextButton:(UIButton *)sender {
    
    
    if (_textFieldMoney.text.length == 0) {
        [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"输入金额"];
        return;
    }
    
    if ([[[BmobUser currentUser] objectForKey:@"isExchange"] boolValue]) {
        if ([self.type isEqualToString:@"1"]) {//
//            [BmobPay payWithPayType:BmobAlipay
//                              price:[NSNumber numberWithFloat:[_textFieldMoney.text floatValue]]
//                          orderName:@"聚合币充值"
//                           describe:@"流量充值描述"
//                             result:^(BOOL isSuccessful, NSError *error) {
//                                 if (isSuccessful) {
//
//                                     [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"充值成功"];
//
//
//                                     [self recordTransaction:zfbOederId];
//                                 }
//                                 else{
//
//                                     [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:[error description]];
//
//                                 }
//                             }];
//
//            //订单状态回调
//            [BmobPay orderInfoCallback:^(NSDictionary *orderInfo) {
//                //增加账户充值、处理订单信息
//                zfbOederId  = orderInfo[@"orderNumber"];
//
//            }];
        } else{
            
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
            [dateFormatter setDateFormat:@"YYYYMMDDHHMM"];//设定时间格式,这里可以设置成自己需要的格式
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            
            [self recordTransaction:dateString];
            //采用内购、
//            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//            if ([SKPaymentQueue canMakePayments]) {
//                [self RequestProductData];
//                NSLog(@"允许程序内付费购买");
//            }
        }
    }
    else{
        [self recordTransaction:@"测试。。。。"];
    }
}
-(void)RequestProductData
{
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (self.buyType) {
        case IAP0p12:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP0p12,nil];
            break;
        case IAP1p30:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP1p30,nil];
            break;
        case IAP3p45:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP3p45,nil];
            break;
        case IAP4p60:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP4p60,nil];
            break;
        case IAP5p108:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP5p108,nil];
            break;
            
        default:
            break;
    }
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
    
}
///<> 请求协议
//收到的产品信息
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        
        
        
        
    }
    SKPayment *payment = nil;
    
    //    SKProduct *product = [[SKProduct alloc]init];
    //    product.productIdentifier = ProductID_IAP0p12;
    switch (self.buyType) {
        case IAP0p12:
            payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP0p12];    //支付10
            break;
        case IAP1p30:
            payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP1p30];    //支付108
            break;
        case IAP3p45:
            payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP3p45];    //支付618
            break;
        case IAP4p60:
            payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP4p60];    //支付1048
            break;
        case IAP5p108:
            payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP5p108];    //支付5898
            break;
        default:
            break;
    }
    NSLog(@"---------发送购买请求------------");
    [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"发送购买请求"];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}
- (void)requestProUpgradeProductData
{
    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------反馈信息结束--------------");
    
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                [self completeTransaction:transaction];
                
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"购买成功"
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                
                [alerView show];
                
            } break;
            case SKPaymentTransactionStateFailed://交易失败
            { [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"购买失败，请重新尝试购买"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                
                [alerView2 show];
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"商品添加进列表"];
                break;
            default:
                break;
        }
    }
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            //            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSLog(@"-----交易完成 --------");
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    
    [Service loadBmobanimation:YES andTitle:@"充值中"
         andObjectByParameters:@{@"money":_selectGoods.p,//增加的聚合币
                                 @"totalMoney":_textFieldMoney.text,//充值的人民币钱
                                 @"userName":[BmobUser currentUser].username,
                                 @"payType":[_type isEqualToString:@"1"]?@"zfb":@"Appleng",
                                 @"orderId":product,
                                 @"author":[BmobUser currentUser]
                                                                           }
                andByStoreName:@"AmountAddMoney" constructingBodyWithBlock:^(CGDataResult *obj, BOOL b) {
                                                                               if (b) {
//                                                                                   [[HUDHelper sharedInstance]syncStopLoadingMessage:@""];
                                                                                   [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"充值成功"];
                                                                        
                                                                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                       POP;
                                                                                   });
                                                                               }
                                                                           }];

    
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");
    
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    //    [super dealloc];
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
