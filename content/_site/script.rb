#!/usr/bin/env ruby
# frozen_string_literal: true

# Usage:
#   ruby backfill_date_and_categories.rb /path/to/content [--dry-run]
#
# Examples:
#   ruby backfill_date_and_categories.rb ./content
#   ruby backfill_date_and_categories.rb ./content --dry-run
#
# What it does:
# - Scans all *.md under the given directory.
# - Extracts a date from patterns like: [June 22, 2015](...)
# - Extracts categories from patterns like: [News](category/news/)
#   (supports multiple categories; slug is titleized → "news-updates" => "News Updates")
# - Adds front-matter keys if missing:
#       date: "YYYY-MM-DD"
#       categories: ["News", ...]
#
# Notes:
# - Existing front-matter values are left untouched.
# - If no date is found, it falls back to file mtime (optional: set USE_MTIME_FALLBACK = true).
# - Dry run prints intended changes without writing files.

require 'yaml'
require 'date'
require 'pathname'

ROOT = Pathname.new(ARGV[0] || '.').expand_path
DRY  = ARGV.include?('--dry-run')

abort "Directory not found: #{ROOT}" unless ROOT.directory?

# If true, when no date matched in content, use file mtime as fallback.
USE_MTIME_FALLBACK = true

MD_GLOB = '**/*.md'

MONTHS = %w[
  January February March April May June July August September October November December
]

# Regex:
# [June 22, 2015](...)
DATE_RE = /
  \[
    \s*(#{MONTHS.join('|')})\s+\d{1,2},\s+\d{4}
  \]
  \(
/x

# Extract the exact "Month D, YYYY" inside [...] (before the following paren)
DATE_TEXT_RE = /
  \[
    \s*(?<date>(?:#{MONTHS.join('|')})\s+\d{1,2},\s+\d{4})
  \]
  \(
/x

# Categories like:
# [News](category/news/)
# [School-Events](category/school-events/)
CATEGORY_RE = /\[[^\]]+\]\((?:\.?\/)?category\/([^)\/]+)\/?\)/i

def titleize_slug(slug)
  slug.to_s
      .strip
      .gsub(/[-_]+/, ' ')
      .split(/\s+/)
      .map { |w| w[0] ? w[0].upcase + w[1..] : w }
      .join(' ')
end

def extract_date_from_body(body)
  if (m = body.match(DATE_TEXT_RE))
    str = m[:date]
    begin
      return Date.parse(str)
    rescue ArgumentError
      return nil
    end
  end
  nil
end

def extract_categories_from_body(body)
  slugs = body.scan(CATEGORY_RE).flatten.uniq
  slugs.map { |s| titleize_slug(s) }
end

def parse_front_matter_and_body(text)
  lines = text.lines
  return [{}, text] unless lines.first&.strip == '---'
  fm_end = lines[1..].index { |l| l.strip == '---' }
  return [{}, text] unless fm_end # malformed; treat as no front matter
  fm_yaml = lines[1..fm_end].join
  body    = lines[(fm_end + 2)..]&.join || ""
  begin
    fm_hash = YAML.safe_load(fm_yaml, permitted_classes: [Date, Time], aliases: true) || {}
  rescue Psych::SyntaxError
    fm_hash = {}
  end
  [fm_hash, body]
end

def build_front_matter(hash)
  # Keep a stable key ordering: common keys first
  order = %w[title layout date categories tags source_path extracted_mode author]
  ordered = hash.keys.sort_by { |k| order.index(k.to_s) || (order.size + 1) }
  yaml = ordered.each_with_object({}) { |k, memo| memo[k] = hash[k] }.to_yaml
  "---\n#{yaml.strip}\n---\n"
end

changed = 0
skipped = 0
processed = 0

Dir.chdir(ROOT) do
  Dir.glob(MD_GLOB).sort.each do |rel|
    path = Pathname.new(rel)
    text = path.read

    fm, body = parse_front_matter_and_body(text)
    orig_fm = fm.dup

    # Extract date/categories from body
    date = extract_date_from_body(body)
    cats = extract_categories_from_body(body)

    # Write date if missing
    if fm['date'].nil? && (date || (USE_MTIME_FALLBACK && date.nil?))
      date ||= path.mtime.to_date
      fm['date'] = date.iso8601
    end

    # Write categories if missing AND we found any
    if (fm['categories'].nil? || fm['categories'] == [] || fm['categories'].to_s.strip.empty?) && !cats.empty?
      fm['categories'] = cats
    end

    if fm == orig_fm
      skipped += 1
      next
    end

    new_text = build_front_matter(fm) + body

    if DRY
      puts "[DRY] Would update: #{rel}"
      puts "     + date: #{fm['date']}" if orig_fm['date'].nil? && fm['date']
      if (orig_fm['categories'].nil? || orig_fm['categories'] == [] || orig_fm['categories'].to_s.strip.empty?) && fm['categories']
        puts "     + categories: #{fm['categories'].inspect}"
      end
    else
      path.write(new_text)
      puts "Updated: #{rel}"
      changed += 1
    end

    processed += 1
  end
end

puts "\nDone."
puts "  Processed: #{processed}"
puts "  Changed  : #{changed}" unless DRY
puts "  Skipped  : #{skipped}"
puts "  Mode     : #{DRY ? 'DRY RUN (no files written)' : 'WRITE'}"


