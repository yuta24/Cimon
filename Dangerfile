github.dismiss_out_of_range_messages

# lint
swiftlint.lint_all_files = true
swiftlint.lint_files inline_mode: true

def check_diff_size(diff, size)
  target_diffs = diff.select { |chunk| chunk.path.match(/.*\.(swift)$/) }
  total_count = target_diffs.reduce(0) do |total, chunk|
    added_lines = chunk.patch.lines.grep(/^\+/)
    deleted_lines = chunk.patch.lines.grep(/^-/)

    total + (added_lines.count - 1) + (deleted_lines.count - 1)
  end

  total_count > size
end

warn("1000行以上のコードが変更されています。PRを分割しましょう。") if check_diff_size(git.diff, 1000)

# Report
xcode_summary.ignores_warnings = true
xcode_summary.ignored_files = 'Pods/**'
xcode_summary.inline_mode = true
xcode_summary.report "./build/reports/errors.json"
