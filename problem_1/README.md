# Lab: Uppercase Letters & Print Line-by-Line (x86-64, Linux)

## Goal

Write an x86-64 assembly program that:

1. **Reads bytes from standard input** until EOF.
2. **Converts only alphabetic letters** (`a–z` and `A–Z`) to **UPPERCASE**.

   * Non-letters (digits, spaces, punctuation, symbols) must be **left unchanged**.
3. **Outputs each processed byte followed by a newline** (`'\n'`), i.e., **one character per line**.

---

## File to Create

* `upperlines.s` (use AT&T syntax, GNU `as`)

---

## Hints & Rules

* Use Linux syscalls:

  * `read`  → `rax=0`, `rdi=0` (stdin), `rsi=buf`, `rdx=count` → returns bytes read in `rax`
  * `write` → `rax=1`, `rdi=1` (stdout), `rsi=buf`, `rdx=count`
  * `exit`  → `rax=60`, `rdi=status`
* Process **one byte at a time** (or read a small block and loop over its bytes).
* ASCII checks:

  * If `'a'(97) ≤ c ≤ 'z'(122)`, convert to uppercase: **subtract 32**.
  * If `'A'(65) ≤ c ≤ 'Z'(90)`, keep as is.
  * Otherwise, leave unchanged.
* After conversion, **print the byte and a newline** (2 bytes total per character).
* Stop on **EOF** (i.e., when `read` returns **0**).

---

## Example I/O

**Input**

```
Hello, World! 123
```

**Output**

```
H
E
L
L
O
,
 
W
O
R
L
D
!
 
1
2
3
```

**Input**

```
abc-XYZ_?
```

**Output**

```
A
B
C
-
X
Y
Z
_
?
```

---

## Build & Run (example)

```bash
as -o upperlines.o upperlines.s
ld -o upperlines upperlines.o
./upperlines
# type some text, then press Ctrl-D (EOF) to finish
```

---
