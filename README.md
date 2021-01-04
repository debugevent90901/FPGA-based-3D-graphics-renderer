# FPGA-based graphic renderer
This is the Final Project of ECE385 in UIUC 

implemented on DE2-115 board

Teammate: [TaKeTube](https://github.com/TaKeTube)

**This is only a project that is for learning and fun, not industrial productive.**



## 1. Description
This project can render 3D objects with FPGA, and control the position of camera, the 3 Euler angle to control the rotation through keyboard.
It uses on chip memory to store the information of the 3D object and as frame buffer, and uses NIOS-II as controllor to drive the keyboard.
For more details, see report.pdf and proposal.pdf.

+   In Final folder are the final finished files, all well-comments
+    In MidPoint folder are existing files before mid point check, not fully functioned and may be messy. Not all files are commented.

## 2. Third-Party Libraries
Original contributor: [WangXuan95/Verilog-FixedPoint](https://github.com/WangXuan95/Verilog-FixedPoint)
Instead of floating point, we choose to use fixed point number. This is the only outer existing library we used, and we make certian modification to it, see details in /Final/trigonometric_lib.sv.

### 3. Design & Implementation Details

See the FinalReport and FinalProposal for detailed description.

