from ibm_watson import SpeechToTextV1
from os.path import join, dirname
import json

speech_to_text = SpeechToTextV1(
    iam_apikey='PUfqdSXO-sKGCShdkJ_SX55gY35bm42s-aZqbbksSQUP',
    url='https://gateway-lon.watsonplatform.net/speech-to-text/api'
)

with open(join(dirname(__file__), './.', 'audio-file2.flac'),
               'rb') as audio_file:
    speech_recognition_results = speech_to_text.recognize(
        audio=audio_file,
        content_type='audio/flac',
        word_alternatives_threshold=0.9,
        keywords=['colorado', 'tornado', 'tornadoes'],
        keywords_threshold=0.5
    ).get_result()
print(json.dumps(speech_recognition_results, indent=2))
#print(speech_recognition_results['results'][0]['alternatives'][0]['transcript'])
