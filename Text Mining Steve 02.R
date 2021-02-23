#系統參數設定
Sys.setlocale(category = "LC_ALL", locale = "zh_TW.UTF-8") # 避免中文亂碼
## Warning in Sys.setlocale(category = "LC_ALL", locale = "zh_TW.UTF-8"): OS
## reports request to set locale to "zh_TW.UTF-8" cannot be honored
## [1] ""
#安裝需要的packages
packages = c("dplyr", "tidytext", "jiebaR", "gutenbergr", "stringr","wordcloud", "wordcloud2", "ggplot2", "tidyr", "scales")
existing = as.character(installed.packages()[,1])
for(pkg in packages[!(packages %in% existing)]) install.packages(pkg)
require(dplyr)
require(tidytext)
require(jiebaR)
require(gutenbergr)
library(stringr)
library(wordcloud)
library(wordcloud2)
library(ggplot2)
library(tidyr)
library(scales)

# Jieba套件基本使用
# 初始化斷詞引擎
# # 使用默認參數初始化一個斷詞引擎
jieba_tokenizer = worker()
# 基本斷詞
# 預設好斷詞引擎後，可以使用不同方式進行斷詞。

# 方法一
chi_text <- "孔乙己一到店，所有喝酒的人便都看著他笑，有的叫道，「孔乙己，你臉上又添上新傷疤了！」他不回答，對櫃裡說，「溫兩碗酒，要一碟茴香豆」便排出九文大錢。他們又故意的高聲嚷道，「你一定又偷了人家的東西了！」孔乙己睜大眼睛說，「你怎麼這樣憑空污人清白……」「什麼清白?我前天親眼見你竊了何家的書，吊著打」孔乙己便漲紅了臉，額上的青筋條條綻出，爭辯道，「竊書不能算偷……竊書！……讀書人的事，能算偷麼？」接連便是難懂的話，什麼「君子固窮」，什麼「者乎」之類，引得眾人都鬨笑起來：店內外充滿了快活的空氣。"

# 第一種寫法
# #segment(資料,預設斷詞引擎)
segment(chi_text, jieba_tokenizer)

#方法二
# 第二種寫法
# jieba_tokenizer <= chi_text
cutter[chi_text]

# 第三種寫法
jieba_tokenizer[chi_text]

### 使用者自訂詞彙-----
# check the documentation for worker
?worker
## starting httpd help server ... done
#可調參數
#user使用這自訂辭典
#stop_word
#user_weight權重

# 以預設參數進行斷詞
chi_text_ptt <- "谷乙己一到店，所有的人便都看着他笑，有的叫道，「谷乙己，你身上又添幾筆新訴訟了！」他不回答，對櫃裡說，「抓兩部片，播幾個視頻」便剪出幾段短片。他們又故意的高聲嚷道，「你一定又用未經授權的片源了！」谷乙己睜大眼睛說，「你怎麼這樣憑空汚人清白……」「什麼清白？我前天親眼見你盜了片商版權，給人吉」谷乙己便漲紅了臉，額上的青筋條條綻出，爭辯道，「二創不能算盜……侵權！……二創的事，能算侵權嗎？」接連便是難懂的話，什麼「創作自由」，什麼「網路著作權」之類，引得衆人都鬨笑起來，店內外充滿了快活的空氣。"

segment(chi_text_ptt, jieba_tokenizer)

### 以參數形式手動加入 ----
#用函數或者外部資料新增詞彙，兩種方式
# 動態新增自訂詞彙
#  [49] "你"       "一定"     "又"       "用"       "未經"     "授權"  
new_user_word(jieba_tokenizer, c("谷乙己", "未經授權", "汚人清白", "二創","漲紅","臉"))
# [1] TRUE

segment(chi_text_ptt, jieba_tokenizer)
# [49] "又"       "用"       "未經授權"

### 以外部檔案形式加入
# 使用使用者自訂字典
jieba_tokenizer <- worker(user="user_dict.txt")
segment(chi_text_ptt, jieba_tokenizer)

# 練習時間 (5 mins)
# 請從任意來源(新聞、部落格)擷取一段文字，嘗試初始化一個Jieba引擎來進行斷詞，如果斷詞結果不滿意，嘗試手動加入自訂詞彙來調整斷詞結果。
try<-"高雄市長韓國瑜日前出訪新加坡爭取農產品訂單，近日傳出高雄水果在當地FairPrice超市下架，韓國瑜上午澄清，表示純屬謠言，並感慨說「太多酸言酸語，讓我們不可思議」。"
jieba_tokenizer = worker()

segment(try, jieba_tokenizer)
# [1] "高雄"      "市長"      "韓國"      "瑜"        "日前"      "出訪"      "新加坡"    "爭取"     
# [9] "農產品"    "訂單"      "近日"      "傳出"      "高雄"      "水果"      "在"        "當地"     
# [17] "FairPrice" "超市"      "下架"      "韓國"      "瑜"        "上午"      "澄清"      "表示"     
# [25] "純屬"      "謠言"      "並"        "感慨"      "說"        "太"        "多"        "酸"       
# [33] "言"        "酸"        "語"        "讓"        "我們"      "不可思議" 

new_user_word(jieba_tokenizer, c("高雄市長", "韓國瑜", "酸言酸語"))
segment(try, jieba_tokenizer)
# [1] "高雄市長"  "韓國瑜"    "日前"      "出訪"      "新加坡"    "爭取"      "農產品"    "訂單"     
# [9] "近日"      "傳出"      "高雄"      "水果"      "在"        "當地"      "FairPrice" "超市"     
# [17] "下架"      "韓國瑜"    "上午"      "澄清"      "表示"      "純屬"      "謠言"      "並"       
# [25] "感慨"      "說"        "太"        "多"        "酸言酸語"  "讓"        "我們"      "不可思議" 

# 停用詞使用
# 使用外部檔案作為停用詞參數
jieba_tokenizer <- worker(user="user_dict.txt", stop_word = "stop_words.txt")
segment(chi_text_ptt, jieba_tokenizer)

#使用自定義Vector作為停用詞參數
# 動態新增停用詞
tokens <- segment(chi_text_ptt, jieba_tokenizer)
stop_words <- c("一到", "幾個", "一定", "能算", "便是","了","的" )
res <- filter_segment(tokens, stop_words)
#filter_segment:如果tokens吻合stop_words就移除

# 將詞彙長度為1的詞清除
tokens <- res[nchar(res)>1]
tokens
# [1] "谷乙己"   "所有"     "看着"     "身上"     "幾筆"     "訴訟"     "回答"     "對櫃裡"   "兩部"    
# [10] "視頻"     "剪出"     "幾段"     "短片"     "他們"     "故意"     "高聲"     "未經"     "授權"    
# [19] "片源"     "睜大眼睛" "怎麼"     "這樣"     "憑空"     "清白"     "什麼"     "清白"     "前天"    
# [28] "親眼"     "片商"     "版權"     "給人吉"   "漲紅了臉" "額上"     "青筋"     "條條"     "綻出"    
# [37] "爭辯"     "不能"     "算盜"     "侵權"     "侵權"     "接連"     "難懂"     "的話"     "什麼"    
# [46] "創作自由" "什麼"     "網路"     "著作權"   "之類"     "引得"     "衆人"     "鬨笑"     "起來"    
# [55] "內外"     "充滿"     "快活"     "空氣"  

### 2.文字雲(Word Cloud) ----
# 完成了斷詞之後，才是真正的開始，通常第2步驟就是計算詞彙的頻率，通過詞彙的頻率我們就可以直接使用文字雲的套件wordcloud來視覺化文章的重點了！
# 計算詞彙頻率
txt_freq <- freq(tokens)
# 由大到小排列
txt_freq <- arrange(txt_freq, desc(freq))
# 檢查前5名
head(txt_freq)

# 文字雲套件主要有兩個，wordcloud套件是文字雲的基本款，主要輸出靜態的圖片；wordcloud2顧名思義就是前一個套件的進階版，主要提供互動式的圖片，非常適用在Shiny等網頁中。然而需要注意的是，我認為一般wordcloud的參數比較完整，且兩者參數的命名不盡相同，注意不要混淆了。

par(family=("Microsoft YaHei")) #一般wordcloud需要定義字體，不然會無法顯示中文

# 一般的文字雲 (pkg: wordcloud)
wordcloud(txt_freq$char, txt_freq$freq, min.freq = 2, random.order = F, ordered.colors = F, colors = rainbow(nrow(txt_freq)))

# 互動式文字雲 (pkg: wordcloud2)
wordcloud2(filter(txt_freq, freq > 1), 
           minSize = 2, fontFamily = "Microsoft YaHei", size = 1)


### 案例二 ------
# Jieba套件基本使用
# 初始化斷詞引擎
# # 使用默認參數初始化一個斷詞引擎
jieba_tokenizer = worker()
# 基本斷詞
# 預設好斷詞引擎後，可以使用不同方式進行斷詞。

# 方法一
chi_text <- "紐約商業交易所（NYMEX）6月原油期貨5月6日收盤上漲0.31美元或0.5%成為每桶62.25美元，因伊朗的局勢升溫，歐洲ICE期貨交易所（ICE Futures Europe）近月布蘭特原油上漲0.39美元或0.6%成為每桶71.24美元。路透社報導，美國正在向中東部署一個航母打擊群和一個轟炸機特遣部隊，美國代理國防部長稱伊朗政權的威脅是可信的。 卡達半島電視台網站5月5日報導，美國本月起取消對8個經濟體（中國、印度、日本、韓國、台灣、土耳其、義大利和希臘）購買伊朗石油的豁免，相比去年11月美國對伊朗石油出口實施制裁的時候允許這些國家在6個月內繼續購買以避免過度影響油價，顯然美國認為如今油市已經有足夠的供應。美國國務卿蓬佩奧（Mike Pompeo）表示，美國已經與主要產油國家進行溝通，希望確保油市的供應充足；加上美國國內的產油也在持續增長，這令美國有信心油市的供應不會匱乏。 不過，實際局勢可能未必如美國所想。目前有多個產油國家內政動盪並影響產量，包括阿爾及利亞、安哥拉、利比亞、伊朗、奈及利亞與委內瑞拉，一旦動盪升級，隨時會進一步影響油市供應。此外，伊朗重質原油也並非任何國家都能替代，遑論美國的輕質原油，與伊朗原油在品質上最為相近的是沙烏地阿拉伯，其次為阿拉伯聯合大公國。而如果油價因為任何供應問題再度飆升至每桶100美元，估計將令全球經濟增長削減0.6個百分點，通膨則將上揚0.7個百分點。 油田服務公司貝克休斯（Baker Hughes Inc.）公佈，截至5月3日，美國石油與天然氣探勘井數量較前週減少1座至990座，創下去年3月（990座）以來的13個月新低。其中，主要用於頁岩油氣開採的水平探勘井數量較前週持平為873座。探勘活動的增減會反映未來的石油產量，貝克休斯統計的探勘井是指為開發以及探勘新油氣儲藏所設的鑽井（鑽機）數量。 貝克休斯的數據顯示，截至5月3日，美國石油探勘井數量較前週所創的逾一年新低增加2座至807座，累計今年來仍減少78座；天然氣探勘井數量較前週減少3座至183座。與去年同期相比，美國石油探勘井數量減少27座，天然氣探勘井數量減少13座；水平探勘井數量年減2座。根據美國能源部週度預測數據，截至4月26日當週，美國原油日均產量再創新高水平至1,230萬桶。 在美國最大產油州德州，油氣探勘井數量較前週減少7座至484座，緊鄰德州上方的奧克拉荷馬州油氣探勘井數量較前週增加1座至103座，新墨西哥州油氣探勘井數量較前週增加2座至106座，路易斯安那州油氣探勘井數量較前週持平為62座，北達科他州油氣探勘井數量較前週減少1座至57座。最大頁岩油產地、盤據西德州與新墨西哥州東南部的二疊紀盆地石油探勘井數量較前週減少1座至459座。"

# 第一種寫法
# #segment(資料,預設斷詞引擎)
segment(chi_text, jieba_tokenizer)

#方法二
# 第二種寫法
jieba_tokenizer <= chi_text

# 第三種寫法
jieba_tokenizer[chi_text]

### 使用者自訂詞彙-----
# check the documentation for worker
?worker
## starting httpd help server ... done
#可調參數
#user使用這自訂辭典
#stop_word
#user_weight權重

# 以預設參數進行斷詞
chi_text_ptt <- "紐約商業交易所（NYMEX）6月原油期貨5月6日收盤上漲0.31美元或0.5%成為每桶62.25美元，因伊朗的局勢升溫，歐洲ICE期貨交易所（ICE Futures Europe）近月布蘭特原油上漲0.39美元或0.6%成為每桶71.24美元。路透社報導，美國正在向中東部署一個航母打擊群和一個轟炸機特遣部隊，美國代理國防部長稱伊朗政權的威脅是可信的。 卡達半島電視台網站5月5日報導，美國本月起取消對8個經濟體（中國、印度、日本、韓國、台灣、土耳其、義大利和希臘）購買伊朗石油的豁免，相比去年11月美國對伊朗石油出口實施制裁的時候允許這些國家在6個月內繼續購買以避免過度影響油價，顯然美國認為如今油市已經有足夠的供應。美國國務卿蓬佩奧（Mike Pompeo）表示，美國已經與主要產油國家進行溝通，希望確保油市的供應充足；加上美國國內的產油也在持續增長，這令美國有信心油市的供應不會匱乏。 不過，實際局勢可能未必如美國所想。目前有多個產油國家內政動盪並影響產量，包括阿爾及利亞、安哥拉、利比亞、伊朗、奈及利亞與委內瑞拉，一旦動盪升級，隨時會進一步影響油市供應。此外，伊朗重質原油也並非任何國家都能替代，遑論美國的輕質原油，與伊朗原油在品質上最為相近的是沙烏地阿拉伯，其次為阿拉伯聯合大公國。而如果油價因為任何供應問題再度飆升至每桶100美元，估計將令全球經濟增長削減0.6個百分點，通膨則將上揚0.7個百分點。 油田服務公司貝克休斯（Baker Hughes Inc.）公佈，截至5月3日，美國石油與天然氣探勘井數量較前週減少1座至990座，創下去年3月（990座）以來的13個月新低。其中，主要用於頁岩油氣開採的水平探勘井數量較前週持平為873座。探勘活動的增減會反映未來的石油產量，貝克休斯統計的探勘井是指為開發以及探勘新油氣儲藏所設的鑽井（鑽機）數量。 貝克休斯的數據顯示，截至5月3日，美國石油探勘井數量較前週所創的逾一年新低增加2座至807座，累計今年來仍減少78座；天然氣探勘井數量較前週減少3座至183座。與去年同期相比，美國石油探勘井數量減少27座，天然氣探勘井數量減少13座；水平探勘井數量年減2座。根據美國能源部週度預測數據，截至4月26日當週，美國原油日均產量再創新高水平至1,230萬桶。 在美國最大產油州德州，油氣探勘井數量較前週減少7座至484座，緊鄰德州上方的奧克拉荷馬州油氣探勘井數量較前週增加1座至103座，新墨西哥州油氣探勘井數量較前週增加2座至106座，路易斯安那州油氣探勘井數量較前週持平為62座，北達科他州油氣探勘井數量較前週減少1座至57座。最大頁岩油產地、盤據西德州與新墨西哥州東南部的二疊紀盆地石油探勘井數量較前週減少1座至459座。"

segment(chi_text_ptt, jieba_tokenizer)
# [1] "紐約"         "商業"         "交易所"       "NYMEX"        "6"            "月"      "原油期貨"    
# [8] "5"            "月"           "6"            "日"           "收盤"         "上漲"   "0.31" 
# .....
# [547] "減少"         "1"            "座"           "至"           "459"          "座"
### 以參數形式手動加入 ----
#用函數或者外部資料新增詞彙，兩種方式
# 動態新增自訂詞彙
#  
new_user_word(jieba_tokenizer, c("紐約商業交易所","探勘井","頁岩油","輕值原油"))
# [1] TRUE

segment(chi_text_ptt, jieba_tokenizer)
#  [1] "紐約商業交易所" "NYMEX"          "6"              "月"             "原油期貨"       "5"             
### 以外部檔案形式加入
# 使用使用者自訂字典
jieba_tokenizer <- worker(user="user_dict.txt")
segment(chi_text_ptt, jieba_tokenizer)


# 停用詞使用
# 使用外部檔案作為停用詞參數
jieba_tokenizer <- worker(user="user_dict.txt", stop_word = "stop_words.txt")
segment(chi_text_ptt, jieba_tokenizer)

# 使用自定義Vector作為停用詞參數
# 動態新增停用詞
tokens <- segment(chi_text_ptt, jieba_tokenizer)
tokens
# [535] "459"            "座"  
stop_words <- c("在","的","下","個","來","至","座","亦","與","或","日","月","年","週")
res <- filter_segment(tokens, stop_words)
#filter_segment:如果tokens吻合stop_words就移除
res
# [433] "探勘井"         "數量"           "較前"           "減少"           "1"              "459" 

res <- str_remove_all(res, "[0-9a-zA-Z]+?")
res
# [433] "探勘井"         "數量"           "較前"           "減少"           ""               "" 

# 將詞彙長度為1的詞清除
tokens <- res[nchar(res)>1]
tokens
# [325] "二疊紀"       "盆地"         "石油"          "探勘井"       "數量"          "較前"          
# [331] "減少"

### 2.文字雲(Word Cloud) ----
# 完成了斷詞之後，才是真正的開始，通常第2步驟就是計算詞彙的頻率，通過詞彙的頻率我們就可以直接使用文字雲的套件wordcloud來視覺化文章的重點了！
# 計算詞彙頻率
txt_freq <- freq(tokens)
# 由大到小排列
txt_freq <- arrange(txt_freq, desc(freq))
# 檢查前5名
head(txt_freq)
#     char freq
# 1   美國   16
# 2   數量   14
# 3 探勘井   14
# 4   較前   10
# 5   減少    8
# 6   伊朗    7
# 文字雲套件主要有兩個，wordcloud套件是文字雲的基本款，主要輸出靜態的圖片；wordcloud2顧名思義就是前一個套件的進階版，主要提供互動式的圖片，非常適用在Shiny等網頁中。然而需要注意的是，我認為一般wordcloud的參數比較完整，且兩者參數的命名不盡相同，注意不要混淆了。

par(family=("Microsoft YaHei")) #一般wordcloud需要定義字體，不然會無法顯示中文

# 一般的文字雲 (pkg: wordcloud)
wordcloud(txt_freq$char, txt_freq$freq, min.freq = 2, random.order = F, ordered.colors = F, colors = rainbow(nrow(txt_freq)))

# 互動式文字雲 (pkg: wordcloud2)
wordcloud2(filter(txt_freq, freq > 1), 
           minSize = 2, fontFamily = "Microsoft YaHei", size = 1)

### Gutenberg free eBooks gutenbergr (古騰堡電子書)-----
# gutenbergr 套件是一個可以存取公領域的電子書。進入 古騰堡計畫網站，載入你感興趣的電子書籍，主要可以使用 gutenberg_download() 函數，參數則輸入 id 或者多部的電子書作品。
install.packages('gutenbergr')  
library(gutenbergr)
gutenberg_metadata
# A tibble: 51,997 x 8
# gutenberg_id title      author    gutenberg_author~ language gutenberg_bookshelf  rights  has_text
#    <int> <chr>          <chr>                 <int> <chr>    <chr>                <chr>   <lgl>   
# 1     0  NA             NA                       NA en       NA                   Public~ TRUE    
# 2     1 "The Declarati~ Jefferso~              1638 en       United States Law/A~ Public~ TRUE    
# 3     2 "The United St~ United S~                 1 en       American Revolution~ Public~ TRUE   

gutenberg_metadata %>% filter(title == "Wuthering Heights")
# A tibble: 1 x 8
# gutenberg_id title    author   gutenberg_author~ language gutenberg_bookshelf     rights       has_text
# <int> <chr>     <chr>                 <int> <chr>    <chr>                       <chr>        <lgl>   
#   1          768 Wutherin~ Brontë
gutenberg_download(768)

# 下載 "木蘭奇女傳 by Anonymous" 書籍，並且將text欄位為空的行給清除，以及將重複的語句清除
book23938 <- gutenberg_download(23938)
?gutenberg_download

red <- gutenberg_download(23938) %>% filter(text!="") %>% distinct(gutenberg_id, text)

#### 以下的例子，就從 古騰堡計畫網站 找個四本 H.G. Wells 寫的書做介紹，分別是

# The Time Machine
# The War of the Worlds
# The Invisible Man
# The Island of Doctor Moreau.

### 詞頻 (Word frequencies)
# 首先使用 gutenbergr 套件，並且再用 gutenberg_download() 下載四本電子書
hgwells <- gutenberg_download(c(35, 36, 5230, 159))

three <- gutenberg_download(23950) %>% filter(text!="") %>% distinct(gutenberg_id, text)
West <- gutenberg_download(23962) %>% filter(text!="") %>% distinct(gutenberg_id, text)

### 
library(readr)
X23938_0 <- read_csv("C:/Users/User/Desktop/23938-0.txt",
col_names = FALSE)
View(X23938_0)

names(X23938_0)
# [1] "X1"
dim(X23938_0)
# [1] 3363    1

X23938_0$X1
X23938_0$X1[1]
# [1] "序"
X23938_0$X1[2]
# [1] "嘗思人道之大，莫大於倫常；學問之精，莫精於性命。自有書籍以來，所載傳人不少，"
X23938_0$X1[379]
# [1] "："

red <- X23938_0 %>% filter(X1!="：")
dim(red)
# [1] 3358    1
red <- red %>% filter(X1!="")
dim(red)
red
# A tibble: 3,358 x 1
# X1                                                                          
# <chr>                                                                       
# 1 序                                                                          
# 2 嘗思人道之大，莫大於倫常；學問之精，莫精於性命。自有書籍以來，所載傳人不少，
# 3 求其交盡乎倫常者鮮矣，求其交盡乎性命者益鮮矣。蓋倫常之地，或盡孝而不必兼忠，
# 4 或盡忠而不必兼孝，或盡忠孝而安常處順，不必兼勇烈。遭際未極其變，即倫常未盡其
# 5 難也。性命之理，有不悟性根者，有不知命蒂者，有修性命而旁歧雜出者，有修性命而
# 6 後先倒置者。涵養未得其中，即性命未盡其奧也。乃木蘭一女子耳，擔荷倫常，研求性
# 7 命，而獨無所不盡也哉！   

# 自行載入字典
# jieba_tokenizer <- worker(user="mulan.txt",stop_word = "stop_words.txt")
jieba_tokenizer <- worker()

tokens <- segment(red, jieba_tokenizer)
# Error in segment(red, jieba_tokenizer) : 
#   Argument 'code' must be an string.

# 設定斷詞function
red_tokenizer <- function(t) {
  lapply(t, function(x) {
    tokens <- segment(x, jieba_tokenizer)
    return(tokens)
  })
}

red_tokenizer(red)
# $X1
# [1] "序"       "嘗思人"   "道"       "之"       "大"       "莫"       "大於"     "倫常"    
# [9] "學問"     "之精"     "莫"       "精於"     "性命"     "自有"     "書籍"     "以來"    
# [17] "所載"     "傳人"     "不少"     "求其"     "交盡乎"   "倫常"     "者"       "鮮"      
# [25] "矣"       "求其"     "交盡乎"   "性命"     "者"       "益鮮"     "矣"       "蓋"      
# [33] "倫常之"   "地"       "或"       "盡孝"     "而"       "不必"     "兼忠"     "或"      
# [41] "盡忠"     "而"       "不必"     "兼孝"     "或"       "盡忠"     "孝而"     "安常處順"
# [49] "不必"     "兼勇烈"   "遭際"     "未"       "極其"     "變"       "即"       "倫常"  
# ....
#  [993] "為"       "朋"       "所以"     "對"       "月"       "徘徊"     "臨風"     "嘯傲"   # [ reached getOption("max.print") -- omitted 56467 entries ]

redToken <- red_tokenizer(red)
str(redToken)
# List of 1
# $ X1: chr [1:57467] "序" "嘗思人" "道" "之" ...

redTokenDF <- as.data.frame(redToken)
dim(redTokenDF)
# [1] 57467     1
# redTokenDF02 <- str_remove_all(redTokenDF, "[0-9a-zA-Z]+?")
# dim(redTokenDF02)
# str(redToken02)

redTokenDF03 <- redTokenDF %>% filter(nchar(X1)>1)
dim(redTokenDF03)
# 將詞彙長度為1的詞清除
#　tokens <- res[nchar(res)>1]

# 計算詞彙頻率
txt_freq <- freq(redTokenDF03$X1)
# 由大到小排列
txt_freq <- arrange(txt_freq, desc(freq))
# 檢查前5名
head(txt_freq)
#     char freq
# 1   木蘭  488
# 2   李靖  253
# 3 尉遲恭  189
# 4   元帥  155
# 5    the  141
# 6   天祿  109
par(family=("Microsoft YaHei")) #一般wordcloud需要定義字體，不然會無法顯示中文

# 一般的文字雲 (pkg: wordcloud)
wordcloud(txt_freq$char, txt_freq$freq, min.freq = 2, random.order = F, ordered.colors = F, colors = rainbow(nrow(txt_freq)))

# 互動式文字雲 (pkg: wordcloud2)
wordcloud2(filter(txt_freq, freq > 1), 
           minSize = 2, fontFamily = "Microsoft YaHei", size = 1)
