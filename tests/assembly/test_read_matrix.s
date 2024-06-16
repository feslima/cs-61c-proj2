.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    addi sp, sp, -8
    addi a2, sp, 4 # address of the number of columns
    addi a1, sp, 0 # address of the number of rows
    
    la a0, file_path
    jal read_matrix

    # Print out elements of matrix
    lw a1, 0(a1)
    lw a2, 0(a2)
    jal ra print_int_array

    # Terminate the program
    jal exit