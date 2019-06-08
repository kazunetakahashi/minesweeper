#
# File    : minesweeper.rb
# Author  : Kazune Takahashi
# Created : 2019-6-8 21:02:54
# Powered by Visual Studio Code
#

class MineSweeper

  attr_accessor :h, :w, :n, :board, :frag, :visible, :cnt

  def initialize(h, w, n)
    @h = h.to_i
    @w = w.to_i
    @n = n.to_i
    if n >= h * w
      return false
    end
    @board = Array.new(@h){Array.new(@w){0}}
    tmp = Array.new(@h * @w){false}
    for i in 0...@n
      tmp[i] = true
    end
    tmp.shuffle!
    for i in 0...@h
      for j in 0...@w
        if tmp[i * @w + j]
          @board[i][j] = -1
          for a in 0..2
            for b in 0..2
              c = a - 1
              d = b - 1
              x = i + c
              y = j + d
              if 0 <= x && x < @h && 0 <= y && y < @w && @board[x][y] >= 0
                @board[x][y] += 1
              end
            end
          end
        end
      end
    end
    @frag = Array.new(@h){Array.new(@w){false}}
    @visible = Array.new(@h){Array.new(@w){false}}
    @cnt = 0
    return true
  end

  def put_frag(x, y)
    if !(0 <= x && x < @h && 0 <= y && y < @w)
      return nil
    end
    @frag[x][y] = !@frag[x][y]
  end


  def click(x, y)
    if !(0 <= x && x < @h && 0 <= y && y < @w)
      return nil
    end
    if visible[x][y]
      return nil
    end
    if @board[x][y] == -1
      return false
    end
    disclose(x, y)
    return true
  end

  def clear?
    return (@cnt == @h * @w - @n)
  end

  def show
    for i in 0...@h
      str = ""
      for j in 0...@w
        if !@visible[i][j]
          if @frag[i][j]
            str += "!"
          else
            str += "."
          end
        else
          str += @board[i][j].to_s
        end
      end
      puts str
    end
  end

  private

  def disclose(x, y)
    @visible[x][y] = true
    @cnt += 1
    if @board[x][y] == 0
      for a in 0..2
        for b in 0..2
          c = a - 1
          d = b - 1
          nx = x + c
          ny = y + d
          if 0 <= nx && nx < @h && 0 <= ny && ny < @w && !@visible[nx][ny]
            disclose(nx, ny)
          end
        end
      end
    end
  end

end

puts "縦、横、ます目を入力してください。"
h, w, n = gets.chomp.split(" ").map{|i| i.to_i}

@ms = MineSweeper.new(h, w, n)

while true
  @ms.show
  if @ms.clear?
    break
  end
  puts "入力してください click x y; frag x y"
  str = gets.chomp.split(" ")
  if str[0] == "click"
    res = @ms.click(str[1].to_i, str[2].to_i)
    if res.nil?
      next
    elsif res
      next
    else
      puts "failed!"
      exit
    end
  elsif str[0] == "frag"
    @ms.put_frag(str[1].to_i, str[2].to_i)
  end
end

puts "clear!"