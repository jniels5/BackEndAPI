var connection = require("../auth/Connect");

class AppAccess{
    constructor()
    {
        console.log("constructed");
    }

    /**
     * @author Jacob Drzewiecki
     * @param {string} key      The AppID of the application trying to access the call
     * @param {number} access   The minimum access level the application must have to access the call
     * @return {boolean}        true if allowed to access call
     */
    async check(key, access)
    {
        var result;
        let query = "SELECT AccessLevel FROM Applications WHERE AppID='" + key + "';";
        await connection.query(query, function(err, results){
            result = 5;
        });
        console.log(result);
    }
}

module.exports = {AppAccess};