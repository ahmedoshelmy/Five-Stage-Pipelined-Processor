with open('instructions.txt', 'w') as file:
    file.write('001011000000000001\n')
    file.write('001010000000000100\n')
    for _ in range(4095 - 2):
        file.write('000000000000000000\n')
