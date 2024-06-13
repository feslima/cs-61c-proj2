.import ../../src/relu.s
.import ../../src/utils.s

# Set vector values for testing
.data
m0: .word 0


.text
# main function for testing
main:
    # Load address of m0
    la s0 m0

    # Set dimensions of m0
    li s1 0 
    li s2 0

    # Call relu function
    mv a0 s0
    mul a1 s1 s2 # Convert dimensions to total number of elements
    jal ra relu

    # Exit
    jal exit
