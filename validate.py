from PIL import Image
import sys

orig = Image.open("ORIGINAL.png")
img  = Image.open(sys.argv[1])

if img.size != orig.size:
    print("NOT VALID: image dimensions do not match the original")
    exit()

w, h = img.size

orig = orig.convert("RGB")
img = img.convert("RGB")

orig_pix = orig.load()
img_pix = img.load()

score = 0

for x in range(w):
    for y in range(h):
        orig_r, orig_g, orig_b = orig_pix[x,y]
        img_r, img_g, img_b = img_pix[x,y]
        score += (img_r-orig_r)**2
        score += (img_g-orig_g)**2
        score += (img_b-orig_b)**2

print(score/255.**2)
