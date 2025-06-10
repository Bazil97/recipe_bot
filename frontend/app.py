import streamlit as st
import requests

api_url = "https://epa48ls9j4.execute-api.eu-west-2.amazonaws.com/recipe"  # Replace with your FastAPI URL

st.title("Recipe Bot")
st.write("Entre ingredients seperated by commas:")

user_input = st.text_input("Ingredients","onion, garlic, tomato")

if st.button("Get Recipe"):
    ingredients = [ingredient.strip() for ingredient in user_input.split(",") if ingredient.strip()]
    # Call the FastAPI endpoint
    response = requests.post(api_url, json={"ingredients": ingredients})
    
    if response.status_code == 200:
        recipe = response.json().get("recipe", "No recipe found.")
        st.text_area("Recipe", recipe, height=300)
    else:
        st.write("Error:", response.status_code, response.text)