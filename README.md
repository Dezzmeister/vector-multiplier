# vector-multiplier
Hardware design to multiply matrices (wip)

WIP


Multiplies two matrices by calculating the dot products of their vectors. The matrices are sent over a serial port as fixed-point vectors. 
Parameters such as the bit width of one vector element, the position of the decimal place, and the dimension of a vector are specified in the hardware.

Individual elements are received by a UART and stored in BRAM. 
After all elements have been received, they are read from BRAM into the dot product circuit. 
The dot products are stored in BRAM; when the device finishes multiplying the matrices, the dot products are read out and sent back through the UART.
In order to initiate this process, the PC must send the 8-bit ACCEPT_METADATA opcode (0x01). 
After sending this, the PC sends two metadata elements (where the width of an element is defined in the design).
The metadata elements are treated as integers; the first element is the number of expected ELEMENTS in the first matrix and the second element is the number of expected elements in the second matrix.
The PC then sends the vectors in the first matrix, followed by the vectors in the second matrix.
When the device has received the expected elements, it computes the appropriate dot products and sends them back to the PC.

WIP: The part of the design that reads the vectors out of memory is not finished, it does not yet work with dual-port BRAM. 
