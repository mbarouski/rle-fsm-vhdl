# VHDL master course labs
Master course VHDL labs

## Tips
- Avoid strange characters (cyrillic) in the path to the workspace;
- [Here](https://www.aldec.com/en/support/resources/documentation/faq/1195) you can read about unnecessary files for tracking by git;

## Easy RLE

It is a simple solution of RLE problem without using finite state machine (FSM).

Easy RLE design contains 3 entities:
- RAM;
- RLE Encoder;
- Manager.

Manager combines RAM and RLE Encoder and has additiona logic.

Easy RLE work result:
![Easy RLE work result](/easy_rle/waveforms/ram_before_and_after_rle.JPG)

Items [0; 9] are initial array.
Items [10; 19] are result array.
