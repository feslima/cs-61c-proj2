.import ../../src/dot.s
.import ../../src/utils.s

# Set vector values for testing
.data
vector0: .word 0
vector1: .word 0


.text
# main function for testing
main:
    # Load vector addresses into registers
    la a0 vector0
    la a1 vector1

    # Set vector attributes
    li a2 0 # size of vectors
    li a3 1 # stride of vector0
    li a4 1 # stride of vector1

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
