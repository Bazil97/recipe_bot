import openai
import os 

openai.api_key = os.getenv("OPENAI_API_KEY")

def suggest_recipe(ingredients, base_recipe):
    prompt = f"""You're a creative recipe bot. The user has the following ingredients {ingredients}. They love the recipe: {base_recipe['title']} which includes {base_recipe['ingredients']}, and is liked because: {base_recipe.get('reason', '')}.
                Suggest a new recipe they can make with their ingredients, in a similar style"""
    response = openai.Completion.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7,
    )
    return response.choices[0]["message"]["content"]