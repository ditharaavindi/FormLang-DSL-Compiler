# FormLang++ DSL Compiler

## 📌 Project Overview

This project implements a **Domain-Specific Language (DSL)** called **FormLang++**, which allows users to define structured web forms using a simple, readable syntax. The system parses `.form` files using **Lex and Yacc** and generates styled and validated HTML output.

## 📁 Project Structure

| File               | Description                                 |
| ------------------ | ------------------------------------------- |
| `parser.y`         | Bison grammar file (parsing + HTML + JS)    |
| `lexer.l`          | Lex file defining tokens and regex rules    |
| `example.form`     | Sample DSL input with full feature coverage |
| `output.html`      | Generated HTML form from `example.form`     |
| `EBNF_Grammer.pdf` | EBNF grammar specification (DSL syntax)     |
| `Makefile`         | Automates the build process                 |
| `formgen`          | Compiled parser executable                  |
| `lex.yy.c`         | Generated lexical analyzer C code           |
| `parser.tab.c`     | Generated parser C code                     |
| `parser.tab.h`     | Generated parser header file                |

## 🚀 Quick Start

### Prerequisites

- Lex/Flex
- Yacc/Bison
- GCC compiler
- Make utility

### Build and Run

1. **Compile the project:**

```bash
make
```

2. **Generate HTML from DSL input:**

```bash
./formgen < example.form > output.html
```

3. **View the generated form:**

```bash
open output.html  # macOS
# or
xdg-open output.html  # Linux
# or simply open the file in your browser
```

## ✨ Features

### Supported Field Types

- **Text fields**: text, email, password
- **Numeric fields**: number, date
- **Selection fields**: checkbox, dropdown, radio buttons
- **Content fields**: textarea, file upload

### Field Attributes

- **Validation**: required, min/max values, pattern matching
- **Defaults**: default values for fields
- **Constraints**: file type restrictions (accept attribute)
- **Metadata**: labels, placeholders, and descriptions

### Advanced Features

- **Form metadata**: Author information and form properties
- **Client-side validation**: JavaScript validation with user feedback
- **Styled output**: Semantic HTML with CSS styling
- **Error handling**: Comprehensive error reporting during parsing

## 🔧 Development

### Grammar Specification

The DSL grammar is formally defined in `EBNF_Grammer.pdf`. The grammar supports:

- Form declarations with metadata
- Field definitions with various types and attributes
- Validation rules and constraints

### Architecture

- **Lexical Analysis**: `lexer.l` defines tokens and patterns
- **Syntax Analysis**: `parser.y` implements the grammar and generates HTML
- **Code Generation**: Integrated HTML and JavaScript generation

## 📝 Example Usage

See `example.form` for a comprehensive example that demonstrates:

- All supported field types
- Validation rules
- Form metadata
- Complex form structures

## 🧪 Testing

To test the compiler:

1. Create a `.form` file with your DSL code
2. Run: `./formgen < your-file.form > output.html`
3. Open the generated HTML in a browser
4. Test form validation and submission

## 📚 Academic Context

This project is part of the **SE2062 – Programming Paradigms** course, demonstrating:

- Compiler construction principles
- Domain-Specific Language design
- Lexical and syntax analysis
- Code generation techniques

---

**Built and tested using Lex/Flex and Yacc/Bison**

```

```
