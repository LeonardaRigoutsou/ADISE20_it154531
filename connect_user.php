<?php
    $username = $_POST['username'];
    $color = $_POST['color'];

    include_once dirname(__FILE__) . '/dbconnect.php';


    $sql = 'INSERT INTO players (username,color,token) VALUES (?,?,md5(CONCAT( ?, NOW())))';
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        die('Insertion failed: ' . $mysqli->error);
    }


    $stmt->bind_param('sss', $username,$color,$username);
    if (!$stmt->execute()) {
        die('Insertion failed: ' . $stmt->error);
    }

    $player_id = $stmt->insert_id;
    $stmt->close();

    $sql = 'select * from players where id=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('i',$player_id);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
    

?>