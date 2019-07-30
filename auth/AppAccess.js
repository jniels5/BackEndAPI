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
    check(access, req, resp) {
        var key = req.query.AppID;
        var connection = require("../auth/Connect");
        var retVal;
        //console.log("creating promise");
        var p = new Promise(function (resolve, reject) {
            //console.log("starting promise");
            let query = "SELECT AccessLevel FROM Applications WHERE AppID=" + mysql.escape(key) + ";";
            connection.query(query, function (err, results) {
                //console.log("executing query");
                if (err) {
                    //console.log("rejecting promise");
                    reject(err);
                }
                else {
                    //console.log("resolving promise");
                    resolve(results[0]);
                }
            });
        });
        return p.then(function (result) {
            //console.log("p.then success");
            //return AccessLevel >= access;
            console.log(key + ": " + result.AccessLevel + " >= " + access);
            retVal = result.AccessLevel >= access;
            
        }, function (error) {
            retVal = false;
        });
        console.log("retVal", retVal);
        return retVal;
    }
}

module.exports = {AppAccess};