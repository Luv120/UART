# UART Transmitter & Receiver using Verilog

## Overview
Designed an 8-bit UART (Universal Asynchronous Receiver/Transmitter) communication system using Verilog HDL. The project consists of independent transmitter and receiver modules implemented using Finite State Machines (FSMs).

## Features
- 8-bit parallel-to-serial transmission and serial-to-parallel reception.
- Configurable baud-rate generation using clock counters.
- Even parity generation and checking for basic error detection.
- 1 start bit, 8 data bits, 1 parity bit and 1 stop bit.
- LSB-first data transmission.
- Start-bit validation using half-bit-period sampling in the receiver.

## FSM Architecture
Both transmitter and receiver use five states:
- **IDLE:** Waits for transmission or incoming data.
- **START:** Handles start-bit detection/transmission.
- **DATA:** Processes 8 data bits.
- **PARITY:** Generates or checks the parity bit.
- **STOP:** Handles the stop bit and completes the frame.

## UART Frame Format
`START (0) → DATA (8 bits) → PARITY → STOP (1)`

## Tools & Technologies
- Verilog HDL
- Icarus Verilog
- GTKWave
