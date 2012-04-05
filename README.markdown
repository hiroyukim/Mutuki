# Mutuki 

Mutukiは, 家庭内・会社内等で簡易的に動かせるWikiを目指しております。
記法としてはmarkdownを採用。

# 機能

+ Wiki
+ markdown記法
+ 管理画面
+ Groupごとに所属するUserGroup単位で権限を与えられる

# TODO 

+ ストレージを変更可能にしたのでSchemaを適用してインタフェースを統一する
+ 更新履歴一覧画面
+ CSS適用
+ テキスト検索
+ デザインテンプレート
+ 衝突判定
+ バージョン間の差分表示
+ Api対応
+ OAuth

# 将来的な話 

+ ストレージがそれぞれ違っていてもうまく動作するようにしたいけど現状は一部しか対応できてないからそこをうまくやれるやつにする
+ ストレージまたがったTransaction
+ なるべくシンプルに無駄にAjaxとかこらない方針で行きたい
+ Hantena記法も選択できるようにしたほうがいいかもしれない
+ Android
+ iOS

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

yamanaka at fashion-co-lab.jp

# ライセンス

Copyright (C) 2011 HIROYUKI Yamanaka <hiroyukimm 空気読んで gmail 空気読んで com>

Released under the [MIT license](http://creativecommons.org/licenses/MIT/).
