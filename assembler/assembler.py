import re

# read code
instructions = []
with open("code.txt") as f:
    for line in f:
        line = line.upper()
        # ignore comments and empty lines
        line = line.replace('\t', '')  # for empty lines
        line = line.strip()  # squezzing the line
        if (len(line) == 0 or line[0] == ';' or line[0] == '#' or line == "\n"):
            continue
        # ignore comments in same line of instruction
        pattern = ";"
        if (re.search(pattern, line)):
            line = line.split(';')[0]
        pattern = "#"
        if (re.search(pattern, line)):
            line = line.split('#')[0]
        # ignore \n if exists
        pattern = "\n"
        if (re.search(pattern, line)):
            line = line.split("\n")[0]

        instructions.append(line)


def getOpcode(instruction):
    alu_instructions = ["NOT", "NEG", "INC", "DEC", "ADD", "SUB", "AND", "OR", "XOR", "CMP", "SWAP"]
    immediate_instructions = ["ADDI", "BITSET", "RCL", "RCR", "LDM"]
    conditional_instructions = ["JZ"]
    unconditional_instructions = ["JMP", "CALL", "RET", "RTI"]
    data_instructions = ["LDD", "STD", "PUSH", "POP", "IN", "OUT"]
    memory_security_instructions = ["FREE", "PROTECT"]
    input_signals_instructions = ["RESET", "INTERRUPT"]

    # Extract the operation from the instruction and convert it to uppercase
    operation = instruction.split()[0].upper()

    if operation in alu_instructions:
        return "001"
    elif operation in immediate_instructions:
        return "010"
    elif operation in conditional_instructions:
        return "011"
    elif operation in unconditional_instructions:
        return "100"
    elif operation in data_instructions:
        return "101"
    elif operation in memory_security_instructions:
        return "110"
    elif operation in input_signals_instructions:
        return "111"
    else:
        return None


def operand_count(parts):
    if len(parts) == 2 or len(parts) == 3:
        return 1
    elif len(parts) == 4:
        return 2
    else:
        print("Invalid Operand Count: " + str(len(parts)))
        print(parts)
        exit()


def getALUInstruction(parts):
    rsrc1 = "XXX"
    rsrc2 = "XXX"
    one_two_operand = "0"
    function = alu_func_to_binary(parts[0])
    if operand_count(parts) == 2:  # This means that it is 2 operand
        one_two_operand = "1"
        rsrc1 = register_to_binary(parts[2])
        rsrc2 = register_to_binary(parts[3])
    return rsrc1 + rsrc2 + one_two_operand + function


def getImmediatenstruction(parts):
    rsrc1 = "XXX"
    rsrc2 = "XXX"
    is_load = "0"
    is_rotate = "0"

    if parts[0][0] == 'R':
        is_rotate = "1"

    function = immediate_func_to_binary(parts[0])
    if operand_count(parts) == 2:  # This means that it is 2 operand
        rsrc1 = register_to_binary(parts[2])

    idx = 2
    if parts[0] == "ADDI":
        idx = 3
    immediate_value = immediate_value_to_binary(parts[idx])
    return rsrc1 + rsrc2 + is_load + is_rotate + function + "\n" + immediate_value


def getUnconditionalJumpInstructions(parts):
    return "X" * (16 - 6)


def getConditionalJumpInstructions(parts):
    rsrc1 = "XXX"
    rsrc2 = "XXX"
    is_jmp = "0"
    is_call = "0"
    is_ret = "0"
    is_rti = "0"

    if parts[0] == "JMP":
        is_jmp = "1"
    elif parts[0] == "CALL":
        is_call = "1"
    elif parts[0] == "RET":
        is_ret = "1"
    elif parts[0] == "RTI":
        is_rti = "1"
    return rsrc1 + rsrc2 + is_jmp + is_call + is_ret + is_rti


def getDataOperationInstruction(parts):
    rsrc1 = "XXX"
    rsrc2 = "XXX"
    will_input_in_reg = "0"
    mem_operation = "0"
    stack_operation = "0"
    port_operation = "0"

    if parts[0] in ["LDD", "POP", "IN"]:
        will_input_in_reg = "1"
    if parts[0] == "LDD" or parts[0] == "STD":
        mem_operation = "1"
    elif parts[0] == "IN" or parts[0] == "OUT":
        port_operation = "1"
    elif parts[0] in ["POP", "PUSH"]:
        stack_operation = "1"

    return rsrc1 + rsrc2 + will_input_in_reg + mem_operation + stack_operation + port_operation


def getMemorySecurityInstruction(parts):
    is_free = "0"
    if parts[0] == "FREE":
        is_free = "1"
    return "0" * 6 + is_free + "0" * 3


def getInputSignalInstrucion(parts):
    is_reset = "0"
    if parts[0] == "INTERRUPT":
        is_free = "1"
    return "0" * 6 + is_reset + "0" * 3


def assemble(instruction):
    parts = re.split(r',\s*|\s+', instruction)
    parts = [elem for elem in parts if elem.strip()]
    # 1. Opcode
    output_instruction = ""

    op_code = getOpcode(parts[0])
    if op_code is None:
        print("Invalid operation")
        return
    output_instruction += op_code

    # 2. Rdst
    rdst = "XXX"
    if op_code != "111":
        rdst = register_to_binary(parts[1])
    output_instruction += rdst

    # 3. The rest of the instruction depends on the instruction type
    result = ""

    if op_code == "001":  # ALU instruction
        result = getALUInstruction(parts)

    elif op_code == "010":  # Immediate instruction
        result = getImmediatenstruction(parts)

    elif op_code == "011":  # Conditional Jump instruction
        result = getConditionalJumpInstructions(parts)

    elif op_code == "100":  # Unconditional Jump instruction
        result = getUnconditionalJumpInstructions(parts)

    elif op_code == "101":  # Data Operation instruction
        result = getDataOperationInstruction(parts)

    elif op_code == "110":  # Memory Security instruction
        result = getMemorySecurityInstruction(parts)

    elif op_code == "111":  # Input Signals instruction
        result = getInputSignalInstrucion(op_code)

    output_instruction += result
    return output_instruction


def register_to_binary(register):
    # Convert register name to binary representation
    if register[1].isdigit():
        # Convert register name to binary representation
        return format(int(register[1]), '03b')
    else:
        # Handle the case where the second character is not a digit (provide an error message, for example)
        print(f"Error: Second character in register '{register}' is not a number.")
        exit()


def alu_func_to_binary(func):
    # Map ALU function to binary representation
    alu_func_map = {"NOT": "001", "NEG": "010", "INC": "011", "DEC": "100", "ADD": "001", "SUB": "010", "AND": "011",
                    "OR": "100", "XOR": "101", "CMP": "111", "SWAP": "110"}
    return alu_func_map[func]


def immediate_func_to_binary(func):
    # Map immediate function to binary representation
    immediate_func_map = {"ADDI": "01", "BITSET": "10", "RCL": "X0", "RCR": "X1", "LDM": "XX"}
    return immediate_func_map[func]


def is_value_within_16_bits(value, signed=True):
    value = int(value)
    if signed:
        return -32768 <= value <= 32767
    else:
        return 0 <= value <= 65535


def immediate_value_to_binary(value):
    # Convert immediate value to binary representation
    if not value.isdigit() or not is_value_within_16_bits(value):
        print("Invalid Immediate Value " + str(value))
        exit()
    return format(int(value), '016b')


binary_instructions = []
for instruction in instructions:
    binary_instruction = assemble(instruction) + "\n"
    binary_instructions.append(binary_instruction)
    if len(binary_instruction) != 17 and len(
            binary_instruction) != 16 * 2 + 2:  # The second option is for immediate
        print("Test failed: " + instruction + " ::::: " + binary_instruction)

outputFile = open("instructions.txt", "w")
outputFile.writelines(binary_instructions)
outputFile.close()
