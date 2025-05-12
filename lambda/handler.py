import json
import os
import logging
from openai import OpenAI

# Setup logging to CloudWatch
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Get the OpenAI key from environment variable
client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    try:
        # Parse ingredients from the event body
        if "body" in event:
            body = json.loads(event["body"])
        else:
            body = event

        ingredients = body.get("ingredients")

        if not ingredients or not isinstance(ingredients, list):
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing or invalid 'ingredients' list"})
            }

        logger.info("Ingredients received: %s", ingredients)

        # Construct prompt
        prompt = (
            f"You are a creative home-cooking assistant. The user has the following ingredients:\n"
            f"{', '.join(ingredients)}.\n"
            f"Based on common preferences for hearty, tasty meals, suggest one recipe they could make "
            f"that uses most of those ingredients. Format the result as:\n\n"
            f"Title: <recipe name>\n\nIngredients:\n- <ingredient 1>\n- <ingredient 2>\n\n"
            f"Instructions:\n1. <step 1>\n2. <step 2>\n"
        )

        logger.info("Sending prompt to OpenAI...")

        response = client.chat.completions.create(
            model="gpt-4",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.7,
        )

        recipe_text = response.choices[0].message["content"]
        logger.info("Recipe received from OpenAI.")

        return {
            "statusCode": 200,
            "body": json.dumps({"recipe": recipe_text})
        }

    except Exception as e:
        logger.error("Error processing recipe request: %s", str(e))
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Internal server error"})
        }