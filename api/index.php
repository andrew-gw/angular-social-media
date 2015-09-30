<?php
require '../libs/vendor/slim/slim/Slim/Slim.php';
require 'db.php';
\Slim\Slim::registerAutoloader();
$app = new \Slim\Slim();
$app->contentType('application/json');

/*
		47: USER
			 1. POST->register(fname, lname, email, pass, passConfirm, avatar, secret, answer)
			 2. GET->userExists(email)
			 3. POST->login(email, pass)
			 4. GET->userIsLoggedIn(userID)
			 5. POST->resetPassword(email, answer)
			 6. GET->logout(userID)
	
		138: ENTRY
			 7. POST->createEntry(userID, date, privacy, link, tags[], photos[], location, content)
			 8. DELETE->deleteEntry(entryID)
			 9. PUT->updateEntry(entryID, date, privacy, link, tags[], photos[], location, content)
			10. GET->getUserEntriesByMonth(userID, month)
			11. GET->getUserEntriesByTag(userID, tagID)
			12. GET->getUserEntriesByLocation(userID, locationID)
			13. GET->star(entryID)
			14. GET->report(entryID)
			
		186: COMMENTS
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

$app->post('/login/', function () use ($db, $app) {
	$requestBody = $app->request->getBody();
	$requestUser = json_decode($requestBody);
	$username = $requestUser->username;
	$password = $requestUser->password;

	if (!($username === 'john.doe' && $password === 'foobar')) {
		$app->response->status(401);
	}

	echo json_encode($requestUser);
});

$app->post('/user/', function () use ($db, $app) {
	$requestUser = $_POST['user'];
	$password = password_hash($requestUser['password'], PASSWORD_DEFAULT);
	$answer = password_hash($requestUser['securityAnswer'], PASSWORD_DEFAULT);
	$response = Array('success'=>false);
	$file = "Error uploading avatar";

	if(file_exists($_FILES['file']['tmp_name']) && is_uploaded_file($_FILES['file']['tmp_name'])) {
		$file = md5(uniqid(rand(), true)) . '.' . substr(strrchr(($_FILES['file']['name']), '.'), 1);
		$target_dir = "../users/";
		$target_file = $target_dir . $file;

		if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {
			$response['avatar'] = $file;
		} 
	}

	$sql = "INSERT INTO user (userID, firstName, lastName, avatar, email, password, securityQuestion, securityAnswer) 
		VALUES (NULL, :fname, :lname, :file, :email, :password, :question, :answer);";

	try {
		$stmt = $db->prepare($sql);  
		$stmt->bindParam("fname", $requestUser['firstName']);
		$stmt->bindParam("lname", $requestUser['lastName']);
		$stmt->bindParam("file", $file);
		$stmt->bindParam("email", $requestUser['email']);
		$stmt->bindParam("password", $password);
		$stmt->bindParam("question", $requestUser['securityQuestion']);
		$stmt->bindParam("answer", $answer);

		$response['success'] = $stmt->execute();
		$response['userID'] = $db->lastInsertId();
		$response['email'] = $requestUser['email'];
	} catch(PDOException $e) {
		$response['message'] = $e->getMessage();
		$response['email'] = $requestUser['email'];
	}

	echo json_encode($response);
});

$app->get('/users/', function () use ($db, $app) {
	$statement=$db->prepare("SELECT * FROM user;");
	$statement->execute();
	$results=$statement->fetchAll(PDO::FETCH_ASSOC);
	$json=json_encode($results);
	echo $json;
});

$app->get('/user/:id', function ($id) use ($db, $app) {
	$sth=$db->prepare("SELECT * FROM user WHERE userID = ? LIMIT 1;");
	$sth->execute([intval($id)]);
	echo json_encode($sth->fetchAll(PDO::FETCH_CLASS)[0]);
});

$app->delete('/user/:id', function ($id) use ($db, $app) {
	$sql = "SELECT avatar FROM user WHERE userID = ?";
	$sth = $db->prepare($sql);
	$sth->execute([intval($id)]);
	$filename = $sth->fetchColumn();
	unlink("../users/" . $filename);

	$sql = "DELETE FROM user WHERE userID = ?";
	$response = Array('userID'=>$id, 'success'=>false);

	try {
		$stmt = $db->prepare($sql);
		$stmt->execute([intval($id)]);
		$response['success'] = true;
		echo json_encode($response);
	} catch(PDOException $e) {
		$response['message'] = $e->getMessage();
		echo json_encode($response);
	}
});

// ENTRY

$app->get('/entries/', function () use ($db, $app) {
	$sth=$db->query("SELECT entryID, content, DATE_FORMAT(date, '%b %D, %l:%i %p') as formatted_date,(SELECT count(commentID) FROM comment WHERE entry.entryID = comment.entryID) as commentCount, EXISTS(SELECT * FROM starred WHERE userID = 1 AND starred.entryID = entry.entryID) AS starred FROM entry ORDER BY date DESC;");
	echo(json_encode($sth->fetchAll(PDO::FETCH_CLASS)));
});

$app->get('/entry/:id', function ($id) use ($db, $app) {
	$sth=$db->prepare("SELECT DATE_FORMAT(date, '%b %D, %l:%i %p') as formatted_date, content FROM entry WHERE entryID = ? LIMIT 1;");
	$sth->execute([intval($id)]);
	echo json_encode($sth->fetchAll(PDO::FETCH_CLASS)[0]);
});

$app->post('/star/', function () use ($db, $app) {
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
});

// COMMENTS

$app->get('/entry/:id/comments', function ($id) use ($db, $app) {
	$sth=$db->prepare("SELECT * FROM comment WHERE entryID = ?;");
	$sth->execute([intval($id)]);
	echo(json_encode($sth->fetchAll(PDO::FETCH_CLASS)));
});

// OTHER

$app->get('/date/', function () use ($db, $app) {
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
});

$app->run();