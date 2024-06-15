.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m0_rows: .word 3
m0_cols: .word 3
m1: .word 1 2 3 4 5 6 7 8 9
m1_rows: .word 3
m1_cols: .word 3
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0 m0
    la s3 m1
    mv a0, s0
    mv a3, s3

    # Set dimensions of m0
    la s1, m0_rows
    lw s1, 0(s1)
    la s2, m0_cols
    lw s2, 0(s2)

    mv a1, s1
    mv a2, s2
    
    # Set dimensions of m1
    la s4, m1_rows
    lw s4, 0(s4)
    la s5, m1_cols
    lw s5, 0(s5)

    mv a4, s4
    mv a5, s5
    
    # Set output
    la s6, d
    mv a6, s6

    # Call matrix multiply, m0 * m1
    call matmul

    # Print the output (use print_int_array in utils.s)
    mv a0, a6
    la a1, m0_rows
    lw a1, 0(a1)
    la a2, m1_cols
    lw a2, 0(a2)
    jal ra print_int_array

    # Exit the program
    jal exit