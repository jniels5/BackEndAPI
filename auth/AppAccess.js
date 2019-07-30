var mysql = require('mysql');
var connection = require("../auth/Connect");

class AppAccess{
    constructor()
    {
        console.log("constructed");
    }

    /**
     * @author Jacob Drzewiecki
     * @param {string} key      The AppID of the application trying to access the call. Key will be mysql.escaped in function.
     * @param {number} access   The minimum access level the application must have to access the call
     * @return {boolean}        true if allowed to access call
     */
    async check(key, access)
    {
        let query = "SELECT AccessLevel FROM Applications WHERE AppID=" + mysql.escape(key) + ";";
        console.log(query);
        console.log(await connection.query(query).RowDataPacket);
        //return key + ": " + results.AccessLevel + " > " + access + " = " + results.Access > access;
        //console.log(result);
    }
}

module.exports = {AppAccess};