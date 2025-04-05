from sentence_transformers import SentenceTransformer
import numpy as np

model = SentenceTransformer('all-MiniLM-L6-v2')

def embed_recipe(recipe):
    text = " ".join(recipe["ingredients"]) + " " + recipe.get("reason", "")
    return model.encode(text)

def embed_ingredients(ingredients):
    return model.encode(" ".join(ingredients))

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))