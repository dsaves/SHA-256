--MIT License
--
--Copyright (c) 2017  Danny Savory
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.


-- ############################################################################
--  The official specifications of the SHA-256 algorithm can be found here:
--      http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package sha_256_pkg is
    constant WORD_SIZE : natural := 32;
    
    type K_DATA is array (0 to 63) of std_logic_vector(WORD_SIZE-1 downto 0);
    type M_DATA is array (0 to 15) of std_logic_vector(WORD_SIZE-1 downto 0);
    type H_DATA is array (0 to 7) of std_logic_vector(WORD_SIZE-1 downto 0);
    
    constant K : K_DATA := (
        --address 0
        X"428a2f98", X"71374491", X"b5c0fbcf", X"e9b5dba5",
        X"3956c25b", X"59f111f1", X"923f82a4", X"ab1c5ed5",
        X"d807aa98", X"12835b01", X"243185be", X"550c7dc3",
        X"72be5d74", X"80deb1fe", X"9bdc06a7", X"c19bf174",
        X"e49b69c1", X"efbe4786", X"0fc19dc6", X"240ca1cc",
        X"2de92c6f", X"4a7484aa", X"5cb0a9dc", X"76f988da",
        X"983e5152", X"a831c66d", X"b00327c8", X"bf597fc7",
        X"c6e00bf3", X"d5a79147", X"06ca6351", X"14292967",
        X"27b70a85", X"2e1b2138", X"4d2c6dfc", X"53380d13",
        X"650a7354", X"766a0abb", X"81c2c92e", X"92722c85",
        X"a2bfe8a1", X"a81a664b", X"c24b8b70", X"c76c51a3",
        X"d192e819", X"d6990624", X"f40e3585", X"106aa070",
        X"19a4c116", X"1e376c08", X"2748774c", X"34b0bcb5",
        X"391c0cb3", X"4ed8aa4a", X"5b9cca4f", X"682e6ff3",
        X"748f82ee", X"78a5636f", X"84c87814", X"8cc70208",
        X"90befffa", X"a4506ceb", X"bef9a3f7", X"c67178f2"
    );
    
    --Message schedule, W(00), W(01), ...W(63) (64 32-bit words)
    signal W : K_DATA := (
        --address 0
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000"
    );
    
    --Message blocks, the padded message should be a multiple of 512 bits,
    signal M : M_DATA;
    
    --function definitions
    function ROTR (a : std_logic_vector(WORD_SIZE-1 downto 0); n : natural)
                    return std_logic_vector;
    function ROTL (a : std_logic_vector(WORD_SIZE-1 downto 0); n : natural)
                    return std_logic_vector;
    function SHR (a : std_logic_vector(WORD_SIZE-1 downto 0); n : natural)
                    return std_logic_vector;
    function CH (x : std_logic_vector(WORD_SIZE-1 downto 0);
                    y : std_logic_vector(WORD_SIZE-1 downto 0);
                    z : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector;
    function MAJ (x : std_logic_vector(WORD_SIZE-1 downto 0);
                    y : std_logic_vector(WORD_SIZE-1 downto 0);
                    z : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector;
                    
    function SIGMA_UCASE_0 (x : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector;
    function SIGMA_UCASE_1 (x : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector;
    function SIGMA_LCASE_0 (x : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector;
    function SIGMA_LCASE_1 (x : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector;
                    
end package;

package body sha_256_pkg is
    function ROTR (a : std_logic_vector(WORD_SIZE-1 downto 0); n : natural)
                    return std_logic_vector is
        --result : std_logic_vector(WORD_SIZE-1 downto 0);
    begin
        --signal result : std_logic_vector(WORD_SIZE-1 downto 0);
        return (std_logic_vector(shift_right(unsigned(a), n))) or std_logic_vector((shift_left(unsigned(a), (WORD_SIZE-n))));
    end function;
    
    function ROTL (a : std_logic_vector(WORD_SIZE-1 downto 0); n : natural)
                    return std_logic_vector is
        --result : std_logic_vector(WORD_SIZE-1 downto 0);
    begin
        --signal result : std_logic_vector(WORD_SIZE-1 downto 0);
        return (std_logic_vector(shift_left(unsigned(a), n))) or std_logic_vector((shift_right(unsigned(a), (WORD_SIZE-n))));
    end function;
    
    function SHR (a : std_logic_vector(WORD_SIZE-1 downto 0); n : natural)
                    return std_logic_vector is
    begin
        return std_logic_vector(shift_right(unsigned(a), n));
    end function;
    
    function CH (x : std_logic_vector(WORD_SIZE-1 downto 0);
                    y : std_logic_vector(WORD_SIZE-1 downto 0);
                    z : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector is
    begin
        return (x and y) xor (not(x) and z);
    end function;
    
    function MAJ (x : std_logic_vector(WORD_SIZE-1 downto 0);
                    y : std_logic_vector(WORD_SIZE-1 downto 0);
                    z : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector is
    begin
        return (x and y) xor (x and z) xor (y and z);
    end function;
    
    function SIGMA_UCASE_0 (x : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector is
    begin
        return ROTR(x, 2) xor ROTR(x, 13) xor ROTR(x, 22);
    end function;
    
    function SIGMA_UCASE_1 (x : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector is
    begin
        return ROTR(x, 6) xor ROTR(x, 11) xor ROTR(x, 25);
    end function;
    
    function SIGMA_LCASE_0 (x : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector is
    begin
        return ROTR(x, 7) xor ROTR(x, 18) xor SHR(x, 3);
    end function;
    
    function SIGMA_LCASE_1 (x : std_logic_vector(WORD_SIZE-1 downto 0))
                    return std_logic_vector is
    begin
        return ROTR(x, 17) xor ROTR(x, 19) xor SHR(x, 10);
    end function;
    
end package body;

