module TextUtil
  PREFIX = %w[TiB GiB MiB KiB B].freeze

  def as_size(integer)
    float = integer.to_f
    i = PREFIX.length - 1
    while float > 512 && i.positive?
      i -= 1
      float /= 1024
    end
    number = float > 9 || float.modulo(1) < 0.1 ? '%d' : '%.1f'
    (number % float) + ' ' + PREFIX[i]
  end

  # the margin_width is the spaces between columns (use at least 1)
  def format_table(table, margin_width = 2)
    column_widths = []
    table.each do |row|
      row.each.with_index do |cell, column_num|
        column_widths[column_num] = [column_widths[column_num] || 0, cell.to_s.size].max
      end
    end

    table.collect do |row|
      row.collect.with_index do |cell, column_num|
        cell.to_s.ljust(column_widths[column_num] + margin_width)
      end.join
    end
  end

  # @return length of widest instance of field_name in the array of hashes
  def widest(hash_array, field_name)
    lengths = hash_array.map { |row| row[field_name] }
    lengths.max
  end

  def wrap(str, width = 78)
    str.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
  end
end
