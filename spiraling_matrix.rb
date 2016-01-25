def get_number_from_user
  puts "Enter a positive number: "
  @user_provided_number = gets.chomp.to_i
end

def generate_matrix
  @matrix = []
  while @user_provided_number.nil? || @user_provided_number < 0
    get_number_from_user
  end

  (0..@user_provided_number).each do |num|
    set_current_direction
    create_row_if_needed
    add_value_to_matrix(num)
  end
end

def add_value_to_matrix(num)
  case @current_direction
  when "right"
    @matrix.first.push(num)
  when "left"
    @matrix.last.unshift(num)
  when "up"
    # add number to array after the array that contains the previous number
    previous_row_idx = @matrix.reverse.map.with_index do |row, idx|
      idx if row.include?(num-1)
    end
    target_row_index = previous_row_idx.compact.first + 1
    @matrix.reverse[target_row_index].unshift(num)
  when "down"
    # add number to array after the array that contains the previous number
    previous_row_idx = @matrix.map.with_index do |row, idx|
      idx if row.include?(num-1)
    end
    target_row_index = previous_row_idx.compact.first + 1
    @matrix[target_row_index].push(num)
  end
end

def set_current_direction
  if @matrix.empty? || (@matrix.size < 2 && @matrix.first.size < 2)
    # initial row
    @current_direction = "right"
  elsif initial_row_full?
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

def create_row_if_needed
  if @matrix.empty?
    @matrix << []
  elsif @matrix.size == 1 && @matrix.first.size == 2
    @matrix.push([])
  elsif @current_direction == "up" && all_rows_are_the_same_size?
    @matrix.unshift([])
  elsif @current_direction == "down" && all_rows_are_the_same_size?
    @matrix.push([])
  end
end

def initial_row_full?
  @matrix.size == 1 && @matrix.first.size == 2
end

def all_rows_are_the_same_size?
  @matrix.collect{|row| row.size}.uniq.size <= 1
end

def add_padding_if_necessary
  # bottom side
  if @matrix.last.size != @matrix[-2].size
    difference = @matrix[-2].size - @matrix.last.size
    difference.times{|count| @matrix.last.unshift(nil)}
  end

  # left side
  if @matrix.last.size > @matrix[1].size
    @matrix.each{|row| row.unshift(nil) if row.size < @matrix.last.size}
  end
end

def output_results
  add_padding_if_necessary

  results = @matrix.map do |row|
    row.collect do |n|
      spaces = " " * ((@user_provided_number.to_s.size - n.to_s.size))
      n.to_s + spaces
    end
  end

  puts nil
  results.each{|row| puts row.join(' ')}
end


generate_matrix
output_results
