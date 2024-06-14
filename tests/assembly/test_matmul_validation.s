.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # load dimensions from argv
    mv s0, a1 # a1 = &argv
    addi s0, s0, 4
    lw a1, 0(s0) # rows of m0 in string
    jal atoi
    mv s1, a0

    addi s0, s0, 4
    lw a1, 0(s0) # columns of m0 in string
    jal atoi
    mv s2, a0

    addi s0, s0, 4
    lw a1, 0(s0) # rows of m1 in string
    jal atoi
    mv s4, a0

    addi s0, s0, 4
    lw a1, 0(s0) # columns of m1 in string
    jal atoi
    mv s5, a0

    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0 m0
    la s3 m1

    # Set output
    la s6, d
    lw s6, 0(s6)
    
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv a4, s4
    mv a5, s5
    mv a6, s6

    # Call matrix multiply, m0 * m1
    call matmul

    # Print the output (use print_int_array in utils.s)
    mv a0, a6
    mv a1, s1
    mv a2, s2
    jal print_int

    # Exit the program
    jal exit