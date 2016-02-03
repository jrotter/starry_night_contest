require 'chunky_png'
def r(w,x,y,z,k)
c=k*256+255
$p.rect(w,x,y,z,c,c)
end
$p=ChunkyPNG::Image.new(386,320,255)
r(0,160,385,239,5398637)
r(0,240,385,319,3095869)
r(0,0,192,159,5269120)
r(193,0,385,159,7370894)
$p.save('04.png')
