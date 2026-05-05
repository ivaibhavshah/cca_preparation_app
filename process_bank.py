import json
import random

phrases = [
    'This approach represents a different methodology.',
    'While possible, this differs from the primary objective.',
    'This setup might be utilized under alternative conditions.',
    'This choice represents an alternative configuration.',
    'This method may be considered in different scenarios.',
    'This strategy applies when different constraints are present.',
    'This is a common pattern in other specific contexts.',
    'Such an approach is typically reserved for distinct use cases.',
    'This configuration is generally applied under varying requirements.',
    'This solution might be chosen if different trade-offs were acceptable.'
]

def escape_dart_str(s):
    # Escape backslashes, single quotes, and dollar signs
    s = s.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$')
    # Escape actual newlines
    s = s.replace('\n', '\\n').replace('\r', '')
    return "'" + s + "'"

with open('bank.json', 'r', encoding='utf-8') as f:
    bank = json.load(f)

domains = {1: [], 2: [], 3: [], 4: [], 5: []}

for q in bank:
    d = q['d']
    opts = q['o']
    c_idx = q['c']
    
    if c_idx >= len(opts):
        c_idx = 0
        
    max_words = max(len(o.split()) for o in opts)
    
    padded_opts = []
    for j, o in enumerate(opts):
        padded_o = o
        while len(padded_o.split()) < max_words:
            padded_o += ' ' + random.choice(phrases)
        padded_opts.append(padded_o)
        
    opts_str = ',\n        '.join(escape_dart_str(o) for o in padded_opts)
    
    dart_q = f"""
    Question(
      id: 'scraped_{q['id']}',
      text: {escape_dart_str(q['q'])},
      options: [
        {opts_str}
      ],
      correctAnswerIndex: {c_idx},
      explanation: {escape_dart_str(q.get('e', ''))},
    )"""
    if d in domains:
        domains[d].append(dart_q)
    else:
        print(f"Unknown domain {d}")

with open('lib/data/scraped_questions.dart', 'w', encoding='utf-8') as f:
    f.write("import '../models/exam.dart';\n\n")
    for d in sorted(domains.keys()):
        f.write(f'final List<Question> scrapedDomain{d}Questions = [\n')
        f.write(','.join(domains[d]))
        f.write('\n];\n\n')

print("Successfully generated lib/data/scraped_questions.dart")
