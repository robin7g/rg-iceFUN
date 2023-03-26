from PIL import Image

# Load the PNG image
img = Image.open("speccy.png")

# Get the image dimensions
width, height = img.size

print("Width = "+str(width))
print("Height = "+str(height))
newsize = (160, 120)
img = img.resize(newsize)

width, height = img.size
print("Width = "+str(width))
print("Height = "+str(height))

# Open the output file for writing
f = open("image.bin", "w")

# Iterate over each pixel in the image and write the color data to the output file
for y in range(height):
    for x in range(width):
        # Get the RGB color values for the current pixel
        color = img.getpixel((x, y))
        #print(color)
        # Extract the color channels and convert them to 6-bit format (2 bits per channel)
        r = (color[0] >> 6) & 0b11
        g = (color[1] >> 6) & 0b11
        b = (color[2] >> 6) & 0b11

        # Combine the color channels into a single 8-bit value and write it to the output file
        value = (r << 4) | (g << 2) | (b << 0)
        f.write("{0:b}\n".format(value))

# Close the output file
f.close()
