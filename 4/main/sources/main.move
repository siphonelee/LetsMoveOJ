/// Module: main
module main::main {
    use sui::tx_context::sender;
    use sui::event;
    use std::string::{Self, String};

    const DIV: u64 = 1000000000000000;
    const PADDING_TO: u64 = 15;

    public struct Main has key {
        id: UID,
        fib: String,
    }

    fun number_to_string(v: u8): String {
        if (v == 0) {
            string::utf8(b"0")
        } else if (v == 1) {
            string::utf8(b"1")
        } else if (v == 2) {
            string::utf8(b"2")
        } else if (v == 3) {
            string::utf8(b"3")
        } else if (v == 4) {
            string::utf8(b"4")
        } else if (v == 5) {
            string::utf8(b"5")
        } else if (v == 6) {
            string::utf8(b"6")
        } else if (v == 7) {
            string::utf8(b"7")
        } else if (v == 8) {
            string::utf8(b"8")
        } else if (v == 9) {
            string::utf8(b"9")
        } else {
            abort(2)
        }
    }


    public struct BigInt has copy, drop {
        value: vector<u64>,
    }

    fun u64_to_string(v: u64, need_padding: bool): String {
        let mut ret = string::utf8(b"");
        let mut i = 0;
        let mut v = v;

        if (need_padding) {
            while (i < PADDING_TO) {
                let t = v % 10;
                v = v / 10;
                let mut s = number_to_string(t as u8);
                s.append(ret);
                ret = s;

                i = i + 1;
            };
        } else {
            while (v > 0) {
                let t = v % 10;
                v = v / 10;
                let mut s = number_to_string(t as u8);
                s.append(ret);
                ret = s;                
            };
        };

        ret
    }

    fun to_string(a: &BigInt): String {
        let mut ret = string::utf8(b"");
        let mut i = 0; 
        let len = a.value.length();
        while (i < len - 1) {
            let mut s = u64_to_string(*a.value.borrow(i), true);            
            s.append(ret);
            ret = s;

            i = i + 1;
        };

        let mut s = u64_to_string(*a.value.borrow(len - 1), false); 
        s.append(ret);
        ret = s;

        ret
    }

    fun to_bigint(v: u64): BigInt {
        let mut ret = BigInt {
            value: vector::empty(),
        };

        let mut v = v;
        while (v > 0) {
            let t = v % DIV;
            ret.value.push_back(t);
            v = v / DIV;
        };

        ret
    }

    fun big_add(a: &BigInt, b: &BigInt): BigInt {
        let mut ret = BigInt {
            value: vector::empty(),
        };

        let size_a = a.value.length();
        let size_b = b.value.length();
        let mut size = size_a;
        if (size_b < size) {
            size = size_b; 
        };

        let mut overflow = 0;
        let mut i = 0;
        while (i < size) {
            let t = *a.value.borrow(i) + *b.value.borrow(i) + overflow;
            if (t >= DIV) {
                overflow = 1;
                ret.value.push_back(t % DIV);
            } else {
                ret.value.push_back(t);
                overflow = 0;
            };
 
            i = i + 1;
        };

        if (size_a > size) {
            while (i < size_a) {
                let t = *a.value.borrow(i) + overflow;
                if (t >= DIV) {
                    overflow = 1;
                    ret.value.push_back(t % DIV);
                } else {
                    ret.value.push_back(t);
                    overflow = 0;
                };

                i = i + 1;
            };
        } else if (size_b > size) {
            while (i < size_b) {
                let t = *b.value.borrow(i) + overflow;
                if (t >= DIV) {
                    overflow = 1;
                    ret.value.push_back(t % DIV);
                } else {
                    ret.value.push_back(t);
                    overflow = 0;
                };

                i = i + 1;
            };
        };

        if (overflow > 0) {
            ret.value.push_back(1u64);            
        };
 
        ret
    }

    fun fabnacci(n: u64): String {
        if (n == 0) {
            string::utf8(b"0")
        } else if (n == 1) {
            string::utf8(b"1")
        } else {
            let mut a = to_bigint(0);
            let mut b = to_bigint(1);
    
            let mut i: u64 = 2;
            let mut r = to_bigint(0);
            while (i <= n) {
                r = big_add(&a, &b);
                a = b;
                b = r;

                i = i + 1;
            };
            to_string(&r)
        }
    }

    public fun main(n: u64, ctx: &mut TxContext) {
        let m = Main {
            id: object::new(ctx),
            fib: fabnacci(n),
        };
        transfer::transfer(m, ctx.sender());
    }
}
