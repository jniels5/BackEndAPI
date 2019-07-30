var mysql = require('mysql');
var connection = require("../auth/Connect");

class AppAccess{
    constructor()
    {
        console.log("constructed");
    }

    /**
     * @author Jacob Drzewiecki
     * @param {number} access   The minimum access level the application must have to access the call
     * @param {request} req     TThe request to parse AppID
     * @param {response} resp   The response to allow immediate 403/500
     * @return {boolean}        true if allowed to access call
     * 
     */
    async check(access, req, resp) {
        var key = req.query.AppID;
        var connection = require("../auth/Connect");
        var retVal;
        var p = new Promise(function (resolve, reject) {
            let query = "SELECT AccessLevel FROM Applications WHERE AppID=" + mysql.escape(key) + ";";
            connection.query(query, function (err, results) {
                if (err) {
                    //resp.sendStatus(500);
                    reject(err);
                }
                else if (results.length == 0)
                {
                    //resp.sendStatus(500);
                    resolve(0);
                }
                else {
                    resolve(results[0].AccessLevel);
                }
            });
        });
        await p.then(function (result) {
            console.log(key + ": " + result + " >= " + access);
            retVal = result >= access;
            if(retVal == false)
                resp.sendStatus(403);
        }, function (error) {
            retVal = false;
            resp.sendStatus(500);
        });
        return retVal;
    }
}

module.exports = {AppAccess};