import re
from utils import compare_files
class Assembler:
    def __init__(self, code_file, target_file) -> None:
        self.instructions = []
        self.code_file = code_file
        self.target_file = target_file
    def main(self):
        with open(self.code_file) as f:
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

                self.instructions.append(line)
        # writing
        binary_instructions = []
        for instruction in self.instructions:
            binary_instruction = self.assemble(instruction) + "\n"
            binary_instructions.append(binary_instruction)
            if len(binary_instruction) != 17 and len(
                    binary_instruction) != 16 * 2 + 2:  # The second option is for immediate
                print("Test failed: " + instruction + " ::::: " + binary_instruction)

        outputFile = open(self.target_file, "w")
        outputFile.writelines(binary_instructions)
        outputFile.close()



    def getOpcode(self, instruction):
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
            return "000"


    def operand_count(self, parts):
        if len(parts) == 2 or len(parts) == 3:
            return 1
        elif len(parts) == 4:
            return 2
        else:
            print("Invalid Operand Count: " + str(len(parts)))
            print(parts)
            exit()


    def getALUInstruction(self, parts):
        rsrc1 = "XXX"
        rsrc2 = "XXX"
        one_two_operand = "0"
        function = self.alu_func_to_binary(parts[0])
        if parts[0] == "CMP" or parts[0] == "SWAP":
            one_two_operand = "1"
            rsrc1 = self.register_to_binary(parts[2])
        elif self.operand_count(parts) == 2:  # This means that it is 2 operand
            one_two_operand = "1"
            rsrc1 = self.register_to_binary(parts[2])
            rsrc2 = self.register_to_binary(parts[3])
        return rsrc1 + rsrc2 + one_two_operand + function


    def getImmediatenstruction(self, parts):
        rsrc1 = "XXX"
        rsrc2 = "XXX"
        is_load = "0"
        is_rotate = "0"

        if parts[0][0] == 'R':
            is_rotate = "1"

        function = self.immediate_func_to_binary(parts[0])
        if self.operand_count(parts) == 2:  # This means that it is 2 operand
            rsrc1 = self.register_to_binary(parts[2])

        idx = 2
        if parts[0] == "ADDI":
            idx = 3
        immediate_value = self.signed_int_to_binary_16_bits(parts[idx])
        return rsrc1 + rsrc2 + is_load + is_rotate + function + "\n" + immediate_value


    def getUnconditionalJumpInstructions(self, parts):
        return "X" * (16 - 6)


    def getConditionalJumpInstructions(self, parts):
        rsrc1 = "XXX"
        rsrc2 = "XXX"
        is_jmp = "0"
        is_call = "0"
        is_ret = "0"
        is_rti = "0"
        print(parts[0])

        if parts[0] == "JMP":
            is_jmp = "1"
        elif parts[0] == "CALL":
            is_call = "1"
        elif parts[0] == "RET":
            is_ret = "1"
        elif parts[0] == "RTI":
            is_rti = "1"
        return rsrc1 + rsrc2 + is_jmp + is_call + is_ret + is_rti


    def getDataOperationInstruction(self, parts):
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


    def getMemorySecurityInstruction(self, parts):
        is_free = "0"
        if parts[0] == "FREE":
            is_free = "1"
        return "0" * 6 + is_free + "0" * 3


    def getInputSignalInstrucion(self, parts):
        is_reset = "1"
        if parts[0] == "INTERRUPT":
            is_reset = "0"
        return "0" * 6 + is_reset + "0" * 3


    def assemble(self, instruction):
        parts = re.split(r',\s*|\s+', instruction)
        parts = [elem for elem in parts if elem.strip()]
        # 1. Opcode
        output_instruction = ""

        op_code = self.getOpcode(parts[0])
        if op_code is None:
            print("Invalid operation")
            return
        output_instruction += op_code

        # 2. Rdst
        rdst = "XXX"
        if op_code not in ["111", "000"]:
            rdst = self.register_to_binary(parts[1])
        output_instruction += rdst

        # 3. The rest of the instruction depends on the instruction type
        result = ""
        if op_code == "000":  # No operation
            result = "0" * 10
        if op_code == "001":  # ALU instruction
            result = self.getALUInstruction(parts)

        elif op_code == "010":  # Immediate instruction
            result = self.getImmediatenstruction(parts)

        elif op_code == "011":  # Conditional Jump instruction
            result = self.getConditionalJumpInstructions(parts)

        elif op_code == "100":  # Unconditional Jump instruction
            result = self.getConditionalJumpInstructions(parts)

        elif op_code == "101":  # Data Operation instruction
            result = self.getDataOperationInstruction(parts)

        elif op_code == "110":  # Memory Security instruction
            result = self.getMemorySecurityInstruction(parts)

        elif op_code == "111":  # Input Signals instruction
            result = self.getInputSignalInstrucion(parts)
        output_instruction += result
        return output_instruction


    def register_to_binary(self, register):
        # Convert register name to binary representation
        if register[1].isdigit():
            # Convert register name to binary representation
            return format(int(register[1]), '03b')
        else:
            # Handle the case where the second character is not a digit (provide an error message, for example)
            print(f"Error: Second character in register '{register}' is not a number.")
            exit()


    def alu_func_to_binary(self, func):
        # Map ALU function to binary representation
        alu_func_map = {"NOT": "001", "NEG": "010", "INC": "011", "DEC": "100", "ADD": "001", "SUB": "010", "AND": "011",
                        "OR": "100", "XOR": "101", "CMP": "111", "SWAP": "110"}
        return alu_func_map[func]


    def immediate_func_to_binary(self, func):
        # Map immediate function to binary representation
        immediate_func_map = {"ADDI": "01", "BITSET": "10", "RCL": "X0", "RCR": "X1", "LDM": "XX"}
        return immediate_func_map[func]

    def signed_int_to_binary_16_bits(self, number):
    # Ensure the number is within the 16-bit range
        number = int(number)
        number &= 0xFFFF
        binary_representation = format(number, '016b')
        return binary_representation
    def is_value_within_16_bits(self, value, signed=True):
        value = int(value)
        if signed:
            return -32768 <= value <= 32767
        else:
            return 0 <= value <= 65535

    def is_number_type(self, value):
       try:
            int_number = int(value)
            print(f"Converted Integer: {int_number}")
            return True
       except ValueError:
            print(f"Cannot convert '{value}' to an integer.")
            return False

    def immediate_value_to_binary(self, value):
        # Convert immediate value to binary representation
        if not self.is_number_type(value) or not self.is_value_within_16_bits(value):
            print("Invalid Immediate Value " + str(value))
            exit()
        return format(int(value), '016b')

def fix_xxx(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()
    with open(file_path, 'w') as f:
        for line in lines:
            f.write(line.replace('X', '0'))

def easy_reading(instruction_path, output_path):
    with open(instruction_path, 'r') as f:
        lines = f.readlines()
    with open(output_path, 'w') as f:
        # convert binary  to hexadecimal
        for line in lines:
            decimal = int(line, 2)
            hexa = hex(decimal)
            f.write(hexa[2:] + "\n")


if __name__ == "__main__":
    component_path = "E:/3rd/04 Arc/07 Project/Five-Stage-Pipelined-Processor/components/"
    assembler = Assembler(f"{component_path}code.txt", f"{component_path}/instruction.txt")
    assembler.main()
    fix_xxx(f"{component_path}/instruction.txt")
    easy_reading(f"{component_path}/instruction.txt", f"{component_path}/instruction_hex.txt")