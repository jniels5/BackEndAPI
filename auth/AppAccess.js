var connection = require("../auth/Connect");

class AppAccess{
    constructor()
    {

    }

    /**
     * @author Jacob Drzewiecki
     * @param {string} key      The AppID of the application trying to access the call
     * @param {number} access   The minimum access level the application must have to access the call
     * @return {boolean}        true if allowed to access call
     */
    check(key, access)
    {
        var result;
        let query = "SELECT AccessLevel FROM Applications WHERE AppID='" + access + "';";
        await connection.query(query, function(err, results)
        {
            console.log(results);
        });
    }
}