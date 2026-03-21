# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Verilog practice projects targeting **Cyclone IV GX** FPGA, built with **Quartus II 13.1 Web Edition** and simulated with **ModelSim-Altera**.

## Architecture

Each circuit is a self-contained Quartus project in its own directory with `.qpf`/`.qsf`/`.v` files. Modules build on each other hierarchically:

- `half_adder` → `full_adder` (instantiates 2x half_adder) → `ripple_carry_adder` (instantiates 4x full_adder)

Higher-level modules reference lower-level ones via Verilog instantiation (not Quartus IP). When a module depends on another, the dependency's `.v` file must be added to the project's `.qsf`.

## Conventions

- Port naming: `_i` suffix for inputs, `_o` suffix for outputs, `_w` suffix for internal wires
- Instance naming: `u_` prefix (e.g., `u_ha0`, `u_fa1`)
- Waveform files (`.vwf`) are version-controlled for test reproducibility

## Simulation

Simulation uses Quartus Vector Waveform Files (`.vwf`) via the built-in **qsim** flow (not standalone ModelSim). Waveform tests are defined in the Quartus GUI.

## Editor Theme

`quartus2_vscode_dark_theme.ini` contains a VS Code Dark+ color scheme for the Quartus text editor. See the file header for installation instructions (modify `quartus2.qreg`).
