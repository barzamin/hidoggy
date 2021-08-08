import re
import math
from collections import Counter

with open('woof.txt') as f:
	woof = f.read()

c = Counter(woof)
print(c)
woof = re.sub(r'[^\s]', '.', woof)
# woof = re.sub(r'[xdcolk]', '@', woof)
# woof = re.sub(r'[\',;:]',  '.', woof)
print(woof)

tape = []
for char in woof:
	try:
		if tape[-1][0] == char:
			tape[-1] = (tape[-1][0], tape[-1][1] + 1)
		else:
			tape.append((char, 1))
	except IndexError:
		tape.append((char, 1))

print(tape)

# print(max(tape, key=lambda x: x[1]))
# print(math.log2(max(tape, key=lambda x: x[1])[1])) # 5.672425341971495; 6 bits

packed_tape = bytearray()
for char, n in tape:
    if char == '\n':
        continue
    x = 0
    x |= (n & 0b111111)

    if char == '.':
        x |= 0b1 << 6

    packed_tape.append(x)

print(packed_tape)
print(f'{len(packed_tape)} bytes of RLE')

with open('rle.dat', 'wb') as f:
    f.write(packed_tape)