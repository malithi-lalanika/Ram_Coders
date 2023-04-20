const {
    getTranslateServiceEnToSinhala,
} = require("../service/translateService");

module.exports = {
    getTranslateEnToSinhala: (req, res) => {
        const body = req.body;
        getTranslateServiceEnToSinhala(
          body.input,
          (err, result) => {
            if (err) {
              console.log(err);
              res.json({
                sucess: 0,
                message: "Invalid Input",
              });
            } else {
              res.json({
                sucess: 1,
                data: result,
              });
            }
          }
        );
      },

    };