require 'chunky_png'
def r(w,x,y,z,k)
c=k*256+255
$p.rect(w,x,y,z,c,c)
end
$p=ChunkyPNG::Image.new(386,320,255)
r(0,240,385,319,3095869)
r(0,0,192,159,5269120)
r(0,160,385,199,5795964)
r(0,200,385,239,4280421)
r(193,0,289,159,5662097)
r(290,0,385,159,8094858)
$p.save('06.png')
