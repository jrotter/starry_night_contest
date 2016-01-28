require 'chunky_png'

def color(c)
  ChunkyPNG::Color(c*256+255)
end

$original = ChunkyPNG::Image.from_file('ORIGINAL.png')

# Build some hashes to speed up scoring
$o_r = Hash.new
$o_g = Hash.new
$o_b = Hash.new
for x in (0...386)
  $o_r[x] = Hash.new
  $o_g[x] = Hash.new
  $o_b[x] = Hash.new
end
for x in (0...386)
  for y in (0...320)
    $o_r[x][y] = ChunkyPNG::Color.r($original[x,y])
    $o_g[x][y] = ChunkyPNG::Color.g($original[x,y])
    $o_b[x][y] = ChunkyPNG::Color.b($original[x,y])
  end
end
$new = ChunkyPNG::Image.new(386,320,color(0xFFFFFF00))



class Block

  @@all = []

  def initialize(x0,y0,x1,y1)
    @x0 = x0
    @x1 = x1
    @y0 = y0
    @y1 = y1
    @bestcolor = nil
    @score = nil
    @pixels = (@x1-@x0)*(@y1-@y0)
    @iterations = 10000
    @iterations = 5000 if @pixels > 5000
    @iterations = 500 if @pixels > 50000
    @iterations = 10 if @pixels > 100000

    # Only add first to list, split will handle the rest
    @@all << self if @@all.size == 0 
  end

  def self.all
    @@all
  end

  def self.clear
    @@all = []
  end

  def score
    unless @score
      find_best_score()
      puts "  score of #{@x0},#{@y0},#{@x1},#{@y1} == #{@score} (#{@iterations})\n"
    end
    @score
  end

  def split
    # Split vertically
    bottom = Block.new(@x0,@y0,@x1,@y0+(@y1-@y0)/2)
    top = Block.new(@x0,@y0+(@y1-@y0)/2+1,@x1,@y1)

    # Split horizontally
    left = Block.new(@x0,@y0,@x0+(@x1-@x0)/2,@y1)
    right = Block.new(@x0+(@x1-@x0)/2+1,@y0,@x1,@y1)

    # Remove myself from the global list and add the lower scoring split pair
    @@all.delete(self)
    if bottom.score + top.score > left.score + right.score
      @@all << left
      @@all << right
    else
      @@all << bottom
      @@all << top
    end
  end

  def compute_score(c)
    #puts "Scoring #{c.to_s(16)}\n"
    p = ChunkyPNG::Image.new(386,320,color(c))
    p.rect(@x0,@y0,@x1,@y1,color(c),color(c))
    score = 0.0
    for x in (@x0..@x1)
      for y in (@y0..@y1)
        score += (ChunkyPNG::Color.r(p[x,y]) - $o_r[x][y])**2
        score += (ChunkyPNG::Color.g(p[x,y]) - $o_g[x][y])**2
        score += (ChunkyPNG::Color.b(p[x,y]) - $o_b[x][y])**2
      end
    end
    retval = score.to_f / (255.0**2)
    #puts "score == #{retval}\n"
    return retval
  end

  def find_best_score
    @score = 1000000.0
    for i in (0...@iterations)
      r = rand(16777216) # 2**24
      s = compute_score(r)
      if s < @score
        @bestcolor = r
        @score = s
        #puts "New best score #{s} from color #{r.to_s(16)}\n"
      end
    end
  end

  def get_printline
    #"x=#{@bestcolor};p.rect(#{@x0},#{@y0},#{@x1},#{@y1},c(x),c(x))"
    "r(#{@x0},#{@y0},#{@x1},#{@y1},#{@bestcolor})"
  end

  def print(p)
    p.rect(@x0,@y0,@x1,@y1,color(@bestcolor),color(@bestcolor))
    puts get_printline
  end
end

def full_score
  sum = 0.0
  Block::all.each do |b|
    sum += b.score
  end
  sum
end

def highest_scoring_block
  max_block = Block::all.first
  Block::all.each do |b|
    max_block = b if b.score > max_block.score
  end
  max_block
end

def save(filename)
  p = ChunkyPNG::Image.new(386,320,color(0xFFFFFF00))
  Block::all.each do |b|
    b.print(p)
  end
  p.save(filename)
end

def generate_ruby_text()
  outtext = ''
  outtext << "require 'chunky_png'\n"
  outtext << "def r(w,x,y,z,k)\n"
  outtext << "c=k*256+255\n"
  outtext << "$p.rect(w,x,y,z,c,c)\n"
  outtext << "end\n"
  outtext << "$p=ChunkyPNG::Image.new(386,320,255)\n"
  Block::all.each do |b|
    outtext << b.get_printline
    outtext << "\n"
  end
  outtext << "$p.save('o.png')\n"
  outtext
end

def generate_ruby(filename,ruby_text)
  outfile = File.open("#{filename}.rb","w")
  outfile << ruby_text
  outfile.close
end

####################################################################
# Build a 1024 byte ruby executable 
####################################################################

Block::clear
r = Block.new(0,0,385,319)
r.find_best_score()
puts "Blocks = 1, Score = #{full_score()}\n"
newtext = generate_ruby_text()
rubytext = ''
old_score = 1000000.0

i = 2
while newtext.size <= 1024
  highest_scoring_block.split
  puts "Blocks = #{i}, Score = #{full_score()}\n"
  filename = "i_#{i.to_s.rjust(2,"0")}"
  newtext = generate_ruby_text()
  if newtext.size > 1024
    puts "*****************************************************************\n"
    puts "* COMPLETE: Steps = #{i-1}, Score = #{old_score}\n"
    puts "*****************************************************************\n"
  else
    generate_ruby(filename,rubytext)
  end
  rubytext = newtext
  old_score = full_score()
  i += 1
end

