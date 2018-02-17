#!/bin/bash

createHtmlFile()
{
  local textFile="$1"

  # パターンにマッチした部分を取り除いた値に展開する、パラメータ展開
  # ここでは、後方一致のパターンにパス名展開を使い
  # パターンにマッチした拡張子を取り除いて、展開し、
  # 末尾にhtmlの拡張子を追加し、htmlFile変数へ代入。
  local htmlFile="${textFile%%.*}.html"

  # 空のhtmlDrafts配列を作成
  local htmlDrafts=()
  local htmlTemplate=

  while read -r textLine
  do
    # readコマンドで1行分textFile変数（テキストファイル）から、
    # 文字列を読み取って、
    # その内容をtextLine変数へ代入し、
    # textLine変数を配列の要素として、
    # htmlDrafts配列に追加する。
    htmlDrafts+=("$textLine")
  done < "$textFile"

  # ヒアドキュメントを使いシェルスクリプト本体に
  # 配列の要素を参照したテキスト（HTMLの雛形）を埋め込み、
  # 埋め込んだテキストをcatコマンドの標準入力として利用し、
  # コマンド置き換えを実行して、catコマンドの出力を文字列に展開し
  # htmlTemplate変数へ代入。
  htmlTemplate=$(cat << END
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>${htmlDrafts[0]}</title>
</head>
<body>
  <h1>${htmlDrafts[1]}</h1>
  <p>${htmlDrafts[2]}</p>
</body>
</html>
END
)
  # シェルのリダイレクト機能を使って、
  # ptintfコマンドの標準出力先をhtmlFileへ出力し、
  # HTMLファイルを作成する。
  printf '%s\n' "$htmlTemplate" > "$htmlFile"
}

for i in "$@"
do
  createHtmlFile "$i"
done