from openai import OpenAI

# My Key
client = OpenAI(api_key="#EnterKeyHere")


message = input("Enter Input: ")


# Create a new session
session = client.chat.completions.create(
    model="gpt-3.5-turbo",
    messages=[{
        "role": "user",
        "content": message
        },
        #
        {
        }]
)

response = session.choices[1].message.content

print(response)
