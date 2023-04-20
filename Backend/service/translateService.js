'use strict';
var SSH = require('simple-ssh');
var rexec = require('remote-exec');

module.exports = {
    getTranslateServiceEnToSinhala(input, callback) {
          var ssh = new SSH({
            host: 'enter_host',
            user: 'enter_user_name',
            pass: 'enter_password'
        });
        
        //translate
          var connection_options = {
            port: 22,
            username: 'enter_user_name',
            password: 'enter_password'
            };
        
            var hosts = [
                'enter_host'
            ];
        
            var cmds = [
                'echo '+input+' > /userdirs/ram_coders/DEEP/get_translate/translate_input.txt',
                'bash /userdirs/ram_coders/DEEP/get_translate/get-translate.sh'
            ];

            
        
            rexec(hosts, cmds, connection_options, function(err){
                if(err){
                    console.log(err);
                }else{
                    console.log("Success");
                    function execShellCommand() {
                        return new Promise((resolve, reject) => {
                          ssh.exec('tail -f /userdirs/ram_coders/DEEP/get_translate/translation_output.txt', {
                            out: function(stdout) {
                              //out=stdout
                              resolve(stdout);
                              //console.log(out);
                              
                            }
                        }).start();
                        });
                       }
                      
                    const output = execShellCommand();
                      
                    output.then((value) => {
                        console.log(value);
                        return callback(null, value);
                        // Expected output: 123
                    });
                    //return callback(null, "Success");
                }
            });

            

      },
      
    };