from transformers import pipeline

def analyze_sentiment(text):
    # Load the text classification pipeline
    classifier = pipeline("sentiment-analysis")

    # Perform sentiment analysis
    result = classifier(text)

    # Return the result
    return result

def main():
    # Get the file path from the user
    file_path = input("Enter the path to the text file: ")

    try:
        # Open the file and read its contents
        with open(file_path, "r") as file:
            input_text = file.read()

        # Perform sentiment analysis
        result = analyze_sentiment(input_text)

        # Print the result
        print(f"Sentiment: {result[0]['label']} ({result[0]['score']:.2f})")

    except FileNotFoundError:
        print(f"Error: File not found at {file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
