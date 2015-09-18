<?php
require '../libs/vendor/slim/slim/Slim/Slim.php';

\Slim\Slim::registerAutoloader();

$app = new \Slim\Slim();

$app->contentType('application/json');

$db = new PDO('mysql:host=localhost;dbname=jrnlbeta;charset=utf8', 'root', 'iZ97Tu3639W48mmX46VM');

/*
		49: USER
			 1. register(email, pass, avatar, fname, lname, secret, answer)
			 2. userExists(email)
			 3. login(email, pass)
			 4. userIsLoggedIn(userID)
			 5. resetPassword(email, answer)
			 6. logout(userID)
	
		69: ENTRY
			 7. createEntry(userID, date, privacy, link, tags[], photos[], location, content)
			 8. deleteEntry(entryID)
			 9. updateEntry(entryID, date, privacy, link, tags[], photos[], location, content)
			10. getEntriesForMonth(userID, month)
			11. getEntriesForTag(userID, tagID)
			12. getEntriesForLocation(userID, locationID)
			13. star(entryID)
			14. report(entryID)
			
		106: COMMENTS
			15. getComments(entryID)
			16. createComment(userID, entryID, date, content)
			17. deleteComment(commentID)
			18. updateComment(commentID)
			 
		FRIEND
			19. friendsList(userID)
			20. addFriend(email)
			21. removeFriend(userID, relationshipID)
		
		SEARCH
			22. search(query)	
			
		MAPS & WEATHER
			23. getMap(long, lat)
			24. getWeather(long, lat)
*/

// USER

$app->post('/authenticate/',
	function () use ($db, $app) {
		$requestBody = $app->request->getBody();
		$requestUser = json_decode($requestBody);
		$username = $requestUser->username;
		$password = $requestUser->password;

		if (!($username === 'john.doe' && $password === 'foobar')) {
    	$app->response->status(401);
  	}

  	// $json=json_encode($requestBody);
  	echo json_encode($requestUser);
	}
);

$app->get('/users/',
	function () use ($db, $app) {
		$statement=$db->prepare("SELECT * FROM user;");
		$statement->execute();
		$results=$statement->fetchAll(PDO::FETCH_ASSOC);
		$json=json_encode($results);
		echo $json;
	}
);

$app->get('/user/:id',
	function ($id) use ($db, $app) {
		$sth=$db->prepare("SELECT * FROM user WHERE userID = ? LIMIT 1;");
		$sth->execute([intval($id)]);
		echo json_encode($sth->fetchAll(PDO::FETCH_CLASS)[0]);
	}
);

// ENTRY

$app->get('/entries/',
	function () use ($db, $app) {
		$sth=$db->query("SELECT entryID, content, DATE_FORMAT(date, '%b %D, %l:%i %p') as formatted_date,(SELECT count(commentID) FROM comment WHERE entry.entryID = comment.entryID) as commentCount, EXISTS(SELECT * FROM starred WHERE userID = 1 AND starred.entryID = entry.entryID) AS starred FROM entry ORDER BY date DESC;");
		echo(json_encode($sth->fetchAll(PDO::FETCH_CLASS)));
	}
);

$app->get('/entry/:id',
	function ($id) use ($db, $app) {
		$sth=$db->prepare("SELECT DATE_FORMAT(date, '%b %D, %l:%i %p') as formatted_date, content FROM entry WHERE entryID = ? LIMIT 1;");
		$sth->execute([intval($id)]);
		echo json_encode($sth->fetchAll(PDO::FETCH_CLASS)[0]);
	}
);

$app->post('/star/',
	function () use ($db, $app) {
		$requestBody = $app->request->getBody();
		$request = json_decode($requestBody);
		$userID = $request->userID;
		$entryID = $request->entryID;

		$sql = "INSERT INTO starred (starredID, userID, entryID) VALUES (NULL, :userID, :entryID);";

		try {
			$stmt = $db->prepare($sql);  
			$stmt->bindParam("userID", $userID);
			$stmt->bindParam("entryID", $entryID);
			$rowBool = $stmt->execute();
		} catch(PDOException $e) {
      echo '{"error":{"text":'. $e->getMessage() .'}}';
    }

    if (!$rowBool) {
    	$sql = "DELETE FROM starred WHERE userID = :userID AND entryID = :entryID;";

    	try {
				$stmt = $db->prepare($sql);  
				$stmt->bindParam("userID", $userID);
				$stmt->bindParam("entryID", $entryID);
				$stmt->execute();
				// $rowBool = 0;
			} catch(PDOException $e) {
      	echo '{"error":{"text":'. $e->getMessage() .'}}';
    	}
    }

    $response = Array("starred"=>$rowBool);
    echo json_encode($response);
	}
);

// COMMENTS

$app->get('/entry/:id/comments',
	function ($id) use ($db, $app) {
		$sth=$db->prepare("SELECT * FROM comment WHERE entryID = ?;");
		$sth->execute([intval($id)]);
		echo(json_encode($sth->fetchAll(PDO::FETCH_CLASS)));
	}
);

// OTHER

$app->get('/date/',
	function () use ($db, $app) {
		$years = array();
		$lastyear = 0;
		
		$sth=$db->query("SELECT MONTHNAME(date) as month, YEAR(date) as year FROM entry GROUP BY MONTH(date) DESC, YEAR(date);");
		
		while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
			if ($lastyear != $row['year']) {
				$lastyear = $row['year'];
				
				$years[$row['year']] = $row['month'];
			}
			else {
				$years[$row['year']] = array($years[$row['year']], $row['month']);
			}
		}
		echo (json_encode($years));
	}
);

$app->run();