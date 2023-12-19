import difflib

def compare_files(file1_path, file2_path):
    # Read the contents of the files
    with open(file1_path, 'r') as file1:
        file1_content = file1.readlines()

    with open(file2_path, 'r') as file2:
        file2_content = file2.readlines()

    # Create a Differ object
    differ = difflib.Differ()

    # Compare the files
    diff = list(differ.compare(file1_content, file2_content))
    line_indices = [i + 1 for i, line in enumerate(diff) if line.startswith('-') or line.startswith('+')]

    # Print or return the differences
    return diff, line_indices