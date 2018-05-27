# MIT License

Copyright (c) 2017  Danny Savory

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


# Summary
 - This library contains a hardware module which implements SHA-256, written in VHDL.  Also included are two .do files for verifying correct operation of the SHA-256 core module.  An SHA-256 package has been written in VHDL which defines common shifting operations as defined in the original NIST document, which can be found here:
 http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf


# VHDL
 - The VHDL files assume you are compiling entities to a library named "dsaves".
 This was done to avoid naming collisions. Because libraries in VHDL are a virtual construct, you may have to work with other software you are using (eg. Modelsim, QuestaSim, Xilinx ISE, etc) to create the library "dsaves" and compile the design units to that library.  Alternatively, you can change the "dsaves" library to "work".
