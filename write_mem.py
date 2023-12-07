to_binary = lambda x: bin(x)[2:].zfill(16)
hex_binary_32 = lambda x: bin(int(str(x), 16))[2:].zfill(32)

with open('instruction.txt', 'w') as file:
    file.write('0010110000000001\n') # 0x2C01 (NOT R3) => R3 = 0xFFFF_FFCF
    file.write('0010100000000100\n') # 0x2804 (DEC R2) => R2 = 0x0000_001F
    file.write('0010110001011100\n') # 0x2C5C (OR R3, R0, R5) => R3 = 0x0000_0050
    file.write('1010110000001100\n') #0xAC0C (LDD R3, 20) => R3 = 0x0011_0012
    file.write('0000000000010100\n') #0x0014 = 20 //nop 

    file.write('0010110000000001\n') # 0x2C01 (NOT R3) => R3 = 0xFFFF_FFAF
    file.write('0010100000000100\n') # 0x2804 (DEC R2) => R2 = 0x0000_001E
    file.write('1011100000000001\n') # 0xB801 (OUT R6) => out = 0x0011_0012
    file.write('1010110000000001\n') # 0xAC01 (OUT R3) => out = 0xFFFF_FFAF
    file.write('1100100000000000\n') # C800 (PROTECT R2) => MEM(30) => protected
    file.write('0010110000001100\n') # 0x2C0C (OR R3, R0, R0) => R3 = 0x0000_0000


    for _ in range(4095 - 5 - 6):
        file.write('0000000000000000\n')


with open('cache.txt', 'w') as file:
    file.write('0000000000000000\n')
    file.write('0000000000000000\n')
    file.write('0000000000000000\n')
    file.write('0000000000000000\n')
    for i in range(4095 - 4):
        file.write(f'{to_binary(i+1)}\n')


# with open('register.txt', 'w') as file:
#     for i in range(8):
#         file.write(f'{hex_binary_32(i*10)}\n')
#     for i in range(8):
#         file.write(f'{hex_binary_32(i*10)}\n')