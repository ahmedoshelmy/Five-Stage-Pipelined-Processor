import pytest
from assembler import Assembler
from utils import compare_files
class TestClass:
    def test_alu_one_op(self):
        """ test alu instructions"""
        assembler = Assembler("./test/1/code.txt", "./test/1/instructions.txt")
        assembler.main()
        _, lines_index = compare_files("./test/1/instructions.txt", "./test/1/instructions_expected.txt")
        assert len(lines_index) == 0    
    def test_alu_two_op(self):
        """ test alu instructions"""
        assembler = Assembler("./test/2/code.txt", "./test/2/instructions.txt")
        assembler.main()
        _, lines_index = compare_files("./test/2/instructions.txt", "./test/2/instructions_expected.txt")
        assert len(lines_index) == 0    

    def test_immediate(self):
        """ test immediate instructions"""
        assembler = Assembler("./test/3/code.txt", "./test/3/instructions.txt")
        assembler.main()
        _, lines_index = compare_files("./test/3/instructions.txt", "./test/3/instructions_expected.txt")
        assert len(lines_index) == 0   

    def test_jmp(self):
        """ test jmp instructions"""
        assembler = Assembler("./test/4/code.txt", "./test/4/instructions.txt")
        assembler.main()
        _, lines_index = compare_files("./test/4/instructions.txt", "./test/4/instructions_expected.txt")
        assert len(lines_index) == 0    

    def test_data(self):
        """ test data instructions"""
        assembler = Assembler("./test/5/code.txt", "./test/5/instructions.txt")
        assembler.main()
        _, lines_index = compare_files("./test/5/instructions.txt", "./test/5/instructions_expected.txt")
        assert len(lines_index) == 0  
    def test_mem_inp(self):
        """ test data instructions"""
        assembler = Assembler("./test/6/code.txt", "./test/6/instructions.txt")
        assembler.main()
        _, lines_index = compare_files("./test/6/instructions.txt", "./test/6/instructions_expected.txt")
        assert len(lines_index) == 0    