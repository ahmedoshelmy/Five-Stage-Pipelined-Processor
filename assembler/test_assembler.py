import pytest
from assembler import Assembler
from utils import compare_files
class TestClass:
    def test_one(self):
        assembler = Assembler("./test/1/code.txt", "./test/1/instructions.txt")
        assembler.main()
        _, lines_index = compare_files("./test/1/instructions.txt", "./test/1/instructions_expected.txt")
        assert len(lines_index) == 0    
    def test_two(self):
        assembler = Assembler("./test/2/code.txt", "./test/2/instructions.txt")
        assembler.main()
        _, lines_index = compare_files("./test/2/instructions.txt", "./test/2/instructions_expected.txt")
        assert len(lines_index) == 0    