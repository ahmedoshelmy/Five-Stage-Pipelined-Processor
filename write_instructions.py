with open('instructions.txt', 'w') as file:
    file.write('0010110000000001\n') # 0x2C01 (NOT R3)
    file.write('0010100000000100\n') # 0x2804 (DEC R2)
    file.write('0010110001011100\n') # 0x2C5C (OR R3, R0, R5)
    for _ in range(4095 - 3):
        file.write('0000000000000000\n')
