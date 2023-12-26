to_binary = lambda x: bin(x)[2:].zfill(16)
hex_binary_32 = lambda x: bin(int(str(x), 16))[2:].zfill(32)

with open('instruction.txt', 'w') as file:
    file.write('1010110000001001\n') # 0xAC09 (IN R3) => R3 = inport

    for _ in range(4095 - 1):
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