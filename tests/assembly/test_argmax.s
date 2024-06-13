.import ../../src/argmax.s
.import ../../src/utils.s

.data
v0: .word 3 -42 432 7 -5 6 5 -114 2
v1: .word 3 -42 7 432 -500 6 5 -114 2 # ensure magnitude of large negative is ignored
v2: .word 3 432 -42 7 -5 6 5 -114 432 # mutiple maxima case

.text
main:
    # Load address of v0
    la s0 v0
    
    # Set length of v0
    addi s1 x0 9

    # Call argmax of v0
    mv a0 s0
    mv a1 s1
    jal ra argmax

    # Print the output of argmax
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Call argmax of v1
    la a0 v1
    jal ra argmax

    # Print the output of argmax
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Call argmax of v2
    la a0 v2
    jal ra argmax

    # Print the output of argmax
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Exit program
    jal exit
