require 'chunky_png'
def r(w,x,y,z,k)
c=k*256+255
$p.rect(w,x,y,z,c,c)
end
$p=ChunkyPNG::Image.new(386,320,255)
r(97,80,192,159,6387083)
r(193,200,385,239,4214906)
r(97,0,192,79,4809350)
r(193,280,385,319,3947073)
r(0,160,96,199,3952984)
r(97,160,192,199,7374989)
r(193,80,289,159,6058130)
r(0,80,48,159,7045519)
r(49,80,96,159,4018789)
r(193,160,289,199,6716303)
r(0,200,192,219,4808042)
r(0,220,192,239,2700624)
r(338,0,385,79,10001520)
r(338,80,385,159,8622491)
r(0,0,48,79,4938368)
r(49,0,96,79,3691367)
r(193,240,385,259,3756895)
r(193,260,385,279,3094854)
r(290,0,313,159,5400731)
r(314,0,337,159,7966345)
r(290,160,337,199,7570058)
r(338,160,385,199,3883603)
r(193,0,289,39,4674429)
r(193,40,289,79,5268612)
r(0,240,96,319,2566701)
r(97,240,192,319,2041898)
$p.save('26.png')
