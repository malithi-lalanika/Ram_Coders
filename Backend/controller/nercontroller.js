const {
    getnerServiceSinhalaEngish,
} = require("../service/nerService");

module.exports = {
    getnerfromSinhalaEnglish: (req, res) => {
        const body = req.body;
        getnerServiceSinhalaEngish(
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