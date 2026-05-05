import fitz  # PyMuPDF
import re
import os

pdf_path = r"C:/Users/VaibhavShah/Downloads/CCA-F_Question_Bank_Expanded.pdf"
doc = fitz.open(pdf_path)

text = ""
for page in doc:
    text += page.get_text("text") + "\n"

# Split raw text by Q<numbers>
questions_raw = re.split(r'(?=Q\d+\s+Domain)', text)

dart_questions = []

for q_raw in questions_raw:
    if not q_raw.strip().startswith('Q'):
        continue
        
    q_match = re.search(r'Q(\d+)', q_raw)
    if not q_match:
        continue
    qid = q_match.group(1)
    
    text_match = re.search(r'Original framing:\s*(.*?)\s*(?:Paraphrases:|Options:)', q_raw, re.DOTALL)
    if not text_match:
        continue
    q_text = text_match.group(1).replace('\n', ' ').replace("'", "\\'").replace('$', '\\$').strip()
    
    options_part_match = re.search(r'Options:\s*(.*?)\s*Correct:', q_raw, re.DOTALL | re.IGNORECASE)
    if not options_part_match:
        continue
        
    options_part = options_part_match.group(1)
    opt_a = re.search(r'A\)\s*(.*?)(?=B\)|$)', options_part, re.DOTALL)
    opt_b = re.search(r'B\)\s*(.*?)(?=C\)|$)', options_part, re.DOTALL)
    opt_c = re.search(r'C\)\s*(.*?)(?=D\)|$)', options_part, re.DOTALL)
    opt_d = re.search(r'D\)\s*(.*?)$', options_part, re.DOTALL)

    if not (opt_a and opt_b and opt_c and opt_d):
        continue
        
    ops = [
        opt_a.group(1).replace('\n', ' ').replace("'", "\\'").replace('$', '\\$').strip(),
        opt_b.group(1).replace('\n', ' ').replace("'", "\\'").replace('$', '\\$').strip(),
        opt_c.group(1).replace('\n', ' ').replace("'", "\\'").replace('$', '\\$').strip(),
        opt_d.group(1).replace('\n', ' ').replace("'", "\\'").replace('$', '\\$').strip()
    ]
    
    ans_match = re.search(r'Correct:\s*([A-D]).*?(.*)', q_raw, re.DOTALL | re.IGNORECASE)
    if not ans_match:
        ans_match = re.search(r'Correct:\s*([A-D]).*?[\-\—](.*)', q_raw, re.DOTALL | re.IGNORECASE)

    if not ans_match:
        continue
        
    correct_letter = ans_match.group(1).strip().upper()
    explanation = ans_match.group(2).replace('\n', ' ').replace("'", "\\'").replace('$', '\\$').strip()
    
    correct_idx = ord(correct_letter) - ord('A')
    
    dart_q = f"""      Question(
        id: 'pdf_q{qid}',
        text: '{q_text}',
        options: [
          '{ops[0]}',
          '{ops[1]}',
          '{ops[2]}',
          '{ops[3]}'
        ],
        correctAnswerIndex: {correct_idx},
        explanation: '{explanation}'
      ),"""
    dart_questions.append(dart_q)

dart_file_content = f"""import '../models/exam.dart';

final List<Exam> pdfMockExams = [
  Exam(
    id: 'pdf_expanded_bank',
    title: 'CCA-F Expanded Question Bank (PDF)',
    description: '141 questions imported directly from the expanded PDF bank, covering all domains.',
    questions: [
{chr(10).join(dart_questions)}
    ]
  )
];
"""

out_path = r"c:\Users\VaibhavShah\Code\cca-f practice exam app\lib\data\pdf_mock_test.dart"
with open(out_path, "w", encoding="utf-8") as f:
    f.write(dart_file_content)

print(f"Successfully generated {len(dart_questions)} questions into {out_path}")
