idx = checksum = 0
# Array of exclude-end? ranges
files = readline(chomp: true).each_char.each_slice(2).map do|size_pair|
  file_size, space_size = size_pair.map &:to_i #: [Integer, Integer]
  file_range = idx...(idx + file_size)
  idx = file_range.end + space_size
  file_range
end

# * Algorithm: substitute space sections with file blocks taken from the right side of the map
# * Optimization: the strategy is so straightforward, the simulation can nest in the checksumming.
idx = 0
files.each_with_index do|file, id|
  until (space_size = file.begin - idx).zero?
    rightmost_id = files.size.pred
    rightmost_file = files.fetch rightmost_id
    file_size = rightmost_file.size #: Integer
    
    # Edge case: currently filling the space before the last section with the last blocks
    if rightmost_id <= id
      file = idx...(idx + file_size)
      break
    end
    
    idx2 = if space_size < file_size # fill whole space with part of file
      files[rightmost_id] = rightmost_file.begin...(rightmost_file.end - space_size)
      file.begin
    else # fill part or all of space with whole file
      files.pop # Allows the array to be modified during iteration: ⸺ {Array#each}
      idx + file_size
    end
    
    checksum += (idx...idx2).sum * rightmost_id # use Arithmetic Sum formula from `Range[Integer]`
    idx = idx2
  end
  
  # File
  checksum += file.sum * id
  idx = file.end
end
puts checksum
