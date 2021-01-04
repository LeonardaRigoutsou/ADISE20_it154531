<?php
    $input = json_decode(file_get_contents('php://input'),true);
    
    $username = $input['username'];
    $color = $input['color'];

    include_once dirname(__FILE__) . '/dbconnect.php';

    if ($color != 'B' && $color != 'R'){
        http_response_code(400);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Wrong color."]);
        exit;
    }

    $sql = 'INSERT INTO players (username,color,token) VALUES (?,?,md5(CONCAT( ?, NOW())))';
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        http_response_code(400);
        header('Content-type: application/json');
        print json_encode(['Insertion failed: ' . $mysqli->error]);
        exit;
    }


    $stmt->bind_param('sss', $username,$color,$username);
    if (!$stmt->execute()) {
        http_response_code(400);
        header('Content-type: application/json');
        print json_encode(['Insertion failed: ' . $mysqli->error]);
        exit;
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