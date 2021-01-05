<?php
    $input = json_decode(file_get_contents('php://input'),true);

    include_once dirname(__FILE__) . '/dbconnect.php';

    $sql = 'SELECT * FROM board;';
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        http_response_code(400);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>" The table is empty !"]);
        exit;
    }
    $stmt->execute();
    $res = $stmt->get_result();
    $data = $res->fetch_all(MYSQLI_ASSOC);
        header('Content-type: application/json');
        print json_encode($data);
        exit;
?>