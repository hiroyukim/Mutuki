# Mutuki 

Mutukiは, 家庭内・会社内等で簡易的に動かせるWikiを目指しております。
記法としてはmarkdownを採用。

# TODO 

+ グループ内のWiki一覧
+ 更新履歴一覧画面
+ Admin画面
+ 編集者の概念が欠落してるからたさないとまずい
+ CSS適用
+ 認証機能
+ テキスト検索
+ デザインテンプレート
+ 衝突判定

# 展開 

+ なるべくシンプルに無駄にAjaxとかこらない方針で行きたい
+ Hantena記法も選択できるようにしたほうがいいかもしれない
+ この規模でModelを持つべきかどうか悩む

# 使用方法 

    git clone git://github.com/hiroyukim/Mutuki.git
    cd Mutuki
    cat sql/mysql.sql | mysql -uroot -p
    plackup 

# 参照

## Markdown

+ http://daringfireball.net/projects/markdown/syntax
+ http://blog.2310.net/archives/6

# Author

twitter @hiroyukim
