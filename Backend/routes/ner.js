const router = require('express').Router();
const { getnerfromSinhalaEnglish} = require("../controller/nercontroller");

router.post('/getner',getnerfromSinhalaEnglish);

module.exports=router;