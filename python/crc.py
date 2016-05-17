# -*- coding: utf-8 -*-
import crc16
import binascii

data = "~030199430F000109100001020017210000000000000000000000000000000000000000000422000017290000000000000000000000000000000000000000000A5001000000000000000451040004010500077308000000000405030004060301040F030004A0030004A1030004A2030004A3030004A8030004A9030075E5D9~"
data2 = "030199430F000109100001020017210000000000000000000000000000000000000000000422000017290000000000000000000000000000000000000000000A5001000000000000000451040004010500077308000000000405030004060301040F030004A0030004A1030004A2030004A3030004A8030004A9030075"

tmp = binascii.a2b_hex(data2)
crc = crc16.crc16xmodem(tmp)

print ("0x%04X" %crc)
print (len(tmp))
print (str(tmp))