app.get('/stats/lab/projects', function(request,response) {
    if (request.query.Semester == "unassigned")
    {
      // Fetching all project names in database
      connection.query('SELECT p.Name, p.ProjectID FROM Projects AS p, TeamProjects as tp WHERE ' +
                       'p.ProjectID NOT IN (SELECT ProjectID FROM TeamProjects) ' +
                       'GROUP BY `Name` ORDER BY `Name`', function (error, results, fields) {
            if(error) {
                response.json({Unassigned_select: "failed"});
            }
            else {
                response.json(results);
            }
      });
    }
    else
    {
      // Fetching project names according to semester
      connection.query('SELECT p.Name, p.ProjectID FROM Projects AS p, Teams, TeamProjects as tp WHERE Teams.Semester = "'+ request.query.Semester +
                       '" AND p.ProjectID = tp.ProjectID AND tp.TeamID = Teams.TeamID ' +
                       'ORDER BY `Name`', function (error, results, fields) {
            if(error) {
                response.json({Project_select: "failed"});
            }
            else {
                response.json(results);
            }
      });
    }
  });