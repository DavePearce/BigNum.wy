package bignum

import u8, u16, uint from std::int
import std::array
import bignum::util with u1

public type BigUint is u8[] // little endian

public property to_int(BigUint self) -> (int r):
    return to_int(self,0)

public property to_int(BigUint self, uint i) -> (int r):
    if i >= |self|:
        return 0
    else:
        int ith = self[i] * (256**i) // shift left
        return ith + to_int(self,i+1)

public function add(BigUint lhs, BigUint rhs) -> (BigUint r)
// For simplicity make this asymetric
requires |lhs| >= |rhs|
// Check guarantee
ensures to_int(lhs) + to_int(rhs) == to_int(r):
    //
    u1 carry = 0
    // 
    for i in 0..|rhs| where |lhs| >= |rhs|:
        // Perform addition
        (lhs[i],carry) = util::adc(lhs[i],rhs[i],carry)
    // Push through remaining carry
    int i = |rhs|
    while carry == 1 && i < |lhs|:
        (lhs[i],carry) = util::inc(lhs[i])
        i = i + 1
    // Check for overflow    
    if carry == 0:
        return lhs
    else:
        // Overflow, so allocate sufficient space.
        return array::append(lhs,(u8) carry)

public method main():
    BigUint i1 = [101]
    BigUint i2 = [3]
    assume to_int([104]) == 104
    assume to_int([104,0]) == 104
    assume to_int([255,0]) == 255
    assume to_int([255,1]) == (255+256)
    // Check no carry
    assume add(i1,i2) == [104]
    // Check carry without overflow
    assume add([255,100],[1,0]) == [0,101]
    // Check carry with overflow
    assume add([255,100],[1]) == [0,101]
    