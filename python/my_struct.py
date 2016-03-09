import struct

values = (1, 'ab', 3)
s = struct.Struct('i 2s i')
packed_date = s.pack(*values)

print(packed_data)
