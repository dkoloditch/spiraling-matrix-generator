@matrix = []
puts "Enter a number: "
number = gets.chomp.to_i

def base_row_finished?
  @matrix.size == 1 && @matrix.first.size == 2
end

def set_current_direction
  # p "all_row_sizes_are_equal: #{all_row_sizes_are_equal?}; #{@matrix.collect{|row| row.size}}"
  if @matrix.empty? || (@matrix.size < 2 && @matrix.first.size < 2)
    # initial row
    @current_direction = "right"
  elsif base_row_finished?
    @current_direction = "left"
  elsif @current_direction == "right" && (@matrix[0].size > @matrix[1].size)
    @current_direction = "down"
  elsif @current_direction == "left" && (@matrix.last.size > @matrix[-2].size)
    @current_direction = "up"
  elsif @current_direction == "up" && (@matrix.first.size == 1)
    @current_direction = "right"
  elsif @current_direction == "down" && (@matrix.last.size == 1)
    @current_direction = "left"
  end
end

def all_row_sizes_are_equal?
  @matrix.collect{|row| row.size}.uniq.size <= 1
end

def create_row_if_needed
  if @matrix.empty?
    # @prime_row can always be identified by .object_id
    @matrix << []
    @prime_row = @matrix.first
  elsif @matrix.size == 1 && @matrix.first.size == 2
    @matrix.push([])
  elsif @current_direction == "up" && all_row_sizes_are_equal?
    @matrix.unshift([])
  elsif @current_direction == "down" && all_row_sizes_are_equal?
    @matrix.push([])
  end
end

(number + 1).times do |n|
  set_current_direction
  create_row_if_needed
  p ""
  p ""
  p @current_direction
  p @matrix
  p ""
  p ""

  if @current_direction == "right"
    @matrix.first.push(n)
  elsif @current_direction == "left"
    @matrix.last.unshift(n)
  elsif @current_direction == "up"
    # add the number to array after the one that contains the previous number
    previous_row_idx = @matrix.reverse.map.with_index{|row, idx| idx if row.include?(n-1)}.compact.first
    @matrix.reverse[previous_row_idx + 1].unshift(n)
  elsif @current_direction == "down"
    # add the number to array after the one that contains the previous number
    previous_row_idx = @matrix.map.with_index{|row, idx| idx if row.include?(n-1)}.compact.first
    @matrix[previous_row_idx + 1].push(n)
  end
end


p "*" * 20
p "*" * 20
p "*" * 20
p "*" * 20
p "*" * 20
@matrix.each{|row| p row.join('  ')}
