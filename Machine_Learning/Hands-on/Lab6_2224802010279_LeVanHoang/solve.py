import re

answers = {
    1: 'a', 2: 'c', 3: 'c', 4: 'd', 5: 'b',
    6: 'd', 7: 'd', 8: 'a', 9: 'a', 10: 'a',
    11: 'c', 12: 'd', 13: 'a', 14: 'e', 15: 'a',
    16: 'b', 17: 'd', 18: 'b', 19: 'c', 20: 'b',
    21: 'd', 22: 'b', 23: 'a', 24: 'd', 25: 'a',
    26: 'a', 27: 'b', 28: 'a', 29: 'c', 30: 'd',
    31: 'b', 32: 'c', 33: 'a', 34: 'c', 35: 'a',
    36: 'd', 37: 'd', 38: 'a', 39: 'd', 40: 'c',
    41: 'b', 42: 'b', 43: 'c', 44: 'a', 45: 'c',
    46: 'd', 47: 'b', 48: 'a', 49: 'd', 50: 'd',
    51: 'a', 52: 'b', 53: 'c', 54: 'b', 55: 'd',
    56: 'a', 57: 'c', 58: 'c', 59: 'c', 60: 'a',
    61: 'c', 62: 'b', 63: 'a', 64: 'd', 65: 'a',
    66: 'a', 67: 'a', 68: 'b', 69: 'a', 70: 'a',
    71: 'b', 72: 'd', 73: 'c', 74: 'c', 75: 'b',
    76: 'b', 77: 'd', 78: 'b', 79: 'c', 80: 'a',
    81: 'b', 82: 'b', 83: 'a', 84: 'd', 85: 'b',
    86: 'a', 87: 'd', 88: 'a', 89: 'd', 90: 'a',
    91: 'd', 92: 'b', 93: 'c', 94: 'b', 95: 'd'
}

filepath = r"r:\_Projects\Eurus_Workspace\Nam4_Hk2\Machine_Learning\Hands-on\Lab6_2224802010279_LeVanHoang\Bai2.md"

with open(filepath, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []
current_q = None

question_pattern = re.compile(r'^(\d+)\.\s')

for line in lines:
    m = question_pattern.match(line)
    if m:
        # If we had a previous question, we should append the answer right before starting the new question.
        if current_q is not None:
            # backtrack in new_lines to find the end of the previous question
            # insert before any trailing blank lines
            insert_idx = len(new_lines)
            while insert_idx > 0 and new_lines[insert_idx-1].strip() == '':
                insert_idx -= 1
            new_lines.insert(insert_idx, f"\n**=> Đáp án: {answers.get(current_q, '?')}**\n")
        
        current_q = int(m.group(1))
    new_lines.append(line)

# handle the last question
if current_q is not None:
    # insert before ./. or end
    insert_idx = len(new_lines)
    while insert_idx > 0 and (new_lines[insert_idx-1].strip() == '' or './.' in new_lines[insert_idx-1]):
        insert_idx -= 1
    new_lines.insert(insert_idx, f"\n**=> Đáp án: {answers.get(current_q, '?')}**\n")

with open(filepath, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)
