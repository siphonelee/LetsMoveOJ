/// Module: main
module main::main {
    use sui::tx_context::sender;
    use sui::event;
    use std::string::{Self, String};
    use sui::vec_map::{Self, VecMap};

    public struct MainEvent has copy, drop {
        res: u64,
    }

    fun partition(v: &mut vector<u64>, low: u64, high: u64): u64 {
        let pivot = *v.borrow(high);
        let mut i = low;

        let mut j = low;
        while (j <= high - 1) {
            if (*v.borrow(j) < pivot) {
                if (i != j) {
                    let ti = *v.borrow(i);
                    let tj = *v.borrow(j);
                    *v.borrow_mut(i) = tj;
                    *v.borrow_mut(j) = ti;
                };

                i = i + 1;
            };

            j = j + 1;
        };
    
        let ti = *v.borrow(i);
        *v.borrow_mut(i) = pivot;
        *v.borrow_mut(high) = ti;

        i
    }

    fun quick_sort(v: &mut vector<u64>, low: u64, high: u64) {
        if (low < high) {
            let p = partition(v, low, high);
            if (p > 0) {
                quick_sort(v, low, p - 1);
            };
            quick_sort(v, p + 1, high);
        };
    }

    public fun main(pos: vector<u64>, ctx: &mut TxContext) {
        let mut res = 0;

        let mut v = pos;
        let len = pos.length();
        quick_sort(&mut v, 0, len - 1);

        let mut i = 0;
        while (i < len/2) {
            res = res + (*v.borrow(len - 1 -i) - *v.borrow(i));
            i = i + 1;
        };
        
        let m = MainEvent {
            res: res,
        };
        event::emit(m);       
    }
}
