"""
this totaly by chat gpt have nothing todo with me
"""

def assemble(instruction):
    instruction = instruction.replace(",", "")
    parts = instruction.split()

    if parts[0] == "NOP":
        return "000" + "XXXX" + "XXXX" + "XXXX"

    elif parts[0] in ["NOT", "NEG", "INC", "DEC"]:
        return "001" + "011" + register_to_binary(parts[1]) + "XXX" + "0" + alu_func_to_binary(parts[0])

    elif parts[0] in ["ADD", "SUB", "AND", "OR", "XOR", "CMP", "SWAP"]:
        return "001" + register_to_binary(parts[1]) + register_to_binary(parts[2]) + register_to_binary(parts[3]) + "1" + alu_func_to_binary(parts[0])
    
    elif parts[0] in ["CMP", "SWAP"]:
        return "001" + "011" + register_to_binary(parts[1]) + register_to_binary(parts[2]) + "XXX" + "1" + alu_func_to_binary(parts[0])
    
    elif parts[0] in ["ADDI"]:
        return "010" + "011" + register_to_binary(parts[1]) + register_to_binary(parts[2]) + "XXX" + immediate_func_to_binary(parts[0]) + '\n' + immediate_value_to_binary(parts[3])
    
    elif parts[0] in ["BITSET", "RCL", "RCR", "LDM"]:
        return "010" + "011" + register_to_binary(parts[1]) + "XXX" + "XXX" + immediate_func_to_binary(parts[0]) + '\n' + immediate_value_to_binary(parts[2])

    # Add cases for other instructions...

    else:
        print("Invalid instruction")

def register_to_binary(register):
    # Convert register name to binary representation
    return format(int(register[1]), '03b')

def alu_func_to_binary(func):
    # Map ALU function to binary representation
    alu_func_map = {"NOT": "001", "NEG": "010", "INC": "011", "DEC": "100", "ADD": "001", "SUB": "010", "AND": "011", "OR": "100", "XOR": "101", "CMP": "111", "SWAP": "110"}
    return alu_func_map[func]

def immediate_func_to_binary(func):
    # Map immediate function to binary representation
    immediate_func_map = {"ADDI": "0001", "BITSET": "0010", "RCL": "0100", "RCR": "0101", "LDM": "1000"}
    return immediate_func_map[func]

def immediate_value_to_binary(value):
    # Convert immediate value to binary representation
    if value.isdigit():
        return format(int(value), '016b')
    else:
        return "XXXX"

# Example usage
assembly_instruction = "ADD R3, R2, R1"
binary_instruction = assemble(assembly_instruction)
print(binary_instruction)
