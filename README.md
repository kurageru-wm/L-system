
# L-system
Gauche用L-systemライブラリ

## 使い方
### ルールの定義
    (define-rule a->ab 'a '(a b))
    (define-rule b->a 'b '(b))

### 作成
    (define test (make <G> :init '(a b) :rules `(,a->ab b->a)))

### ルールの適用
    (step test 2)
    
### シンボルのリストに変換
    (v-list->list (step test 2))
内部ではシンボルを<V-symbol>のインスタンスに変換しているため，結果を表示するためには変換が必要．

### シンボルを任意のオブジェクトへ変換
    (convert (step test 2)
               `(a . ,(lambda (x) '(forward 10))
               `(b . ,(lambda (x) '(turn 90)))
               ))
タートルグラフィックス等で使うために変換を行う．

+ 変換するシンボルとオブジェクトを生成する手続きをペアで指定する．
+ オブジェクトを生成する手続きは<V-symbol>のインスタンスを受け取る．

### `<V-symbol`>
シンボルをラップするクラス．
以下のスロットを持つ．

+ symbol
+ n

sample.scm参照．
