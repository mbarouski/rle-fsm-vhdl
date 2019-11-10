# VHDL master course labs
Master course VHDL labs

## Tips
- Avoid strange characters (cyrillic) in the path to the workspace;
- [Here](https://www.aldec.com/en/support/resources/documentation/faq/1195) you can read about unnecessary files for tracking by git;

## Easy RLE

It is a simple solution of RLE problem without using finite state machine (FSM).

Easy RLE design contains 3 entities:
- `RAM`;
- `RLE Encoder`;
- `Manager`.

`Manager` combines `RAM` and `RLE Encoder` and has additiona logic.

Easy RLE work result:

![Easy RLE work result](/easy_rle/waveforms/ram_before_and_after_rle.JPG)

Items [0; 9] are initial array.

Items [10; 19] are result array.

Initial array:
```
2,10,10,10,0,0,11,11,0,0
```
Result array:
```
2,1,10,3,0,2,11,2,0,2
```

## FSM RLE

Inspired by Ivaniuk A. A. presentations "Designing digital systems on programmable logic devices"
