.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    ble a2, zero, error_empty_vector
    ble a3, zero, error_no_stride
    ble a4, zero, error_no_stride

    # Prologue

error_empty_vector:
    li a1 5
    jal exit2

error_no_stride:
    li a1 6
    jal exit2

loop_start:

loop_end:


    # Epilogue

    
    ret