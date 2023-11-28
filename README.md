# Pipeline Processor
here's the vhdl implementation of pipelined Processor that will compete ⚔️  intel and ARM (also MIPS)
## ISA

### 🤔 Instruction Categories

- NOP
- ALU
    - One Operand
        1. **NOT** Rdst
        2. **NEG** Rdst
        3. **INC** Rdst
        4. **DEC** Rdst
    - Two Operands
        1. **ADD** Rdst, Rsrc1, Rsrc2 
        2. **SUB** Rdst, Rsrc1, Rsrc2
        3. **AND** Rdst, Rsrc1, Rsrc2
        4. **OR** Rdst, Rsrc1, Rsrc2
        5. **XOR** Rdst, Rsrc1, Rsrc2 
        6. **CMP** Rsrc1, Rsrc2 (110)
        7. **SWAP** Rdst, Rsrc  (111)
- Immediate
    1. **ADDI** Rdst, Rsrc1, Imm
    2. **BITSET** Rdst, Imm
    3. **RCL** Rdst, Imm
    4. **RCR** Rdst, Imm
    5. **LDM** Rdst, Imm
- Conditional JMP
    1. **JZ** Rdst
- Unconditional JMP
    1. **JMP** Rdst
    2. **CALL** Rdst
    3. **RET** Rdst
    4. **RTI** Rdst
- DATA Operations
    1. **IN** Rdst 
    2. **OUT** Rdst
    3. **********PUSH********** Rdst
    4. ********POP******** Rdst
    5. **LDD** Rdst, EA
    6. **STD** Rdst, EA
- Memory Security (FREE/PROTECT)
    1. **FREE** Rsrc
    2. **PROTECT** Rsrc
- Input Signals (RESET/INT)
    1. **Reset**
    2. **Interrupt**

### 👀 Instructions Bit in details

#### NOP

|  | opcode  (3) | remain bits |
| --- | --- | --- |
| NOP | 000 | X XXXX XXXX XXXX |

#### ALU

|  | opcode  (3) | Rdst (3) | Rsrc1 (3) | Rsrc2 (3) | One/Two operand (1) | FUNC (3) |
| --- | --- | --- | --- | --- | --- | --- |
| NOT R3 | 001 (ALU) | 011 (R3) | XXX | XXX | 0 (One OP) | 000 |
| NEG R3 | 001 (ALU) | 011 (R3) | XXX | XXX | 0 (One OP) | 001 |
| INC R3 | 001 (ALU) | 011 (R3) | XXX | XXX | 0 (One OP) | 010 |
| DEC R3 | 001 (ALU) | 011 (R3) | XXX | XXX | 0 (One OP) | 011 |

|  | opcode  (3) | Rdst (3) | Rsrc1 (3) | Rsrc2 (3) | One/Two operand (1) | FUNC (3) |
| --- | --- | --- | --- | --- | --- | --- |
| ADD   R3, R1, R2 | 001 (ALU) | 011 (R3) | 001 (R1) | 002 (R2) | 1 (Two OP) | 001 (ADD) |
| SUB    R3, R1, R2 | 001 (ALU) | 011 (R3) | 001 (R1) | 002 (R2) | 1 (Two OP) | 010 (SUB) |
| AND   R3, R1, R2 | 001 (ALU) | 011 (R3) | 001 (R1) | 002 (R2) | 1 (Two OP) | 011 (AND) |
| OR      R3, R1, R2 | 001 (ALU) | 011 (R3) | 001 (R1) | 002 (R2) | 1 (Two OP) | 100 (OR) |
| XOR    R3, R1, R2 | 001 (ALU) | 011 (R3) | 001 (R1) | 002 (R2) | 1 (Two OP) | 101 (XOR) |
| SWAP  R1, R2 | 001 (ALU) | 011 (R1) | 001 (R2) | XXX | 1 (Two OP) | 110 (SWAP) |
| CMP    R1, R2 | 001 (ALU) | 011 (R1) | 001 (R2) | XXX | 1 (Two OP) | 111 (CMP) |

#### Immediate

|  | opcode  (3) | Rdst (3) | Rsrc1 (3) | Rsrc2 (3) | is Load (1) | is Rotate (1) | FUNC (2) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ADD     R3, R1, R2 | 010 (Imm) | 011 (R3) | 001 (R1) | 002 (R2) | 0 (No Load) | 0 (No Rot) | 01 (ADD) |
| BITSET  R3, Imm | 010 (Imm) | 011 (R3) | XXX | XXX | 0 (No Load) | 0 (No Rot) | 10 (BITSET) |
| RCL       R3, Imm | 010 (Imm) | 011 (R3) | XXX | XXX | 0 (No Load) | 1 (Rotate) | X0 (RCL) |
| RCR       R3, Imm | 010 (Imm) | 011 (R3) | XXX | XXX | 0 (No Load) | 1 (Rotate) | X1 (RCR) |
| LDM      R3, Imm | 010 (Imm) | 011 (R3) | XXX | XXX | 1 (Load) | 0 (No Rot) | XX |

#### Conditional Jump

|  | opcode  (3) | Rdst (3) | Rsrc1 (3) | Rsrc2 (3) | Remain |
| --- | --- | --- | --- | --- | --- |
| JZ R3 | 011 (Cond JMP) | 011 (R3) | XXX | XXX | XXXX |

#### Unconditional Jump

|  | opcode  (3) | Rdst (3) | Rsrc1 (3) | Rsrc2 (3) | is JMP (1) | is CALL(1) | is RET (1) | is RTI (1) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| JMP R3 | 100 (Cond JMP) | 011 (R3) | XXX | XXX | 1 | X | X | X |
| CALL R3 | 100 (Cond JMP) | 011 (R3) | XXX | XXX | 0 | 1 | X | X |
| RET R3 | 100 (Cond JMP) | 011 (R3) | XXX | XXX | 0 | 0 | 1 | X |
| RTI R3 | 100 (Cond JMP) | 011 (R3) | XXX | XXX | 0 | 0 | 0 | 1 |

#### Data Operations

|  | opcode  (3) | Rdst (3) | Rsrc1 (3) | Rsrc2 (3) | will input in reg | MEM operation | STACK operation | PORT operation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| LDD   R3, EA | 101 (DATA OP) | 011 (R3) | XXX | XXX | 1 | 1 | X | X |
| STD    R3, EA | 101 (DATA OP) | 011 (R3) | XXX | XXX | 0 | 1 | X | X |
| POP   R3 | 101 (DATA OP) | 011 (R3) | XXX | XXX | 1 | 0 | 1 | X |
| PUSH R3 | 101 (DATA OP) | 011 (R3) | XXX | XXX | 0 | 0 | 1 | X |
| IN      R3 | 101 (DATA OP) | 011 (R3) | XXX | XXX | 1 | 0 | 0 | 1 |
| OUT   R3 | 101 (DATA OP) | 011 (R3) | XXX | XXX | 0 | 0 | 0 | 1 |

#### Memory Security

|  | opcode  (3) | Rdst (3) | Rsrc1 (3) | Rsrc2 (3) | is FREE (1) | FUNC (3)  |
| --- | --- | --- | --- | --- | --- | --- |
| FREE     R3 | 110 (MEM SEC) | 011 (R3) | XXX | XXX | 1 | XXX |
| STORE  R3 | 110 (MEM SEC) | 011 (R3) | XXX | XXX | 0 | XXX |

#### Input Signals

|  | opcode  (3) | Rdst (3) | Rsrc1 (3) | Rsrc2 (3) | is Reset (1) | FUNC (3)  |
| --- | --- | --- | --- | --- | --- | --- |
| RESET | 111 (Input Signal) | XXX | XXX | XXX | 1 | XXX |
| Interrupt | 111 (Input Signal) | XXXX | XXX | XXX | 0 | XXX |