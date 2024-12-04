/// Module: main
module main::main {
    use std::string::{Self, String};
    use sui::event;

    public struct MainEvent has copy, drop {
        say: String,
    }

    public fun main() {
        event::emit(MainEvent {
            say: string::utf8(b"Hello Sui! Let's move to the moon!"),
        });
    }
}
