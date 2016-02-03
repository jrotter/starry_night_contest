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
for y in (0...320) 
  for x in (0...386)
    $o_r[x][y] = ChunkyPNG::Color.r($original[x,y])
    $o_g[x][y] = ChunkyPNG::Color.g($original[x,y])
    $o_b[x][y] = ChunkyPNG::Color.b($original[x,y])
  end
end
$new = ChunkyPNG::Image.new(386,320,color(0xFFFFFF00))



class Block

  @@all = []

  def initialize(x0,y0,x1,y1,parentcolor)
    @x0 = x0
    @x1 = x1
    @y0 = y0
    @y1 = y1
    @parentcolor = parentcolor
    @bestcolor = nil
    @score = nil
    @pixels = (@x1-@x0)*(@y1-@y0)
    @iterations = 15000
    @iterations = 10000 if @pixels > 5000
    @iterations = 5000 if @pixels > 50000
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
    bottom = Block.new(@x0,@y0,@x1,@y0+(@y1-@y0)/2,@bestcolor)
    top = Block.new(@x0,@y0+(@y1-@y0)/2+1,@x1,@y1,@bestcolor)

    # Split horizontally
    left = Block.new(@x0,@y0,@x0+(@x1-@x0)/2,@y1,@bestcolor)
    right = Block.new(@x0+(@x1-@x0)/2+1,@y0,@x1,@y1,@bestcolor)

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
    for y in (@y0..@y1)
      for x in (@x0..@x1)
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
    r = @parentcolor
    for i in (0...@iterations)
      s = compute_score(r)
      if s < @score
        @bestcolor = r
        @score = s
        #puts "New best score #{s} from color #{r.to_s(16)}\n"
      end
      r = rand(16777216) # 2**24
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
Block.new(97,160,192,199,7374989)
a = Block.new(0,80,48,159,7045519)
a.score
Block::all << a
a = Block.new(193,160,289,199,6716303)
a.score
Block::all << a
a = Block.new(0,220,192,239,2700624)
a.score
Block::all << a
a = Block.new(338,0,385,79,10001520)
a.score
Block::all << a
a = Block.new(338,80,385,159,8622491)
a.score
Block::all << a
a = Block.new(0,0,48,79,4938368)
a.score
Block::all << a
a = Block.new(49,0,96,79,3691367)
a.score
Block::all << a
a = Block.new(193,240,385,259,3756895)
a.score
Block::all << a
a = Block.new(193,260,385,279,3094854)
a.score
Block::all << a
a = Block.new(290,0,313,159,5400731)
a.score
Block::all << a
a = Block.new(314,0,337,159,7966345)
a.score
Block::all << a
a = Block.new(290,160,337,199,7570058)
a.score
Block::all << a
a = Block.new(338,160,385,199,3883603)
a.score
Block::all << a
a = Block.new(193,0,289,39,4674429)
a.score
Block::all << a
a = Block.new(193,40,289,79,5268612)
a.score
Block::all << a
a = Block.new(0,240,96,319,2566701)
a.score
Block::all << a
a = Block.new(97,240,192,319,2041898)
a.score
Block::all << a
a = Block.new(193,200,289,239,3689332)
a.score
Block::all << a
a = Block.new(290,200,385,239,4349561)
a.score
Block::all << a
a = Block.new(97,80,144,159,6256524)
a.score
Block::all << a
a = Block.new(145,80,192,159,5926550)
a.score
Block::all << a
a = Block.new(97,0,192,39,4609663)
a.score
Block::all << a
a = Block.new(97,40,192,79,5334923)
a.score
Block::all << a
a = Block.new(193,280,385,299,3619650)
a.score
Block::all << a
a = Block.new(193,300,385,319,3620156)
a.score
Block::all << a
a = Block.new(49,80,96,119,5334650)
a.score
Block::all << a
a = Block.new(49,120,96,159,2767683)
a.score
Block::all << a
a = Block.new(0,200,96,219,3954003)
a.score
Block::all << a
a = Block.new(97,200,192,219,5860985)
a.score
Block::all << a
a = Block.new(0,160,48,199,5468034)
a.score
Block::all << a
a = Block.new(49,160,96,199,2566965)
a.score
Block::all << a
a = Block.new(193,80,289,119,5599124)
a.score
Block::all << a
a = Block.new(193,120,289,159,6058130)
a.score
Block::all << a
i = 34
puts "Blocks = 34, Score = #{full_score()}\n"
old_score = full_score
rubytext = ''
newtext = ''
i += 1

highest_scoring_block.split
puts "Blocks = #{i}, Score = #{full_score()}\n"
filename = "j_#{(i).to_s.rjust(2,"0")}"
rubytext = generate_ruby_text()
generate_ruby(filename,rubytext)
rubytext = newtext
old_score = full_score()

