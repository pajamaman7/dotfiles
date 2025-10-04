#!/usr/bin/env python3
import re
import sys
import argparse
from typing import List, Dict, Tuple, Optional

def parse_ultisnips(content: str) -> List[Dict]:
    """Parse UltiSnips snippets from file content."""
    snippets = []
    lines = content.split('\n')
    i = 0
    
    while i < len(lines):
        line = lines[i].strip()
        
        # Skip empty lines and comments
        if not line or line.startswith('#'):
            i += 1
            continue
            
        # Handle priority directive
        if line.startswith('priority'):
            priority = int(line.split()[1])
            i += 1
            continue
            
        # Parse snippet definition
        if line.startswith('snippet'):
            parts = line.split(None, 3)
            if len(parts) < 2:
                i += 1
                continue
                
            trigger = parts[1]
            description = parts[2].strip('"') if len(parts) > 2 else ""
            options = parts[3] if len(parts) > 3 else ""
            
            # Parse options
            flags = []
            if 'b' in options:
                flags.append('b')
            if 'i' in options:
                flags.append('i')
            if 'w' in options:
                flags.append('w')
            if 'A' in options:
                flags.append('A')
                
            # Check for context
            context = None
            if i > 0 and lines[i-1].strip().startswith('context'):
                context_line = lines[i-1].strip()
                context_match = re.match(r'context\s+"(.+)"', context_line)
                if context_match:
                    context = context_match.group(1)
            
            # Get snippet body
            body_lines = []
            i += 1
            while i < len(lines) and not lines[i].strip().startswith('endsnippet'):
                body_lines.append(lines[i])
                i += 1
                
            body = '\n'.join(body_lines).rstrip()
            
            snippets.append({
                'trigger': trigger,
                'description': description,
                'flags': flags,
                'context': context,
                'body': body,
                'priority': priority if 'priority' in locals() else None
            })
            
            # Reset priority
            if 'priority' in locals():
                del priority
                
        i += 1
        
    return snippets

def convert_body(body: str) -> str:
    """Convert UltiSnips body to LuaSnip format."""
    # Convert tabstops: $1 -> ${1}, $0 -> ${0}
    body = re.sub(r'\$(\d+)', r'${\1}', body)
    
    # Convert placeholders: ${1:default} -> ${1:default}
    # This is already in the right format
    
    # Convert mirrors: ${1/(pattern)/replacement/} -> ${1/(pattern)/replacement/}
    # This is already in the right format
    
    # Convert python interpolation: `!p ...` -> `lua ...`
    body = re.sub(r'`!p\s+(.*?)`', r'`lua \1`', body)
    
    # Convert visual placeholder: ${VISUAL} -> ${VISUAL}
    # This is already in the right format
    
    return body

def convert_to_luasnip(snippets: List[Dict]) -> str:
    """Convert parsed snippets to LuaSnip format."""
    output = []
    output.append('local ls = require("luasnip")\n')
    output.append('local s = ls.snippet')
    output.append('local t = ls.text_node')
    output.append('local i = ls.insert_node')
    output.append('local f = ls.function_node')
    output.append('local d = ls.dynamic_node')
    output.append('local fmt = require("luasnip.extras.fmt").fmt')
    output.append('local rep = require("luasnip.extras").rep\n')
    
    for snippet in snippets:
        output.append(f'-- {snippet["description"]}')
        
        # Handle context
        opts = []
        if snippet['flags']:
            opts.append(f'wordTrig = {("w" in snippet["flags"])}')
            opts.append(f'regTrig = {("r" in snippet["flags"])}')
            opts.append(f'condition = function() return true end')  # Placeholder for context
        
        if snippet['context']:
            # Convert UltiSnips context to LuaSnip condition
            if snippet['context'] == 'math()':
                opts.append('condition = function() return vim.fn["vimtex#syntax#in_mathzone"]() == 1 end')
        
        opts_str = ', '.join(opts) if opts else ''
        
        # Convert body
        body = convert_body(snippet['body'])
        lines = body.split('\n')
        
        # Simple text snippets
        if not any('$' in line for line in lines) and not any('`' in line for line in lines):
            body_str = '",\n\t\t"'.join(lines)
            output.append(f'ls.add_snippet("{snippet["trigger"]}", {{')
            output.append(f'\ts("{snippet["trigger"]}", {{')
            output.append(f'\t\tt("{body_str}")')
            output.append('\t})' + (f', {{ {opts_str} }}' if opts_str else '') + ')')
        else:
            # Complex snippets with placeholders
            output.append(f'ls.add_snippet("{snippet["trigger"]}", {{')
            output.append(f'\ts("{snippet["trigger"]}", fmt([[')
            
            for line in lines:
                output.append(f'\t\t{line}')
            
            output.append('\t]], {'),
            
            # Extract placeholders
            placeholders = re.findall(r'\$\{(\d+)(?::([^}]*))?\}', body)
            unique_placeholders = sorted(set(int(p[0]) for p in placeholders), key=int)
            
            nodes = []
            for ph in unique_placeholders:
                if ph == '0':
                    nodes.append(f'\t\ti({ph}, "exit")')
                else:
                    # Find default value if any
                    default = next((p[1] for p in placeholders if p[0] == str(ph)), '')
                    nodes.append(f'\t\ti({ph}, "{default}")')
            
            output.append(',\n'.join(nodes))
            output.append('\t})' + (f', {{ {opts_str} }}' if opts_str else '') + ')')
        
        output.append('')
    
    return '\n'.join(output)

def main():
    parser = argparse.ArgumentParser(description='Convert UltiSnips snippets to LuaSnip format')
    parser.add_argument('input_file', help='Input UltiSnips file')
    parser.add_argument('-o', '--output', help='Output LuaSnip file (default: stdout)')
    
    args = parser.parse_args()
    
    try:
        with open(args.input_file, 'r') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: File '{args.input_file}' not found.")
        sys.exit(1)
    
    snippets = parse_ultisnips(content)
    output = convert_to_luasnip(snippets)
    
    if args.output:
        with open(args.output, 'w') as f:
            f.write(output)
    else:
        print(output)

if __name__ == '__main__':
    main()
