#coding=utf8
import random
import itchat
from itchat.content import *

all_jokes = [
    '小白兔蹦蹦跳跳到面包房，问：“老板，你们有没有一百个小面包啊？” 老板：“啊，真抱歉，没有那么多” “这样啊。。。”小白兔垂头丧气地走了。\
    第二天，小白兔蹦蹦跳跳到面包房,“老板，有没有一百个小面包啊？” 老板：“对不起，还是没有啊” “这样啊。。。”小白兔又垂头丧气地走了。\
    第三天，小白兔蹦蹦跳跳到面包房,“老板，有没有一百个小面包 啊？” 老板高兴的说：“有了，有了，今天我们有一百个小面包了！！” 小白兔掏出钱：“太好了，我买两个！”',

    '第一天，小白兔去河边钓鱼，什么也没钓到，回家了。\
    第二天，小白兔又去河边钓鱼，还是什么也没钓到，回家了。\
    第三天，小白兔刚到河边，一条大鱼从河里跳出来，冲着小白兔大叫：你他妈的要是再敢用胡箩卜当鱼饵，我就扁死你！',

    '熊和小白兔在森林里便便，完了熊问小白兔“你掉毛吗？” 小白兔说“不掉~” 于是熊就拿起小白兔擦屁股。',

    '有一只小白兔强奸了一只大灰狼，然后就跑了,大灰狼愤而追之, 小白兔眼看大灰狼快要追上了, 便在一棵树下坐下来, 戴起墨镜,拿张报纸看, 假装什么事也没有发生过, 这时大灰狼跑来了,看见坐在树下的小白兔, 问道:"有没有看见一只跑过去的小白兔!" 小白兔答道:"是不是一只非礼了大灰狼的小白兔?" 大灰狼大呼:"不会吧!这么快就上报纸了!!!" ',

    '有一天小白兔快乐地奔跑在森林中, 在路上它碰到一只正在卷大麻的长颈鹿, 小白兔对长颈鹿说: "长颈鹿长颈鹿,你为什么要做伤害自己的事呢? 看看这片森林多么美好,让我们一起在大自然中奔跑吧!" 长颈鹿看看大麻烟,看看小白兔,于是把大麻烟向身后一扔, 跟着小白兔在森林中奔跑. 后来它们遇到一只正在准备吸古柯碱的大象, 小白兔对大象说: "大象大象,你为什么要做伤害自己的事呢? 看看这片森林多么美好,让我们一起在大自然中奔跑吧!" 大象看看古柯碱,看看小白兔,于是把古柯碱向身后一扔, 跟着小白兔和长颈鹿在森林中奔跑. 后来它们遇到一只正在准备打海洛因的狮子, 小白兔对狮子说: "狮子狮子,你为什么要做伤害自己的事呢? 看看这片森林多么美好,让我们一起在大自然中奔跑吧!" 狮子看看针筒,看看小白兔,于是把针筒向身后一扔, 冲过去把小白兔狠揍了一顿. 大象和长颈鹿吓得直发抖:"你为什么要打小白兔呢? 它这么好心,关心我们的健康又叫我们接近大自然." 狮子生气地说:"这个混蛋小白兔,每次嗑了摇头丸就拉着我像白痴一样在森林里乱跑."',

    '三个小白兔采到一个蘑菇。两个大的让小的去弄一些野菜一起来吃， 小的说：我不去！我走了，你们就吃了我的蘑菇了……两个大的： 不会的，放心去把。于是小白兔就去了~~~半年过去了，小白兔还没回来。一个大的说：它不回来了，我门吃吧……另一个大的说：再等等吧~~~ 一年过去了小白兔还没回来……两个大的商量：不必等了，我们吃了吧……就在这时那个小的白兔突然从旁边丛林中跳出来，生气的说：看!我就知道你们要吃我的蘑菇！',

    '小白兔和大狗熊走在森林里,不小心踢翻一只壶。壶里出来一精灵,说可以满足它们各三个愿望。狗熊说,把它变成世界上最强壮的狗熊。它的愿望实现了。小白兔说,给它一顶小头盔。它的愿望也实现了。狗熊说,把它变成世界上最漂亮的狗熊。它的愿望又实现了。小白兔说,给它一辆自行车。它的愿望又实现了。狗熊说,把世界上其它的狗熊全变成母狗熊! 小白兔骑上自行车,一边跑一边说,把这只狗熊变成同性恋。',

    '小灰狼喜欢素食，小灰狼爸妈很苦恼。一日，见小灰狼狂追小白兔，甚喜，最终小灰狼摁住小白兔，恶狠狠地说：兔崽子，把胡萝卜交出来！',

    '小白兔：快问我。快问我。“你是小白兔么？”\
    大灰狼：“你是小白兔么？”\
    小白兔：“对啊对啊。我就是小白兔”\
    小白兔：快问我。快问我。“你是长颈鹿么？”\
    大灰狼：“你是长颈鹿么？”\
    小白兔：“你TM傻啊。我不告诉你我是小白兔了么？！”\
    大灰狼：“。。。”',

    '一天,有一只非常可爱的小白兔跑在大森林里,结果迷路了。这时它看到一只小黑兔,便跑去问："小黑兔哥哥,小黑兔哥哥,我在大森林里迷路了,怎样才能走出大森林呀？"小黑兔问："你想知道吗？"小白兔说："想。"小黑兔说："你想知道的话,就得先让我舒服舒服。"小白兔没法子,只好让小黑兔舒服舒服。小黑兔于是就告诉小白兔怎么走,小白兔知道了,就继续蹦蹦跳跳地往前跑。\
    跑着跑着,小白兔又迷路了,结果碰上一只小灰兔。小白兔便跑去问："小灰兔哥哥,小灰兔哥哥,我在大森林里迷路了,怎样才能走出大森林呀？"小灰兔问："你想知道吗？"小白兔说："想。"小灰兔说："你想知道的话,就得先让我舒服舒服。"小白兔没法子,只好让小灰兔也舒服舒服。小灰兔于是就告诉小白兔怎么走,小白兔知道了,就又继续蹦蹦跳跳地往前跑。\
    结果又迷路了,这时,它碰上一只小花兔,这回小白兔可学乖了,跑过去说："小花兔哥哥,小花兔哥哥,你要是告诉我怎样才能走出大森林,我就让你舒服舒服。"\
    小花兔一听,登时抡圆了给小白兔一个大嘴巴,说："我靠,你丫是问路呐,还是找办呐？" ',

    '小白兔约大灰狼去喝啤酒,大灰狼醉了,小白兔趁机把大灰狼给强奸了,过了几天小白兔又叫大灰狼去喝酒,大灰狼说:‘哎!不去了!不去了!,喝完啤酒屁股疼’',

    '话说有三只兔子拉便便。第一只拉出来的是长条的，第二只拉出来的是圆形的，第三只拉出的居然是六芒星型。为什么？另外两只兔子也问了，第三只兔子说，我用手捏的。',

]

@itchat.msg_register([TEXT])
def text_reply(msg):
    if msg['Text'] == '讲个笑话':
        i = random.randrange(0, len(all_jokes))
        #print(all_jokes[i], '@482f24ba78542b322e073d17293df80c')
        #itchat.send(all_jokes[i], '@482f24ba78542b322e073d17293df80c')
        print(all_jokes[i], msg['FromUserName'])
        itchat.send(all_jokes[i], msg['FromUserName'])
        return
        #return all_jokes[i]

itchat.auto_login(hotReload=True)
itchat.run()
