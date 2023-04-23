Add username,passsword and host in translateService.js and nerService files.

Run `npm install` followed by `nodemon index.js` inside Backend directory.

you can access apis like this.

get translate from english to sinhala:
post method:

http://localhost:3001/translate/gettranslateentosi

{"input":"Bank of Ceylon is a major commercial bank in Sri Lanka."}

get ner for sinhala and english languages:
post method:

http://localhost:3001/ner/getner

{"input":"Bank of Ceylon is a major commercial bank in Sri Lanka."}