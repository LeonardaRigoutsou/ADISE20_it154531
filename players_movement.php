<?php
    $input = json_decode(file_get_contents('php://input'),true);
    if(isset($_SERVER['HTTP_X_TOKEN'])) {
        $input['token']=$_SERVER['HTTP_X_TOKEN'];
    }
    include_once dirname(__FILE__) . '/dbconnect.php';

    $token = $input['token'];
    $column = $input['column'];

    $sql1 = 'SELECT status FROM game_status';
    $stmt1 = $mysqli->prepare($sql1);
    $stmt1->execute();
    $res = $stmt1->get_result();
    $data = $res->fetch_assoc();
    if ($data['status'] != 'started'){
        http_response_code(400);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Wrong status! Only in started mode you can play a game !"]);
        exit;
    }

    $sql = 'SELECT id FROM players WHERE token = ?';
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        http_response_code(500);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Movement failed1"]);
        exit;
    }
    $stmt->bind_param('s',$token);
    $stmt->execute();
    $res = $stmt->get_result();
    if (!$res){
        http_response_code(500);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Movement failed2"]);
        exit;
    }
    
    $data = $res->fetch_assoc();
    if(!$data){
        http_response_code(400);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Bad token"]);
        exit;
    }

    $sql = 'CALL players_movement(?,?)';
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        http_response_code(500);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Movement failed3"]);
        exit;
    }
    $stmt->bind_param('ii',$column,$data['id']);

    if (!$stmt->execute()) {
        http_response_code(500);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Movement failed4",'er'=>$stmt->error]);
        exit;
    }

    $res1 = $stmt->get_result();
    $data1 = $res1->fetch_assoc();
    if ($data1['success'] === 0) {
        http_response_code(400);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Not your turn"]);
        exit;
    }else if ($data1['success'] === 2) {
        http_response_code(400);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Dose sostes diastaseis"]);
        exit;
    }else if ($data1['success'] === 3) {
        http_response_code(400);
        header('Content-type: application/json');
        print json_encode(['errormesg'=>"Gemise i stili me 6 markes, parakalo dialexe mia alli stili"]);
        exit;
    }else{
        header('Content-type: application/json');
        print json_encode(['msg'=>"Success"]);
        exit;
    }

    header('Content-type: application/json');
    print json_encode(['mesg'=>"Success!"]);



?>