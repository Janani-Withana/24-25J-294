# test_generate_refined.py
from rag_qa import generate_refined_answer

# Define test inputs
test_query = "How do I improve my crop yield?"
test_retrieved_answer = "You should optimize your irrigation system and use quality seeds."

# Call the function
refined_answer = generate_refined_answer(test_query, test_retrieved_answer)

print("Refined Answer:", refined_answer)
