package bignum

import u8, u16, uint from std::integer
public type u1 is (int x) where 0 <= x && x <= 1

// Add with carry
public property adc(u8 lhs, u8 rhs, u1 c) -> (u8 res, u1 nc):
    u16 ith = lhs + rhs + c
    u8 r = ith % 256
    if ith > 255:
        return (r,1)
    else:
        return (r,0)

// Increment with carry
public property inc(u8 val) -> (u8 res, u1 c):
    // For now.
    return adc(val,1,0)
