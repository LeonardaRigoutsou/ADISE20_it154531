<?php

include_once dirname(__FILE__) . '/dbconnect.php';

    $sql = 'CALL clean_board()';
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        http_response_code(500);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Reset failed"]);
        exit;
    }

    if (!$stmt->execute()) {
        http_response_code(500);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Reset failed"]);
        exit;
    }

    header('Content-type: application/json');
    print json_encode(['mesg'=>"Success!"]);




    ?>