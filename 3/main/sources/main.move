/// Module: main
module main::main {
    use sui::tx_context::sender;
    use std::uq32_32::{Self, UQ32_32, gt, from_int, from_quotient};
    use sui::event;

    public struct MainEvent has copy, drop {
        res: u64,
    }

    public struct MyStruct has copy, drop {
        value_per_weight: UQ32_32,
        index: u64,
    }

    public fun main(n: u64, v: u64, vi: vector<u64>, wi: vector<u64>, ctx: &mut TxContext) {
        let mut dp: vector<vector<u64>> = vector::empty();
        let mut i = 0;
        while (i < n) {
            dp.push_back(vector::empty());
    
            let mut j = 0;
            while (j <= v) {
                dp[i].push_back(0);
                j = j + 1;
            };

            i = i + 1;
        };        

        let mut j = vi[0];
        while (j <= v) {
            *dp[0].borrow_mut(j) = wi[0];
            j = j + 1;
        };

        i = 1;
        while (i < n) {
            let mut j = 0;
            while (j <= v) {
                let v = if (j >= *vi.borrow(i)) {
                    if (*dp[i-1].borrow(j - *vi.borrow(i)) + wi[i] > *dp[i-1].borrow(j)) {*dp[i-1].borrow(j - *vi.borrow(i)) + wi[i]} else {*dp[i-1].borrow(j)}
                } else {
                    *dp[i-1].borrow(j)
                };
                
                *dp[i].borrow_mut(j) = v;      

                j = j + 1;  
            };

            i = i + 1;
        };
 
        let m = MainEvent {
            res: *dp[n - 1].borrow(v),
        };

        event::emit(m);
    }
}
