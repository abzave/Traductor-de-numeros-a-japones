# Number to Japanese Name Translator in Assembly

This project is a simple translator that that takes a number and translate it to its japanese name. The goal of the project project is to learn x86 Assembly and the basics of low-level programming.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Requirements](#requirements)
4. [How to Assemble and Run](#how-to-assemble-and-run)
5. [Usage](#usage)

## Project Overview

This translator project makes use of low-level programming to convert numbers into japanese names which will be displayed in the console.

## Features

- **Number Translation**: Converts a given number into its japanese name.
- **Help Menu**: Displays a help menu with run instructions.
- **Simple to Use**: Only needs the number to translate.

## Requirements

- **x86 CPU Architecture**: A CPU compatible with Intel's x86 Architecture.
- **NASM Assembler**: This project is intended to be assembled using the NASM assembler.

## How to Assemble and Run

### Step 1: Clone the repository

``` bash
git clone https://github.com/abzave/Traductor-de-numeros-a-japones.git
cd Traductor-de-numeros-a-japones
```

### Step 2: Assemble the project

``` bash
nasm -f elf 18168174.ASM
ld 18168174.o
```

### Step 3: Run the program

Once assemble, run the executable on the command line.

## Usage

1. Use the `-j` flag along with the number to translate. The translated number will be displayed in the command line.
2. Use the `-h` flag to display the help menu.
