/// Module: main
module main::main {
    use sui::tx_context::sender;
    use sui::event;
    use std::string::{Self, String};
    use sui::vec_map::{Self, VecMap};
    use std::vector;
 
    public struct MainEvent has copy, drop {
        score: u64
    }

    public fun main(pos: vector<u64>, ctx: &mut TxContext) {
        let mut m: VecMap<u64, vector<u64>> = vec_map::empty();
        let mut score = 0;

        let mut i = 0;
        while (i < pos.length()) {   
            let value = pos.borrow(i);
            if (m.contains(value))  {
                let mut vec = m.get_mut(value);
                if (vec.length() > 0) {
                    *vec = vector::empty();
                    score = score + 1;
                } else {
                    vec.push_back(*value);
                }
            } else {
                let mut vec = vector::empty();
                vec.push_back(i);
                m.insert(*value, vec);
            };

            i = i + 1;
        };

        let m = MainEvent {
            score: score,
        };
        event::emit(m);
    }

}
