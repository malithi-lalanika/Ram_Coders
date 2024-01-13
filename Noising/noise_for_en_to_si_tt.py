import torch
# GPUtil.getAvailable()
use_cuda = torch.cuda.is_available()
print(use_cuda)

device = torch.device("cuda:0" if use_cuda else "cpu")
print(device)

from googletrans import Translator
translator = Translator()

from ai4bharat.transliteration import XlitEngine
e = XlitEngine(src_script_type="indic", beam_width=10, rescore=False)

from datasets import load_dataset, load_metric,Dataset,dataset_dict
from transformers import AutoModelForTokenClassification, TrainingArguments, Trainer
from transformers import DataCollatorForTokenClassification
import pandas as pd
import transformers
import numpy as np
from sklearn.model_selection import KFold

model_checkpoint ="/userdirs/ram_coders/noising/models/xlm-roberta-base-sinhala-english-tamil-mixed"

from transformers import AutoModelForMaskedLM ,AutoModelWithHeads
from transformers import AutoTokenizer, AutoModelWithHeads

tokenizer = AutoTokenizer.from_pretrained(model_checkpoint)

label_list=['O', 'B-PER', 'I-PER', 'B-ORG', 'I-ORG', 'B-LOC', 'I-LOC', 'B-MISC', 'I-MISC']

model = AutoModelForTokenClassification.from_pretrained(model_checkpoint, num_labels=len(label_list))

trainer = Trainer(model=model)
trainer.model = model.cuda()  #if GPU available uncomment this one


# Pywikibot needs a config file
pywikibot_config = r"""# -*- coding: utf-8  -*-


mylang = 'en'
family = 'wikipedia'
usernames['wikipedia']['en'] = 'test'"""

with open('user-config.py', 'w', encoding="utf-8") as f:
    f.write(pywikibot_config)
    

import pywikibot

import pandas as pd
import numpy as np
import copy

#add number of raws
index=[i for i in range(0,180808)]
path="/userdirs/ram_coders/noising/en_to_si/blog_data.txt"

f1 = open(path, encoding="utf8")
tokens=[]
sentences=[]
Lines = f1.readlines()
for line in Lines:
  #print(line)  #1
    if (line.isupper() or line.islower()):
        #print("en",line)
        pass
    else:
        #print("si",line)
        sentences.append(line.strip()) #1
        tokens.append(line.split())  #1
df=pd.DataFrame({'tokens':tokens,'sentences':sentences})

p = {}

# Vowel sounds - short (with ZWSP u'\u200B')  
# p['අ'] = '﻿a'  
# p['ආ'] = '﻿aa' 
# p['ඇ'] = '﻿A'
# p['ඈ'] = '﻿Aa'
# p['ඉ'] = '﻿i'
# p['ඊ'] = '﻿ie'  
# p['උ'] = '﻿u'
# p['ඌ'] = '﻿uu'
# p['එ'] = '﻿e'
# p['ඒ'] = '﻿ea' 
# p['ඓ'] = '﻿I'
# p['ඔ'] = '﻿o'

# Vowel sounds - short (without ZWSP u'\u200B') 
p['අ'] = 'a'  
p['ආ'] = 'aa' 
p['ඇ'] = 'A'
p['ඈ'] = 'Aa'
p['ඉ'] = 'i'
p['ඊ'] = 'ie'  
p['උ'] = 'u'
p['ඌ'] = 'uu'
p['එ'] = 'e'
p['ඒ'] = 'ea' 
p['ඓ'] = 'I'
p['ඔ'] = 'o'

p['ැ'] = '-A'
p['ි'] = '-i'
p['ෙ'] = '-e'
p['ු'] = '-u'
p['ො'] = '-o'
p['ෛ'] = '-I'

# Vowel sounds - long
p['ා'] = '-aa'
p['ෑ'] = '-Aa'
p['ී'] = '-ie'
p['ේ'] = '-ei'
p['ෝ'] = '-oe'
p['ූ'] = '-uu'
p['ෞ'] = '-au'
p['ං'] = '\\n'
p['ඃ'] = '\h'
p['ඞ'] = '\\N'      #chenged \N to \\N


# special (* = \u200d) - if * -> check char after it. if it's ය -> Ya, if it's ර -> ra, else -> -R
p['ර ්‍'] = '-R' # repaya මර්‍ගය මර්*ගය 
p['්‍ ය'] = 'Ya'  # yansaya මධ්‍යම මධ්*යම   
p['්‍ ර'] = 'ra' # rakaranshaya ක්‍රමය ක්*රමය    රත‍්‍රන්  රත‍්*රන්

p['්'] = '-'
# p['‍'] = '‍'

p['ෘ'] = '-ru'
p['ඖ'] = 'au'

# Consonants - Nasal
p['ඬ'] = 'nnda'
p['ඳ'] = 'nndha'
p['ඟ'] = 'nnga'

# Consonants - Common
p['ක'] = 'ka'
p['බ'] = 'ba'
p['ග'] = 'ga'
p['ම'] = 'ma'
p['ච'] = 'ca'
p['ය'] = 'ya'
p['ජ'] = 'ja'
p['ර'] = 'ra'
p['ට'] = 'Ta' 
p['ල'] = 'la'
p['ඩ'] = 'Da'
p['ව'] = 'wa'
p['ත'] = 'ta'
p['ස'] = 'sa'
p['ද'] = 'da'
p['හ'] = 'ha'
p['න'] = 'na'
p['ණ'] = 'Na'
p['ප'] = 'pa'
p['ළ'] = 'La'

# Consonants - Aspirated
p['ඛ'] = 'Ka'
p['ඝ'] = 'Ga'
p['ඡ'] = 'cha'
p['ඨ'] = 'Tha'
p['ඪ'] = 'Da'
p['ථ'] = 'tha'
p['ධ'] = 'dha'
p['ඵ'] = 'Pa'
p['භ'] = 'bha'

# Consonants - Special
p['ඹ'] = 'Ba'
p['ශ'] = 'Sa'
p['ෂ'] = 'sha'
p['ෆ'] = 'fa'
p['ඥ'] = 'GNa'
p['ඤ'] = 'KNa'
p['ඣ'] = 'jha'
p['ළු'] = 'Lu'    # can't write 'luyanna'
p['ළූ'] = 'Luu'	  # can't write 'deerga luyanna'

def transliterate(word):
    #logFile.write(word+ '\t',)
    word = word.strip()   #1

    # Ignore non sinhala words
    isSinhala = False  #1
    for i in word.decode("utf-8"):  #1
        if(i <= 'ෳ' and i >= 'ං'):  #2
            isSinhala = True     #3
    if not(isSinhala):   #1
        #logFile.write('not sinhala: '+  word +'\n')
        return word	#2

    src = word.decode("utf-8") #1
    tgt = ''   #1
    #logFile.write(repr(src))
    i = 0  #1
    while i < len(src):  #1
        if(src[i]==u'\u200d' and i < len(src)-1):  # ZWJ  #2
            if(src[i+1]==u'\u0D9C'):  # ග  currently only set for මාර්‍ගය #3
                tgt = tgt[:-3]  # remove  'ra-'  #4
                tgt += 'R'  #4
                i +=1  #4
                continue  #4
            elif (src[i+1]==u'\u0DBA'): # ය    #3
                tgt += 'Ya'  #4
                i +=2 # jump over 'ය'  #4
                continue  #4
            elif (src[i+1]==u'\u0DBB'): # ර    #3
                tgt+='ra'	 #4
                i +=2	# jump over 'ර' #4
                continue #4
	
        t = src[i]  #2
        if(t in p): #2
            tgt += p[t] #3
        else:  #2
            tgt += t  # all non Sinhala unicode characters #3
        i+=1 #2

	#logFile.write(' '+ tgt +' ')
	# remove each char before '-'
    outw = ''  #1
    arr = tgt.split('-')  #1
    for i in range(0, len(arr)-1):  #1
        if len(arr[i]) == 0:  #2
            continue  #3
        if (arr[i][-1] != 'a'):   #2
            outw += arr[i][:-4] + arr[i][-3:]  #3
        else:      #2
            outw += arr[i][:-1]  #3

    outw += arr[-1]  #1
    #logFile.write(' '+ outw + '\n')
    return outw  #1

#Transliteration
def NER_and_Linking_with_transliteration_and_translation(example):
    input_language="si"    #1
    noise_sentences_with_trans=[] #1
    #noise_sentences_without_trans=[]
    for x in range(0,example.shape[0]): #1
        result=example.iloc[x]['sentences']   #2
        #result_without_tras=example.iloc[x]['sentences']
        splitting=example.iloc[x]['tokens'] #2

        tokenized_inputs = tokenizer(splitting, truncation=True, is_split_into_words=True,max_length=512) #2
        word_ids=tokenized_inputs.word_ids() #2
        prediction, label, _ = trainer.predict([tokenized_inputs]) #2
        prediction=np.argmax(prediction, axis=2) #2
        true_prediction_long = [label_list[p] for p in prediction[0]] #2
        true_prediction=[]#2
        try:  #2
            for y in range(0,len(splitting)): #3
                true_prediction.append(true_prediction_long[word_ids.index(y)])  #4
          #print(splitting)
            #print(true_prediction)  #3
            #print(example.iloc[x]['id'])
            #print(x)#3

            for word in splitting:  #3
                input_word = word  #4
                if true_prediction[splitting.index(word)][0]=="B":  #4
                    num = splitting.index(word)  #5
                    chunk_word = word  #5
                    while True:  #5
                        if num==len(splitting)-1:  #6
                            break  #7
                        if true_prediction[num+1][0]=="I":  #6
                            chunk_word+=" "+splitting[num+1]  #7
                            num+=1  #7
                        else:  #6
                            break  #7
                    try:   #5
                        site = pywikibot.Site(input_language, "wikipedia")  #6
                        page = pywikibot.Page(site, chunk_word) #6
                        item = pywikibot.ItemPage.fromPage(page) #6

                        item_dict = item.get() #6
                        result = result.replace(chunk_word, item_dict["labels"]['en']) #6
                        #print(chunk_word)
            #result_without_tras = result_without_tras.replace(chunk_word, item_dict["labels"]['en'])
                    except: #5

              
            #pass
                        if (true_prediction[splitting.index(word)]=="B-PER") or (true_prediction[splitting.index(word)]=="B-LOC") : #6
              #print(chunk_word)
                            #phrase = chunk_word  #7
                            #encode=phrase.encode("utf-8") #7
                            #my_transliteration=transliterate(encode) #7
                            #result = result.replace(chunk_word, my_transliteration) #7
                            #print(chunk_word)
                            phrase = chunk_word
                            translits=e.translit_word(phrase, lang_code="si", topk=5)
                            my_transliteration=translits[0]
                            result = result.replace(chunk_word, my_transliteration)
                        else: #6
                            #print(chunk_word)
                            phrase = chunk_word #7
                            my_translation=translator.translate(phrase, src='si', dest='en') #7
                            result = result.replace(chunk_word, my_translation.text) #7
        except: #2
            pass #3
        noise_sentences_with_trans.append(result) #2
    #example['noise_sentences_with_translit_and_translate']=noise_sentences_with_trans  #1
    return noise_sentences_with_trans
    

noise_list=NER_and_Linking_with_transliteration_and_translation(df)

data=pd.DataFrame({'tokens':tokens,'sentences':sentences,'noise_sentences_with_translit_and_translate':noise_list})

valid = data.sample(frac = 0.1)
train = data.drop(valid.index)

train_si=train['sentences']
train_en=train['noise_sentences_with_translit_and_translate']

train_si.to_csv('/userdirs/ram_coders/DEEP/preprocess_en_to_si/news_wiki_blog_data/input_data/train_si.csv', index=False)
train_en.to_csv('/userdirs/ram_coders/DEEP/preprocess_en_to_si/news_wiki_blog_data/input_data/train_en.csv', index=False)

valid_si=valid['sentences']
valid_en=valid['noise_sentences_with_translit_and_translate']

valid_si.to_csv('/userdirs/ram_coders/DEEP/preprocess_en_to_si/news_wiki_blog_data/input_data/valid_si.csv', index=False)
valid_en.to_csv('/userdirs/ram_coders/DEEP/preprocess_en_to_si/news_wiki_blog_data/input_data/valid_en.csv', index=False)





