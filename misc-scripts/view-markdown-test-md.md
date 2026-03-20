# Test Markdown File

This is a test markdown file to verify the viewer works correctly.

## Basic Markdown

This script supports **bold**, *italic*, ~~strikethrough~~ text.

## Lists

- Item 1
- Item 2
  - Nested item
  - Another nested item

1. First
2. Second
3. Third

## Code

Inline `code` looks like this.

```python
def hello_world():
    print("Hello, World!")
    return True
```

```javascript
function greet(name) {
    return `Hello, ${name}!`;
}
```

## Tables

| Feature | Supported |
|---------|-----------|
| GitHub-flavored Markdown | ✅ |
| Syntax Highlighting | ✅ |
| Mermaid Diagrams | ✅ |
| Dark Mode | ✅ |

## Mermaid Diagrams

### Flowchart

```mermaid
graph TD
    A[Start] --> B{Is it working?}
    B -->|Yes| C[Great!]
    B -->|No| D[Debug]
    D --> B
    C --> E[Done]
```

### Sequence Diagram

```mermaid
sequenceDiagram
    participant User
    participant Script
    participant Browser
    User->>Script: Run view-markdown.sh
    Script->>Browser: Open localhost:8080
    Browser->>Script: Fetch markdown
    Script-->>Browser: Return content
    Browser->>Browser: Render with mermaid
```

### State Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing
    Processing --> Done
    Done --> Idle
    Processing --> [*]
```

## Math (optional)

Inline math: $E = mc^2$

Block math:
$$
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$

## Emojis

:rocket: :sparkles: :tada: :100: :heart:

---

Enjoy viewing your markdown files! 🎉
