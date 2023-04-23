const express = require('express');
const router = express.Router();


router.use('/translate',require('./translate'));
router.use('/ner',require('./ner'));

module.exports = router;