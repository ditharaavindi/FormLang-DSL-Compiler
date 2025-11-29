
````markdown
# FormLang++ DSL Compiler  
**SE2062 – Programming Paradigms**  
**Student Name:** Manula Cooray  
**Student ID:** IT23194830  

---

## 📌 Project Overview

This project implements a **Domain-Specific Language (DSL)** called **FormLang++**,
which allows users to define structured web forms using a simple, readable syntax. T
he system parses the `.form` files using **Lex and Yacc** and generates styled and validated HTML output.

---

## 📁 Files Included

| File             | Description                                 |
|------------------|---------------------------------------------|
| `parser.y`       | Bison grammar file (parsing + HTML + JS)    |
| `lexer.l`        | Lex file defining tokens and regex rules     |
| `example.form`   | Sample DSL input with full feature coverage |
| `output.html`    | HTML form generated from `example.form`     |
| `grammer.pdf`    | EBNF grammar specification (DSL syntax)     |
| `Makefile`       | Automates the build process                 |
| `formgen`        | Compiled parser executable                  |

---

## ⚙️ How to Build and Run

### 1. Compile using `make`
```bash
make
````

### 2. Generate HTML output

```bash
./formgen < example.form > output.html
```

### 3. Open the form

Open `output.html` in any browser to view the styled form with live validation.

---

## ✅ Features Implemented

* All **field types**: text, number, email, password, checkbox, dropdown, radio, textarea, file, date
* **Required and optional attributes** (min, max, pattern, default, accept, etc.)
* **Form metadata** (e.g., author)
* **Validation block** with JavaScript alerts
* **Styled HTML output** with semantic labels
* **Readable EBNF Grammar** (see `grammer.pdf`)

---

## 🎥 Demo Instructions

Run `formgen` on `example.form`, open the output HTML, and try:

* Submitting invalid data (e.g., age < 18, empty password)
* Submitting a valid form

---

## 🧾 Notes

* Built and tested using **Lex** and **Bison** on WSL Ubuntu.
* This project is part of the take-home assignment for SE2062 – Programming Paradigms.

```

