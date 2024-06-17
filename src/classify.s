.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    
    li t0, 5
    bne a0, t0, error_wrong_num_args
    
    addi sp, sp, -36
    sw ra, 32(sp)
    sw s6, 28(sp)
    sw s5, 24(sp)
    sw s4, 16(sp)
    sw s3, 12(sp)
    sw s2, 8(sp)
    sw s1, 4(sp)
    sw s0, 0(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    
    # allocate space to store dimentions of m0, m1 and input
    addi sp, sp, -32
    # &ph2       - 28 (placeholder of 4 bytes - scores)
    # &ph1       - 24 (placeholder of 4 bytes - hidden_layer)
    # m0_rows    - 20
    # m0_cols    - 16
    # m1_rows    - 12
    # m1_cols    -  8
    # input_rows -  4
    # input_cols -  0

    # Load pretrained m0
    addi t0, sp, 20 # address of number of rows of m0
    addi t1, sp, 16 # address of number of columns of m0
    lw s3, 4(s1)
    mv a0, s3
    mv a1, t0
    mv a2, t1
    jal read_matrix
    mv s3, a0
    lw a1, 0(a1)
    sw a1, 20(sp)
    lw a2, 0(a2)
    sw a2, 16(sp)

    # Load pretrained m1
    addi t0, sp, 12 # address of number of rows of m1
    addi t1, sp, 8  # address of number of columns of m1
    lw s4, 8(s1)
    mv a0, s4
    mv a1, t0
    mv a2, t1
    jal read_matrix
    mv s4, a0
    lw a1, 0(a1)
    sw a1, 12(sp)
    lw a2, 0(a2)
    sw a2, 8(sp)

    
    # Load input matrix
    addi t0, sp, 4  # address of number of rows of input
    addi t1, sp, 0 # address of number of columns of input
    lw s5, 12(s1)
    mv a0, s5
    mv a1, t0
    mv a2, t1
    jal read_matrix
    mv s5, a0
    lw a1, 0(a1)
    sw a1, 4(sp)
    lw a2, 0(a2)
    sw a2, 0(sp)

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    j compute_first_layer
    done_computing_layers:

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    lw a1, 28(sp)
    lw a2, 12(sp)
    lw a3, 0(sp)
    jal ra write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw a0, 28(sp)
    lw t0, 12(sp)
    lw t1, 0(sp)
    mul a1, t0, t1
    jal argmax
    mv s6, a0

    # Print classification
    mv a1, s6
    jal print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

    # deallocate read matrices
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    
    # deallocate computed matrices
    lw a0, 24(sp)
    jal free
    lw a0, 28(sp)
    jal free

    addi sp, sp, 32 # deallocate dimensions

    # restore registers
    mv a0, s6 # classification
    mv a1, s1
    mv a2, s2

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36

    ret
    
compute_first_layer:
    lw a1, 20(sp)
    lw a2, 16(sp)
    mv a3, s5
    lw a4, 4(sp)
    lw a5, 0(sp)
    mul a0, a1, a5 # number of elements in output array
    slli a0, a0, 2  # multiply by 4 bytes
    jal malloc
    lw a1, 20(sp) # restore m0_rows
    sw a0, 24(sp) # store the address of the allocated array
    mv a6, a0
    mv a0, s3
    jal matmul

    j compute_second_layer
    
compute_second_layer:
    lw a0, 24(sp)
    lw t0, 20(sp)
    lw t1, 0(sp)
    mul a1, t0, t1 # number of elements in output array

    jal relu
    
    j compute_third_layer

compute_third_layer:
    lw a1, 12(sp)  # m1_rows
    lw a2, 8(sp)   # m1_cols
    lw a3, 24(sp)  # &hidden_layer
    lw a4, 20(sp)  # m0_rows
    lw a5, 0(sp)   # input_cols
    mul a0, a1, a5 # number of elements in output array
    slli a0, a0, 2  # multiply by 4 bytes
    jal malloc
    lw a1, 12(sp) # restore m1_rows
    sw a0, 28(sp) # store the address of the allocated array
    mv a6, a0      # scores
    mv a0, s4
    jal matmul
    
    j done_computing_layers

error_wrong_num_args:
    li a1, 49
    jal exit2