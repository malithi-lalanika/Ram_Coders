const router = require('express').Router();
const { getTranslateEnToSinhala} = require("../controller/translatecontroller");

router.post('/gettranslateentosi',getTranslateEnToSinhala);

module.exports=router;