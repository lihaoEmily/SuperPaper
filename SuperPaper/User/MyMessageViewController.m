//
//  MyMessageViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageTableViewCell.h"

@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

static NSString *const MessageTableViewCellIdentifier = @"Message";
@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setTableFooterView:[UIView new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: TableViewDatasource,delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageTableViewCellIdentifier];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    cell.timeLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:arc4random()%(3600 * 24 * 365 * 50)]];
    
    cell.titleLabel.text = [self getNameUseGB18030WithLen:5];
    cell.detailsLabel.text = [self getNameUseGB18030WithLen:25];
    return cell;
}

//MARK:Helper

-(NSString *)getNameUseGB18030WithLen:(short)len
{
    NSString *finalString = @"";
    for (int i = 0; i< len; i ++) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSInteger randomL = 0xB0 + arc4random()%(0xD7 - 0xB0 + 1);
        NSInteger randomH;
        if (randomL == 0xD7) {
            randomH = 0xA1 + arc4random()%(0xF9 - 0xA1 + 1);
        }else
            randomH = 0xA1 + arc4random()%(0xFE - 0xA1 + 1);
        
        NSInteger number = (randomH << 8) + randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        
        NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        finalString = [finalString stringByAppendingString:string];
    }
    
    return finalString;
}



        // 现代汉语常用字中的常用字(共2500个)

//        HashSet<char> GetChinese2500()
//
//        {
//            
//            var set = GetChinese3500();
//            
//            set.ExceptWith("匕刁丐歹戈夭仑讥冗邓艾夯凸卢叭叽皿凹囚矢乍尔冯玄邦迂邢芋芍吏夷吁吕吆" +
//                           
//                           "屹廷迄臼仲伦伊肋旭匈凫妆亥汛讳讶讹讼诀弛阱驮驯纫玖玛韧抠扼汞扳抡坎坞抑拟抒芙芜苇芥芯芭杖杉巫" +
//                           
//                           "杈甫匣轩卤肖吱吠呕呐吟呛吻吭邑囤吮岖牡佑佃伺囱肛肘甸狈鸠彤灸刨庇吝庐闰兑灼沐沛汰沥沦汹沧沪忱" +
//                           
//                           "诅诈罕屁坠妓姊妒纬玫卦坷坯拓坪坤拄拧拂拙拇拗茉昔苛苫苟苞茁苔枉枢枚枫杭郁矾奈奄殴歧卓昙哎咕呵" +
//                           
//                           "咙呻咒咆咖帕账贬贮氛秉岳侠侥侣侈卑刽刹肴觅忿瓮肮肪狞庞疟疙疚卒氓炬沽沮泣泞泌沼怔怯宠宛衩祈诡" +
//                           
//                           "帚屉弧弥陋陌函姆虱叁绅驹绊绎契贰玷玲珊拭拷拱挟垢垛拯荆茸茬荚茵茴荞荠荤荧荔栈柑栅柠枷勃柬砂泵" +
//                           
//                           "砚鸥轴韭虐昧盹咧昵昭盅勋哆咪哟幽钙钝钠钦钧钮毡氢秕俏俄俐侯徊衍胚胧胎狰饵峦奕咨飒闺闽籽娄烁炫" +
//                           
//                           "洼柒涎洛恃恍恬恤宦诫诬祠诲屏屎逊陨姚娜蚤骇耘耙秦匿埂捂捍袁捌挫挚捣捅埃耿聂荸莽莱莉莹莺梆栖桦" +
//                           
//                           "栓桅桩贾酌砸砰砾殉逞哮唠哺剔蚌蚜畔蚣蚪蚓哩圃鸯唁哼唆峭唧峻赂赃钾铆氨秫笆俺赁倔殷耸舀豺豹颁胯" +
//                           
//                           "胰脐脓逛卿鸵鸳馁凌凄衷郭斋疹紊瓷羔烙浦涡涣涤涧涕涩悍悯窍诺诽袒谆祟恕娩骏琐麸琉琅措捺捶赦埠捻" +
//                           
//                           "掐掂掖掷掸掺勘聊娶菱菲萎菩萤乾萧萨菇彬梗梧梭曹酝酗厢硅硕奢盔匾颅彪眶晤曼晦冕啡畦趾啃蛆蚯蛉蛀" +
//                           
//                           "唬啰唾啤啥啸崎逻崔崩婴赊铐铛铝铡铣铭矫秸秽笙笤偎傀躯兜衅徘徙舶舷舵敛翎脯逸凰猖祭烹庶庵痊阎阐" +
//                           
//                           "眷焊焕鸿涯淑淌淮淆渊淫淳淤淀涮涵惦悴惋寂窒谍谐裆袱祷谒谓谚尉堕隅婉颇绰绷综绽缀巢琳琢琼揍堰揩" +
//                           
//                           "揽揖彭揣搀搓壹搔葫募蒋蒂韩棱椰焚椎棺榔椭粟棘酣酥硝硫颊雳翘凿棠晰鼎喳遏晾畴跋跛蛔蜒蛤鹃喻啼喧" +
//                           
//                           "嵌赋赎赐锉锌甥掰氮氯黍筏牍粤逾腌腋腕猩猬惫敦痘痢痪竣翔奠遂焙滞湘渤渺溃溅湃愕惶寓窖窘雇谤犀隘" +
//                           
//                           "媒媚婿缅缆缔缕骚瑟鹉瑰搪聘斟靴靶蓖蒿蒲蓉楔椿楷榄楞楣酪碘硼碉辐辑频睹睦瞄嗜嗦暇畸跷跺蜈蜗蜕蛹" +
//                           
//                           "嗅嗡嗤署蜀幌锚锥锨锭锰稚颓筷魁衙腻腮腺鹏肄猿颖煞雏馍馏禀痹廓痴靖誊漓溢溯溶滓溺寞窥窟寝褂裸谬" +
//                           
//                           "媳嫉缚缤剿赘熬赫蔫摹蔓蔗蔼熙蔚兢榛榕酵碟碴碱碳辕辖雌墅嘁踊蝉嘀幔镀舔熏箍箕箫舆僧孵瘩瘟彰粹漱" +
//                           
//                           "漩漾慷寡寥谭褐褪隧嫡缨撵撩撮撬擒墩撰鞍蕊蕴樊樟橄敷豌醇磕磅碾憋嘶嘲嘹蝠蝎蝌蝗蝙嘿幢镊镐稽篓膘" +
//                           
//                           "鲤鲫褒瘪瘤瘫凛澎潭潦澳潘澈澜澄憔懊憎翩褥谴鹤憨履嬉豫缭撼擂擅蕾薛薇擎翰噩橱橙瓢蟥霍霎辙冀踱蹂" +
//                           
//                           "蟆螃螟噪鹦黔穆篡篷篙篱儒膳鲸瘾瘸糙燎濒憾懈窿缰壕藐檬檐檩檀礁磷瞭瞬瞳瞪曙蹋蟋蟀嚎赡镣魏簇儡徽" +
//                           
//                           "爵朦臊鳄糜癌懦豁臀藕藤瞻嚣鳍癞瀑襟璧戳攒孽蘑藻鳖蹭蹬簸簿蟹靡癣羹鬓攘蠕巍鳞糯譬霹躏髓蘸镶瓤矗");
//            
//            return set;
//            
//        }
//        
//        
//        
//        // 现代汉语常用字(共3500个)
//        
//        HashSet<char> GetChinese3500()
//        
//        {
//            
//            var set = new HashSet<char>(GetGB2312String());
//            
//            set.ExceptWith("皑胺盎敖翱佰稗镑鲍钡苯甭迸毖敝陛卞斌摈炳钵铂箔帛蔡搽诧谗掣郴骋炽踌瞅躇滁" +
//                           
//                           "搐椽疵茨蹿瘁淬磋傣殆郸惮迪狄翟滇靛凋迭侗恫犊遁掇剁峨娥厄鄂洱珐藩钒酚汾烽氟涪弗釜腑阜讣噶" +
//                           
//                           "嘎赣皋铬庚龚蛊剐圭癸辊骸氦邯郝菏貉阂涸亨弘瑚桓豢磺簧卉烩姬缉汲蓟伎悸笺缄硷槛饯铰桔睫藉疥" +
//                           
//                           "靳烬粳痉炯厩咎狙疽咀踞娟撅攫抉浚郡喀咯亢柯侩匡岿奎馈婪阑谰佬镭磊傈涟撂廖霖拎羚陇掳麓潞禄" +
//                           
//                           "戮挛孪滦纶嘛谩卯酶镁寐醚幂抿牟氖淖妮霓倪拈啮镍涅哦沤啪琶磐耪呸裴抨砒琵毗痞瞥粕莆埔曝沏祁" +
//                           
//                           "讫扦钎仟堑羌蔷橇鞘沁氰邱酋泅龋颧醛炔榷冉壬妊戎茹孺汝阮鳃莎煽汕缮墒韶邵慑砷娠噬仕孰戍舜朔" +
//                           
//                           "嗣巳怂擞僳隋绥蓑獭挞酞坍绦锑嚏腆迢眺烃汀酮湍陀哇烷皖韦惟潍渭挝斡钨吾毋戊硒矽嘻烯汐檄襄霄" +
//                           
//                           "忻惺墟戌嘘眩绚丫焉阉彦佯疡瑶尧噎耶曳铱颐沂彝矣臆裔诣翌荫寅尹臃痈雍恿铀酉釉盂虞俞渝禹峪驭" +
//                           
//                           "垣苑曰郧匝哉札咋詹辗湛漳瘴肇蛰锗甄砧臻帧峙炙痔诌诛瞩拽篆兹淄孜渍鬃邹纂佐柞");
//            
//            set.UnionWith("叨蜓筝蜻橘匕丐夭叽吆凫阱芙杈岖鸠沐姊卦拗茉昙肴衩玷茴荞荠盹咧昵咪秕胧奕飒炫" +
//                          
//                          "祠荸莺桦唠蚣蚪蚓唧秫麸捺匾蚯蛉啰铐铛笙笤偎徙翎庵涮悴裆谒雳跛锉掰牍腌猬愕鹉蒿榄楣嗦跷蜈嗤" +
//                          
//                          "馍禀缤榛榕嘁嘀幔箫漩橄嘹蝠蝌蝙鲫憔翩嬉缭薇噩蟥霎踱蹂蟆螃鹦瘾缰檐檩瞭蟋蟀朦臊鳄鳍癞璧簸鬓躏");
//            
//            return set;
//            
//        }
//        
//        
//        
//        // 国标一级字(共3755个): 区:16-55, 位:01-94, 55区最后5位为空位
//        
//        string GetGB2312String()
//        
//        {
//            
//            var list = new List<byte>();
//            
//            for (var 区 = 16; 区 <= 55; 区++)
//                
//                for (int 位2 = (区 == 55) ? 89 : 94, 位 = 1; 位 <= 位2; 位++)
//                    
//                {
//                    
//                    list.Add((byte)(区 + 0xa0));
//                    
//                    list.Add((byte)(位 + 0xa0));
//                    
//                }
//            
//            return Encoding.GetEncoding("GB2312").GetString(list.ToArray());
//            
//        }
//        
//    }
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
