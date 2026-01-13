// Logic proof for CompactImageMap bug

import Swift

func buggyByteCount(for code: UInt64) -> Int {
    let leadingZeroBitCount = code.leadingZeroBitCount
    // The buggy formula found in CompactImageMap.swift:
    // (64 - theCode.leadingZeroBitCount) >> 3
    return max((64 - leadingZeroBitCount) >> 3, 1)
}

func fixedByteCount(for code: UInt64) -> Int {
    let leadingZeroBitCount = code.leadingZeroBitCount
    // The fixed formula:
    // (64 - theCode.leadingZeroBitCount + 7) >> 3
    return max((64 - leadingZeroBitCount + 7) >> 3, 1)
}

// Test case:
// We need to encode a value that requires more than 8 bits.
// Value 256 (0x100) requires 9 bits.
// leadingZeroBitCount for 256 (UInt64) is 55.
// 64 - 55 = 9 bits.

let testValue: UInt64 = 256
print("Testing value: \(testValue) (requires 9 bits)")

let buggyResult = buggyByteCount(for: testValue)
print("Buggy formula result: \(buggyResult) bytes") 
// Expected: 1 byte (Truncation! 9 bits don't fit in 1 byte)

let fixedResult = fixedByteCount(for: testValue)
print("Fixed formula result: \(fixedResult) bytes")
// Expected: 2 bytes

if buggyResult < 2 {
    print("CONFIRMED BUG: Buggy formula calculated insufficient bytes (1) for 9-bit value.")
}

if fixedResult >= 2 {
    print("CONFIRMED FIX: Fixed formula calculated sufficient bytes (\(fixedResult)).")
}
