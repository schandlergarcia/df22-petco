import json

from salesforce_functions import Context, InvocationEvent
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from nltk.tokenize.punkt import PunktSentenceTokenizer

tokenizer = PunktSentenceTokenizer()
analyzer = SentimentIntensityAnalyzer()


async def function(event: InvocationEvent[dict[str, str]], context: Context):
    results = list()

    record_id = event.data.get('Id')
    tweet_id = event.data.get('Tweet_Id__c')
    text = event.data.get('Text__c')
    print(f'Calculating sentiment for tweet {tweet_id} (Id: {record_id})')

    for (start, end) in tokenizer.span_tokenize(text):
        sentence = text[start:end]
        sentiment = analyzer.polarity_scores(sentence)['compound']
        print(f'  analyzing: {sentence} ([{start}:{end}] = {sentiment})')
        results.append({
            'Tweet__c': record_id,
            'Start__c': start,
            'End__c': end,
            'Sentiment__c': sentiment
        })

    print(f'  returning: {json.dumps(results)}')
    return results
