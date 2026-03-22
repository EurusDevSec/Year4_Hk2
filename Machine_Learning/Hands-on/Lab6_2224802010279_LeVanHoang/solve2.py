import re

filepath = r"r:\_Projects\Eurus_Workspace\Nam4_Hk2\Machine_Learning\Hands-on\Lab6_2224802010279_LeVanHoang\Bai2.md"

with open(filepath, 'r', encoding='utf-8') as f:
    text = f.read()

# Make sure there are two newlines after the answer if followed by a number
# E.g. "**=> Đáp án: a**\n2." -> "**=> Đáp án: a**\n\n2."
new_text = re.sub(r'(\*\*=> Đáp án: [a-z]\*\*)\n+(\d+\.)', r'\1\n\n\2', text)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(new_text)
