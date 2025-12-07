# Final Project PSD - Bombe Emulator (Key Cracking Machine) on VHDL

## Background

The **Bombe** was an electromechanical device used by British cryptologists at Bletchley Park during World War II to help decipher German Enigma-machine-encrypted secret messages. While the Enigma machine was used to *encrypt* messages, the Bombe was designed to *break* them by discovering the daily settings (keys) of the Enigma rotors.

This project aims to recreate the core functionality of the Bombe machine using VHDL. Unlike a standard Enigma simulator which takes plaintext and outputs ciphertext, this Bombe Emulator takes a known plaintext-ciphertext pair (a "crib") and automatically uses a brute-force algorithm to discover the correct Rotor Starting Position required to produce that encryption.

## High Level Design

Our design implements a Single-Unit Reciprocal Bombe. It consists of a complete digital replica of the Enigma machine's electrical pathway (The Scrambler), controlled by a microprogrammed Finite State Machine (The Controller) that iterates through rotor positions until the correct key is found.

### System Architecture
The system is divided into four main modules:

1.  Instruction ROM: Stores the microcode instructions (Opcodes) that define the search algorithm.
2.  Controller: Fetches instructions from the ROM and controls the rotor positions.
3.  Scrambler: A fully reciprocal digital Enigma replica (Forward + Inverse paths) that encrypts the input based on current rotor settings.
4.  Comparator: Ccontinuously compares the Scrambler's output with the expected target (crib).

### How it Works (The Algorithm)
1. Input: The user provides a `char_in` (e.g., 'A') and a `target_in` (e.g., 'D').
2.  Search Loop:
    * The Controller sets the rotor to a position (starting at 0).
    * The Scrambler processes the input through the full Enigma path.
    * The Comparator checks if the output matches the `target_in`.
3.  Condition:
    * Match Found: The Controller stops, and the `finished` signal lights up. The current rotor position is the Key.
    * No Match: The Controller increments the rotor position (steps the rotor) and loops back to check again.

## Technical Implementation

### 1. The Scrambler (Reciprocal Architecture)
Our Scrambler implements the Reciprocal (Double-Ended) nature of the Enigma machine. The signal path is:
`Input` → `Rotor 1` → `Rotor 2` → `Rotor 3` → `Reflector` → `Inverse Rotor 3` → `Inverse Rotor 2` → `Inverse Rotor 1` → `Output`.

This ensures that the encryption is mathematically accurate (If A encrypts to G, then G encrypts to A).

* Rotor.vhd: Performs the forward substitution: `(Input + Position) % 26` mapped to the wiring table.
* Inverse_Rotor.vhd: Performs the backward substitution: Maps the value back to the index and calculates `(Index - Position) % 26`.

### 2. Microprogrammed Controller
Instead of hardwiring the logic, we used a Microprogrammed approach. The behavior is defined in `Instruction_ROM.vhd` using custom opcodes:
* `OP_LOAD`: Resets the system.
* `OP_CHECK`: Checks the comparator output.
* `OP_STEP`: Rotates the rotor.
* `OP_LOOP`: Jumps back to the start of the check loop.
* `OP_STOP`: Halts the system when the key is found.

### 3. Bulletproof Logic
Both `Rotor` and `Inverse_Rotor` modules include input sanitation logic. This prevents simulation crashes ("Index out of bound" errors) by forcing invalid or uninitialized signals to a safe default (0) during the first delta cycles of the simulation.

## How to Use

The project can be simulated in Vivado or Quartus + Modelsim.

1.  Open the Project: Load all source files (`.vhd`) into the software.
2.  Set Up the Test Case:
    * Open `tb_Bombe_Emulator.vhd`.
    * Set `tb_char_in` to your known plaintext (e.g., 0 for 'A').
    * Set `tb_target` to your known ciphertext (e.g., 6 for 'G').
3.  Run Simulation:
    * Set `tb_Bombe_Emulator` as the Top Module.
    * Run Behavioral Simulation.
4.  Observe Results:
    * Watch the `done` / `finished` signal. When it goes High ('1'), the search is complete.
    * The value of `pos_r1` at that moment is the decrypted key.

## Testing & Results

We validated the design using two distinct testbenches to ensure both the encryption physics and the cracking logic were correct.

### 1. Verification of Reciprocity (`tb_Enigma_Sentence`)
We manually tested the Scrambler to prove the "Double-Ended" logic works.
* Test: Encrypting 'A' (0) yielded 'G' (6). Encrypting 'G' (6) with the same setting yielded 'A' (0).
* Result: Verified. The machine behaves exactly like a physical Enigma.
<img width="1073" height="230" alt="Screenshot 2025-12-05 213317" src="https://github.com/user-attachments/assets/d0df6968-ba77-476e-ae8a-58148f3cd19c" />

### 2. Verification of Automated Cracking (`tb_Bombe_Emulator`)
We ran the Bombe Emulator against two specific cases to see if it could find the key automatically.

* Case 1 (Immediate Match):
    * Target: 6 ('G'). Correct Key: 0.
    * Result: the machine checked position 0, found a match immediately, and asserted the `finished` signal without stepping.
* **Case 2 (Search Required):**
    * Target: 2 ('C'). Correct Key: 1.
    * Result: The machine checked position 0 (fail), stepped the rotor to position 1, checked again (match), and asserted `finished`.

<img width="1064" height="289" alt="Screenshot 2025-12-05 214224" src="https://github.com/user-attachments/assets/0ff9022f-2c8c-4fbc-8a78-e4f17d2282ec" />

The simulation waveforms confirm that the Controller correctly executes the microcode loop and successfully "cracks" the rotor setting for any valid input pair.
