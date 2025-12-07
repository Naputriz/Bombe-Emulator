# Final Project PSD - Bombe Emulator

## Project Overview

This project implements a fully functional **Bombe Machine Emulator** on FPGA using VHDL. The Bombe was an electromechanical device used by British cryptologists during WWII to break the German Enigma cipher.

Unlike a standard Enigma simulator that encrypts text, this Bombe Emulator performs a **Brute-Force Attack**. It takes a known "Crib" (a Plaintext-Ciphertext pair) and automatically searches through rotor positions to find the correct "Key" (Start Position) that generated that encryption.

## Key Features 

* **Fully Reciprocal Scrambler:** Implements the accurate double-ended signal path of the Enigma M3.
* **Configurable Rotors:** Supports dynamic selection of **Rotor I, II, and III** with accurate historical wiring.
* **Configurable Reflectors:** Supports **UKW-A, UKW-B, and UKW-C** standards.
* **Plugboard (Steckerbrett):** Includes a physical layer permutation stage at the input and output.
* **Multi-Rotor Stepping:** The Controller implements the "Odometer" logic, allowing the machine to step through Rotor 1, Rotor 2, and Rotor 3 automatically to find keys in deeper search spaces.
* **Microprogrammed Controller:** Uses a custom opcode set stored in ROM to control the search algorithm.

## System Architecture

The design is modular, consisting of five main components:

1.  **Instruction ROM:** Stores the microcode (Opcodes) for the search logic.
2.  **Controller:** A Finite State Machine (FSM) that fetches instructions, manages the "Odometer" stepping logic for 3 rotors, and monitors the success signal.
3.  **Scrambler:** The core cryptographic unit.
    * **Path:** `Plugboard` $\rightarrow$ `Rotor 1` $\rightarrow$ `Rotor 2` $\rightarrow$ `Rotor 3` $\rightarrow$ `Reflector` $\rightarrow$ `InvRotor 3` $\rightarrow$ `InvRotor 2` $\rightarrow$ `InvRotor 1` $\rightarrow$ `Plugboard`.
4.  **Plugboard:** Performs predefined letter swapping (e.g., A$\leftrightarrow$Z) before and after the rotor stages.
5.  **Comparator:** Compares the Scrambler's output with the target ciphertext. If they match, it signals the Controller to stop.

## How It Works (The Algorithm)

1.  **Setup:** The user configures the Rotor Types (e.g., I-II-III) and Reflector Type (e.g., UKW-B).
2.  **Input:** The user provides a known pair: `char_in` (Plaintext) and `target_in` (Ciphertext).
3.  **Search Loop:**
    * The Controller sets the rotors to position `0-0-0`.
    * The Scrambler encrypts `char_in`.
    * **Check:** Does Output == `target_in`?
        * **YES:** Assert `finished` signal. Output the current rotor positions (`found_r1`, `found_r2`, `found_r3`). STOP.
        * **NO:** Step the rotors (+1). If Rotor 1 wraps around, step Rotor 2, etc. Repeat loop.

## Testing & Results

The system was verified using two testbenches to validate both the cryptographic physics and the automated cracking capability.

### 1. Verification of Encryption & Reciprocity (`tb_Enigma_Sentence`)
Before cracking, we verified that the Scrambler behaves like a real Enigma machine.
* **Reciprocity Test:** We proved that if Input `A` encrypts to `B`, then Input `B` must encrypt back to `A` using the same settings.
* **Golden Data Generation:** We used this testbench to generate valid "Cribs" (Target numbers) to test the Bombe.

> **Output:** The log and waveform below shows a successful reciprocal test.
<img width="1074" height="220" alt="image" src="https://github.com/user-attachments/assets/ad6b296a-c47c-4b87-abeb-ebaebc49b6a3" />
<img width="1110" height="203" alt="image" src="https://github.com/user-attachments/assets/38b26d36-4800-49a7-a292-8af846c6a743" />

### 2. Verification of Automated Cracking (`tb_Bombe_Emulator`)
We ran the Bombe Emulator against two scenarios to prove it can find keys dynamically.

* **Scenario 1:**
    * **Target:** `1` (Derived from `tb_Enigma_Sentence` for Position 0).
    * **Expected Key:** Position 0.
    * **Result:** The `done` signal goes High immediately. `result_r1` shows `0`.
* **Scenario 2:**
    * **Target:** `19` (Derived from `tb_Enigma_Sentence` for Position 1).
    * **Expected Key:** Position 1.
    * **Result:** The machine steps the rotor once, finds the match, and `done` goes High. `result_r1` shows `1`.

**Waveform Result:**
The waveform below demonstrates the Controller iterating through positions. Notice how `result_r1` updates to the correct key when `done` becomes active (High).
<img width="1060" height="425" alt="image" src="https://github.com/user-attachments/assets/601722ac-6797-4727-b427-243b858c17cb" />

**Console Log Result:**
The simulation console confirms the successful capture of the keys.
<img width="1106" height="167" alt="image" src="https://github.com/user-attachments/assets/b546d00a-c7f9-47cf-be56-26f733452d7d" />
