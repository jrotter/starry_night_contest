require 'chunky_png'
def r(w,x,y,z,k)
c=k*256+255
$p.rect(w,x,y,z,c,c)
end
$p=ChunkyPNG::Image.new(386,320,255)
r(97,160,192,199,7374989)
r(193,80,289,159,6058130)
r(0,80,48,159,7045519)
r(193,160,289,199,6716303)
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
r(193,200,289,239,3689332)
r(290,200,385,239,4349561)
r(97,80,144,159,6256524)
r(145,80,192,159,5926550)
r(97,0,192,39,4609663)
r(97,40,192,79,5334923)
r(193,280,385,299,3619650)
r(193,300,385,319,3620156)
r(49,80,96,119,5334650)
r(49,120,96,159,2767683)
r(0,200,96,219,3954003)
r(97,200,192,219,5860985)
r(0,160,48,199,5468034)
r(49,160,96,199,2566965)
$p.save('33.png')