#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
TEMP_DIR=""
SERVER_PID=""

cleanup() {
    if [[ -n "$SERVER_PID" ]]; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
    fi
    if [[ -n "$TEMP_DIR" ]] && [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

trap cleanup EXIT INT TERM

usage() {
    cat << EOF
Usage: $SCRIPT_NAME <markdown-file>

View a Markdown file in your browser with GitHub-style formatting and Mermaid diagram support.

Arguments:
    markdown-file    Path to the Markdown file to view

Examples:
    $SCRIPT_NAME README.md
    $SCRIPT_NAME docs/architecture.md
    $SCRIPT_NAME ~/notes/project-plan.md
EOF
    exit 1
}

if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    usage
fi

MD_FILE="$1"

if [[ ! -f "$MD_FILE" ]]; then
    echo "Error: File '$MD_FILE' not found" >&2
    exit 1
fi

if [[ "${MD_FILE##*.}" != "md" ]] && [[ "${MD_FILE##*.}" != "markdown" ]]; then
    echo "Warning: '$MD_FILE' does not appear to be a markdown file" >&2
fi

MD_FILE_ABS=$(realpath "$MD_FILE")
TEMP_DIR=$(mktemp -d)
HTML_FILE="$TEMP_DIR/viewer.html"
PORT=8080

cat > "$HTML_FILE" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Markdown Viewer</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.3.0/github-markdown.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css" id="hljs-dark">
    
    <style>
        :root {
            --bg-color-light: #ffffff;
            --text-color-light: #24292f;
            --bg-color-dark: #0d1117;
            --text-color-dark: #c9d1d9;
        }
        
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
            transition: background-color 0.3s, color 0.3s;
        }
        
        body.light {
            background-color: var(--bg-color-light);
            color: var(--text-color-light);
        }
        
        body.dark {
            background-color: var(--bg-color-dark);
            color: var(--text-color-dark);
        }
        
        .container {
            max-width: 980px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .markdown-body {
            box-sizing: border-box;
            min-width: 200px;
            max-width: 980px;
            margin: 0 auto;
            padding: 45px;
        }
        
        .theme-toggle {
            position: fixed;
            top: 1rem;
            right: 1rem;
            padding: 0.5rem 1rem;
            background: #0969da;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            z-index: 1000;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        
        .theme-toggle:hover {
            background: #0955ba;
        }
        
        body.dark .theme-toggle {
            background: #238636;
        }
        
        body.dark .theme-toggle:hover {
            background: #2ea043;
        }
        
        .mermaid {
            background: transparent !important;
            padding: 1rem;
            border-radius: 6px;
            margin: 1rem 0;
        }
        
        pre code {
            border-radius: 6px;
        }
        
        #loading {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-size: 1.2rem;
            color: #58a6ff;
        }
        
        #content {
            display: none;
        }
        
        body.dark #hljs-light {
            display: none;
        }
        
        body.light #hljs-dark {
            display: none;
        }
    </style>
</head>
<body class="light">
    <button class="theme-toggle" onclick="toggleTheme()">🌙 Dark Mode</button>
    
    <div id="loading">Loading markdown...</div>
    <div id="content" class="container">
        <div class="markdown-body"></div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/9.1.6/marked.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/11.6.0/mermaid.min.js"></script>
    
    <script>
        const currentPath = window.location.pathname;
        const mdPath = currentPath.replace('/viewer.html', '') + '/MARKDOWN_CONTENT.md';
        
        let isDark = false;
        
        function toggleTheme() {
            isDark = !isDark;
            document.body.className = isDark ? 'dark' : 'light';
            document.querySelector('.theme-toggle').textContent = isDark ? '☀️ Light Mode' : '🌙 Dark Mode';
            
            if (window.mermaid) {
                mermaid.initialize({
                    startOnLoad: false,
                    theme: isDark ? 'dark' : 'default',
                    securityLevel: 'loose',
                });
                mermaid.init(undefined, '.mermaid');
            }
        }
        
        function detectSystemTheme() {
            if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
                isDark = true;
                document.body.className = 'dark';
                document.querySelector('.theme-toggle').textContent = '☀️ Light Mode';
            }
        }
        
        async function loadMarkdown() {
            try {
                const response = await fetch(mdPath);
                if (!response.ok) throw new Error('Failed to load markdown file');
                const markdown = await response.text();
                
                marked.setOptions({
                    highlight: function(code, lang) {
                        if (lang && hljs.getLanguage(lang)) {
                            try {
                                return hljs.highlight(code, { language: lang }).value;
                            } catch (e) {}
                        }
                        return hljs.highlightAuto(code).value;
                    },
                    breaks: true,
                    gfm: true
                });
                
                const html = marked.parse(markdown);
                document.querySelector('.markdown-body').innerHTML = html;
                
                document.getElementById('loading').style.display = 'none';
                document.getElementById('content').style.display = 'block';
                
                if (window.mermaid) {
                    mermaid.initialize({
                        startOnLoad: false,
                        theme: isDark ? 'dark' : 'default',
                        securityLevel: 'loose',
                    });
                    
                    const mermaidBlocks = document.querySelectorAll('pre code.language-mermaid');
                    mermaidBlocks.forEach((block) => {
                        const pre = block.parentElement;
                        const code = block.textContent;
                        const wrapper = document.createElement('div');
                        wrapper.className = 'mermaid';
                        wrapper.textContent = code;
                        pre.replaceWith(wrapper);
                    });
                    
                    mermaid.init(undefined, '.mermaid');
                }
                
                hljs.highlightAll();
            } catch (error) {
                document.getElementById('loading').textContent = 'Error: ' + error.message;
            }
        }
        
        detectSystemTheme();
        loadMarkdown();
    </script>
</body>
</html>
HTMLEOF

cp "$MD_FILE_ABS" "$TEMP_DIR/MARKDOWN_CONTENT.md"

cd "$TEMP_DIR"

if command -v python3 &>/dev/null; then
    python3 -m http.server $PORT > /dev/null 2>&1 &
    SERVER_PID=$!
elif command -v python &>/dev/null; then
    python -m SimpleHTTPServer $PORT > /dev/null 2>&1 &
    SERVER_PID=$!
else
    echo "Error: Python 2 or 3 is required to run the local server" >&2
    cleanup
    exit 1
fi

sleep 2

if ! ps -p $SERVER_PID > /dev/null; then
    echo "Error: Failed to start local server" >&2
    cleanup
    exit 1
fi

if command -v xdg-open &>/dev/null; then
    xdg-open "http://localhost:$PORT/viewer.html" &>/dev/null &
elif command -v open &>/dev/null; then
    open "http://localhost:$PORT/viewer.html" &>/dev/null &
elif command -v start &>/dev/null; then
    start "http://localhost:$PORT/viewer.html" &>/dev/null &
else
    echo "Browser opened at: http://localhost:$PORT/viewer.html"
fi

echo "✓ Markdown viewer started at http://localhost:$PORT/viewer.html"
echo "  File: $MD_FILE"
echo "  Press Ctrl+C to stop the server"

wait $SERVER_PID 2>/dev/null || true
