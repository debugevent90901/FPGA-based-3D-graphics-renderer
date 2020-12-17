# ECE 385 Final Project
a graphic renderer implemented on DE-2 board

Teammate: [TaKeTube](https://github.com/TaKeTube)

## 1. fixedpoint-lib
modified from [WangXuan95/Verilog-FixedPoint](https://github.com/WangXuan95/Verilog-FixedPoint)

### 特点

* **参数化定制位宽** ： 可定制整数位宽和小数位宽。
* **四则运算** ： 加减乘除。
* **高级运算** ： 目前已实现 **Sin** 和 **Sqrt** 。
* **舍入控制** ： 发生截断时，可选择是否进行四舍五入
* **与浮点数互相转换** 
* **单周期与流水线** ： 所有运算均有 **单周期实现** ，组合逻辑延迟长的运算有 **流水线实现** 。

### 定点数格式

| **I** | **I** | **......** | **I** | **I** | **F** | **F** | **......** | **F** | **F** |
| :---: | :---: | :---:      | :---: | :---: | :---: | :---: | :---:      | :---: | :---: |
||

如上，定点数由若干位整数和若干位小数组成。等效于 **二进制补码整数** 除以 **2^小数位数** 。

若整数位数为8，小数位数为8，定点数举例如下表：

|     二进制码     | **整数** | **定点数** (8位整数，8位小数) |   备注   |
| :--------------: | :------: | :---------------------------: | :------: |
| 0000000000000000 |    0     |              0.0              |   零值   |
| 0000000100000000 |   256    |              1.0              |          |
| 1111111100000000 |   -256   |             -1.0              |          |
| 0000000000000001 |    1     |          0.00390625           | 最小正值 |
| 1111111111111111 |    -1    |          -0.00390625          | 最大负值 |
| 0111111111111111 |  32767   |         127.99609375          | 最大正值 |
| 1000000000000000 |  -32768  |            -128.0             | 最小负值 |
| 0001010111000011 |   5571   |          21.76171875          |          |
| 1001010110100110 |  -27226  |         -106.3515625          |          |


本库的模块输入输出都可以用参数 **定制定点数位宽** ，这些参数是统一的，以乘法器为例：

```SystemVerilog
module fxp_mul # ( // 以乘法器为例
    parameter WIIA = 8,       // 输入(乘数a)的整数位宽，默认=8
    parameter WIFA = 8,       // 输入(乘数a)的小数位宽，默认=8
    parameter WIIB = 8,       // 输入(乘数b)的整数位宽，默认=8
    parameter WIFB = 8,       // 输入(乘数b)的小数位宽，默认=8
    parameter WOI  = 8,       // 输出(积)的整数位宽，默认=8
    parameter WOF  = 8,       // 输出(积)的小数位宽，默认=8
    parameter bit ROUND= 1    // 当积的小数截断时，是否四舍五入，默认是
)(
    input  logic [WIIA+WIFA-1:0] ina, // 乘数a
    input  logic [WIIB+WIFB-1:0] inb, // 乘数b
    output logic [WOI +WOF -1:0] out, // 结果(积) = 乘数a * 乘数b
    output logic overflow             // 结果是否溢出，若溢出则为 1'b1
                                      // 若为正数溢出，则out被置为最大正值
                                      // 若为负数溢出，则out被置为最小负值
);
```

### 各模块名称与功能

所有可综合的模块实现都在 [./RTL/fixedpoint.sv](https://github.com/WangXuan95/Verilog-FixedPoint/blob/master/RTL/fixedpoint.sv) 中，各模块名称和功能如下表：

|   运算名   | 单周期(组合逻辑) |       流水线       |          说明          |
| :--------: | :--------------: | :----------------: | :--------------------: |
|  位宽变换  |   **fxp_zoom**   |       不需要       |    有溢出、舍入控制    |
|    加减    |  **fxp_addsub**  |       不需要       | 具有1bit信号控制加或减 |
|     加     |   **fxp_add**    |       不需要       |                        |
|    乘法    |   **fxp_mul**    |  **fxp_mul_pipe**  |                        |
|    除法    |   **fxp_div**    |  **fxp_div_pipe**  |  单周期版时序不易收敛  |
| 开方(sqrt) |   **fxp_sqrt**   | **fxp_sqrt_pipe**  |  单周期版时序不易收敛  |
| 正弦(sin)  |   **fxp_sin**    |       待实现       |  单周期版时序不易收敛  |
| 定点转浮点 |  **fxp2float**   | **fxp2float_pipe** |  单周期版时序不易收敛  |
| 浮点转定点 |  **float2fxp**   | **float2fxp_pipe** |  单周期版时序不易收敛  |

> 注：以上所有流水线模块的流水线段数详见注释。

### 各运算模块默认参数
+ **fxp_zoom** 
    ```SystemVerilog
    .WII=.WIF=.WOI=.WOF=8; .ROUND=1;
    ```
+ **fxp_add**, **fxp_addsub**, **fxp_mul**, **fxp_div**
    ```SystemVerilog
    .WIIA=.WIFA=.WIIB=.WIFB=8;
    .WOI=.WOF=8;
    .ROUND=1;
    ```
+ **fxp_sqrt**
    ```SystemVerilog
    .WII=.WIF=.WOI=.WOF=8; .ROUND=1;
    ```
+ **fxp_sin**
    ```SystemVerilog
    .WII=4; .WIF=8;
    .WOI=2; .WOF=12; .ROUND=1;
    ```
+ **fxp2float**
    ```SystemVerilog
    .WII=.WIF=8;
    ```
+ **float2fxp**
    ```SystemVerilog
    .WOI=.WOF=8; .ROUND=1;
    ```

## 2. Fixed-point Number Matrix Multiplication
*$4\text{x}4$矩阵乘法, purely combinatorial, finish within one clock*
16次 $(4\text{x}1) \cdot (1\text{x}4)$ 点积并行

## 3. Model-View-Projection Transformation
*All the three following modules are purely combinatorial and do not require a clock signal*
### get_model_matrix.sv
pseudocode in cpp:
```c++
    Eigen::Matrix4f get_model_matrix(float angle)
    {
       Eigen::Matrix4f rotation;
       angle = angle * MY_PI / 180.f;
       rotation << cos(angle), 0, sin(angle), 0,
           0, 1, 0, 0,
           -sin(angle), 0, cos(angle), 0,
           0, 0, 0, 1;

       Eigen::Matrix4f scale;
       scale << 2.5, 0, 0, 0,
           0, 2.5, 0, 0,
           0, 0, 2.5, 0,
           0, 0, 0, 1;

       Eigen::Matrix4f translate;
       translate << 1, 0, 0, 0,
           0, 1, 0, 0,
           0, 0, 1, 0,
           0, 0, 0, 1;

       return translate * rotation * scale;
    }
```
$\text{I/O}$ of the $\text{.sv}$ module:
```SystemVerilog
module get_model_matrix(    input [12:0] angle,
                            input [15:0] scale, x_translate, y_translate, z_translate,
                            output logic [15:0][15:0] model_matrix
);
```
输入（4-8）定点数表示的弧度制角度$\text{angle}$,（8-8）定点数表示的$\text{scale}$, $\text{x\_translate}$, $\text{y\_translate}$, $\text{z\_translate}$; 输出$4\text{x}4\text{ model matrix}$，每个元素都是（8-8）定点数

$$ R=
 \left[
 \begin{matrix}
   cos(angle) & 0 & sin(angle) & 0 \\
   0 & 1 & 0 & 0 \\
   -sin(angle) & 0 & cos(angle) & 0\\
   0 & 0 & 0 & 1
  \end{matrix}
  \right]
$$


$$ S=
 \left[
 \begin{matrix}
   scale & 0 & 0 & 0 \\
   0 & scale & 0 & 0 \\
   0 & 0 & scale & 0\\
   0 & 0 & 0 & 1
  \end{matrix}
  \right]
$$

$$ T=
 \left[
 \begin{matrix}
   1 & 0 & 0 & x\_translate \\
   0 & 1 & 0 & y\_translate \\
   0 & 0 & 1 & z\_translate \\
   0 & 0 & 0 & 1
  \end{matrix}
  \right]
$$
To reduce the number of $\text{DSP}$ used, pre-computed the matrix multiplication $T \cdot R \cdot S$

$$ T \cdot R \cdot S=
 \left[
 \begin{matrix}
   scale \cdot cos(angle) & 0 & scale \cdot sin(angle) & x\_translate \\
   0 & scale & 0 & y\_translate \\
   -scale \cdot sin(angle) & 0 & scale \cdot cos(angle) & z\_translate\\
   0 & 0 & 0 & 1
  \end{matrix}
  \right]
$$

### get_view_model.sv
pseudocode in cpp:
```c++
Eigen::Matrix4f get_view_matrix(Eigen::Vector3f eye_pos)
{
    Eigen::Matrix4f view = Eigen::Matrix4f::Identity();

    Eigen::Matrix4f translate;
    translate << 1, 0, 0, -eye_pos[0],
        0, 1, 0, -eye_pos[1],
        0, 0, 1, -eye_pos[2],
        0, 0, 0, 1;

    view = translate * view;

    return view;
}
```
$\text{I/O}$ of the $\text{.sv}$ module:
```SystemVerilog
module get_view_matrix( input [16:0] x_pos, y_pos, z_pos,
                        output logic [15:0][15:0] view_matrix
);
```
输入3个用（8-8）定点数表示的坐标；输出$4\text{x}4\text{ view matrix}$，每个元素都是（8-8）定点数

### get_projection_matrix.sv
pseudocode in cpp:
```c++
Eigen::Matrix4f get_projection_matrix(float eye_fov, float aspect_ratio, float zNear, float zFar)
{
    // TODO: Use the same projection matrix from the previous assignments
    //computing improved version
    Eigen::Matrix4f projection;
    zNear = -zNear;
    zFar = -zFar;
    float inv_tan = 1 / tan(eye_fov / 180 * MY_PI * 0.5);
    float k = 1 / (zNear - zFar);
    projection << inv_tan / aspect_ratio, 0, 0, 0,
        0, inv_tan, 0, 0,
        0, 0, (zNear + zFar) * k, 2 * zFar * zNear * k,
        0, 0, 1, 0;
    return projection;
}
```
$\text{I/O}$ of the $\text{.sv}$ module:
```SystemVerilog
module get_projection_matrix(   input [12:0] eye_fov, 
                                input [15:0] aspect_ratio, z_near, z_far,
                                output [15:0][15:0] projection_matrix
);
```
输入（4-8）定点数表示的弧度制角度$\text{eye\_fov}$,（8-8）定点数表示的$\text{aspect\_ratio}$, $\text{z\_near}$, $\text{z\_far}$; 输出$4\text{x}4\text{ projection matrix}$，每个元素都是（8-8）定点数
