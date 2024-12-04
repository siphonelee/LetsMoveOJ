/// Module: main
module main::main {
    use sui::tx_context::sender;
    use sui::event;
    use std::string::{Self, String};
    use sui::vec_map::{Self, VecMap};
    use std::vector;
 
    public struct MainEvent has copy, drop {
        min: u64
    }

    public fun main(h: vector<u64>, ctx: &mut TxContext) {
        let mut i = 0;
        let mut dp: vector<u64> = vector::empty();
        while (i < h.length()) {
            let v = *h.borrow(i);

            let mut j = 0;
            let mut longest = 1;
            while (j < i) {
                let v1 = *h.borrow(j);
                if (v >= v1) {
                    let len = *dp.borrow(j) + 1;
                    if (len > longest) {
                        longest = len;
                    };
                };

                j = j + 1;
            };

            dp.push_back(longest);

            i = i + 1;
        };

        i = 0;
        let mut longest = 0;
        while (i < dp.length()) {
            let len = *dp.borrow(i);
            if (len > longest) {
                longest = len;
            };

            i = i + 1;
        };

        let m = MainEvent {
            min: h.length() - longest,
        };
        event::emit(m);
    }

}
