/// Module: main
module main::main {
    use sui::tx_context::sender;
    use sui::event;
    use std::string::{Self, String};
    use sui::vec_map::{Self, VecMap};
    use std::vector;
 
    public struct MainEvent has copy, drop {
        sui: u64
    }

    public fun main(n: u64, k: u64, c: vector<u64>, ctx: &mut TxContext) {
        let mut owned = 0u64;
        let mut sent = 0u64;

        let mut i = 0;
        while (i < n) {
            let v = *c.borrow(i);
            if (v >= k) {
                owned = owned + v;
            } else if (owned > 0 && v == 0) {
                owned = owned - 1;
                sent = sent + 1;
            };

            i = i + 1;
        };

        let m = MainEvent {
            sui: sent,
        };
        event::emit(m);
    }

}
