map = readline(chomp: true)
# pre-size capacity
files  = Array.new map.size / 2 #$ [Integer, Integer]
spaces = Array.new files.size   #$ [Integer, Integer]

# * Observation: We don’t need to worry about recording (let alone merging)
#   spaces left behind after moving a file because we’ll never move a latter file right.
# * Strategy: Record both files and space sections as begin-size pairs,
#   then move by change the begin of files and both values of spaces.

idx = 0
lists = [files, spaces]
map.each_char.with_index do|size_char, i|
  size = size_char.to_i
  i, list_id = i.divmod 2
  lists.fetch(list_id)[i] = [idx, size]
  idx += size
end

files.reverse_each do|file|
  file_begin, file_size = *file
  if (space = spaces.find do|space_begin, space_size|
    break nil if space_begin >= file_begin
    space_size >= file_size
  end)
    file[0] = space[0]
    space[1] -= file_size
    space[0] += file_size
  end
end

puts files.each_with_index.sum {|(file_begin, file_size), id|
  (2*file_begin + file_size.pred) * file_size / 2 * id # S = (2a + (n-1)d) * n / 2
}
