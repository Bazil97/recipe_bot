import json
from embedder import embed_recipe, embed_ingredients, cosine_similarity
from generator import suggest_recipe

# Load recipes
with open("data/favorites.json") as f:
    recipes = json.load(f)

# User input 

user_ingredients = input("What ingredients do you have? (comma seperated)\n").split(",")

# Embed and compare

input_vec = embed_ingredients(user_ingredients)
scored = []
for r in recipes:
    recipe_vec = embed_recipe(r)
    score = cosine_similarity(input_vec, recipe_vec)
    scored.append((r, score))

# Get top 1 or 3 
top_recipes = sorted(scored, reverse=True)[:1]
print("\nTop matching favorites:", top_recipes[0][1]["title"])

# Generate suggestion
suggested = suggest_recipe(user_ingredients, top_recipes[0][1])
print("\nHere's a new idea based on that:\n")
print(suggested)