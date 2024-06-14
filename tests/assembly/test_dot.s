.import ../../src/dot.s
.import ../../src/utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9
l_vector: .word 9
s_vector0: .word 1
s_vector1: .word 1

l_vector2: .word 3
s_vector2: .word 2

.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0, vector0
    la s1, vector1
    mv a0, s0
    mv a1, s1

    # Set vector attributes
    la a2, l_vector # size of vectors
    lw a2, 0(a2)
    la a3, s_vector0 # stride of vector0
    lw a3, 0(a3)
    la a4, s_vector1 # stride of vector1
    lw a4, 0(a4)

    # Call dot function
    call dot

    # Print integer result
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char
    
    # Perform dot with different stride
    la a0, vector0
    la a1, vector1

    la a2, l_vector2 # size of vectors
    lw a2, 0(a2)
    la a3, s_vector0 # stride of vector2
    lw a3, 0(a3)
    la a4, s_vector2 # stride of vector3
    lw a4, 0(a4)

    # Call dot function
    call dot

    # Print integer result
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Exit
    jal exit
