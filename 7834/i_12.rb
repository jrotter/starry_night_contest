require 'chunky_png'
def r(w,x,y,z,k)
c=k*256+255
$p.rect(w,x,y,z,c,c)
end
$p=ChunkyPNG::Image.new(386,320,255)
r(193,0,289,159,5662097)
r(0,0,192,79,4675191)
r(0,160,192,199,6122616)
r(193,160,385,199,6517374)
r(0,240,192,319,2566701)
r(193,240,385,319,3948358)
r(0,80,96,159,5335171)
r(97,80,192,159,6387083)
r(290,0,337,159,6390935)
r(338,0,385,159,9213571)
r(0,200,192,239,3755353)
r(193,200,385,239,4214906)
$p.save('12.png')
