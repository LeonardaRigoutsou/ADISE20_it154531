<?php
    $input = json_decode(file_get_contents('php://input'),true);

    include_once dirname(__FILE__) . '/dbconnect.php';

    $sql = "UPDATE game_status SET status='aborded';";
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        http_response_code(500);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>" Something went wrong !"]);
        exit;
    }
    $stmt->execute();

?>