# PRのタイトルに[WIP]が含まれていれば編集中コメントをする
warn("編集中...") if github.pr_title.include? "[WIP]"

# 修正内容が200行を超えていたらコメントをする
warn("PRの粒度を細かくしてください :sob: :sob: :sob:") if git.lines_of_code > 200

# PRで修正した範囲だけswiftlintでチェックしてコメントする
github.dismiss_out_of_range_messages
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files inline_mode: true

