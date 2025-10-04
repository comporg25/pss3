# Lab: Find the Largest Value (General Addressing Mode → Optimized)

## Goal

Write an x86-64 Linux assembly program that scans an array of 64-bit integers and **returns the largest element**. First implement it using **general addressing mode with an index register**; then implement an **optimized** version that walks the array from the end while using the loop counter directly as the index.

---

## Data (provided in your program)

* `numberofnumbers` — 64-bit count of elements (here: `7`)
* `mynumbers` — 7 quadwords: `5, 20, 33, 80, 52, 10, 1`

* Data (put this in your program’s `.data` section)

```asm
        .section .data
numberofnumbers:
        .quad 7
mynumbers:
        .quad 5, 20, 33, 80, 52, 10, 1
```

> With this data, the largest value is **80** → expected exit status: **80**.

---

## Part A — Baseline (General Addressing Mode)

**Requirements**

* Load the element count into **`%rcx`**.
* Use **`%rbx` as an index** starting at `0`.
* Keep the **current maximum in `%rdi`** (initialize to 0).
* Access elements with **general addressing mode** using **index scaling**:

  * Address form: `mynumbers(,%rbx,8)` (base omitted, index `%rbx`, scale 8).
* Loop until all elements are processed:

  1. Load `mynumbers[%rbx]` into `%rax`.
  2. If `%rax` > `%rdi`, update `%rdi`.
  3. Increment `%rbx` (next index).
  4. Decrement `%rcx` and continue while not zero.
* **Exit** via `sys_exit` with the largest value in **`%rdi`** (shell sees it mod 256).

**Learning focus**

* SIB addressing: `disp(base, index, scale)`
* Separating **loop counter** (`%rcx`) from **array index** (`%rbx`)
* Conditional updates using `cmp`/`jbe` (unsigned) or `cmp`/`jle` (signed) as appropriate

---

## Part B — Optimized Version

**Requirements**

* Use **only `%rcx`** as both the **counter** and the **(reverse) index**.
* Iterate **backwards** from the end of the array using:

  * Address form: `mynumbers-8(,%rcx,8)` (so when `%rcx==1` you read the last element).
* Keep the current maximum in `%rdi` as before.
* Each iteration:

  1. Load the next element with `mynumbers-8(,%rcx,8)` into `%rax`.
  2. Update `%rdi` if larger.
  3. Use `loopq` (which decrements `%rcx` and jumps if not zero) to continue.
* **Exit** with `%rdi` as the status.

**Why it’s better**

* Eliminates a separate index register and an extra increment.
* Uses the loop counter directly to index memory (one fewer instruction per iteration).

---

## Build & Run (example)

```bash
as -o largest.o largest.s
ld -o largest largest.o
./largest
echo $?
```

---
