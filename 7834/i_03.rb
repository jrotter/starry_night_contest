require 'chunky_png'
def r(w,x,y,z,k)
c=k*256+255
$p.rect(w,x,y,z,c,c)
end
$p=ChunkyPNG::Image.new(386,320,255)
r(0,0,385,159,6252925)
r(0,160,385,239,5398637)
r(0,240,385,319,3095869)
$p.save('03.png')
