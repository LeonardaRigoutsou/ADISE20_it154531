<?php
    $host='users.iee.ihu.gr';
    $db='CONNECT_FOUR_DB';

    //gia na min exw to pass sto git tha to balw xwrista
    require_once "config_local.php";

    $user=$DB_USER;
    $pass=$DB_PASS;

    if(gethostname()=='users.iee.ihu.gr'){
        $mysqli=new mysqli(null, $user, $pass, $db, null,'/home/student/it/2015/it154531/mysql/run/mysql.sock');
    } else{
        $mysqli=new mysqli($host, $user, $pass, $db);
    }

    if($mysqli->connect_errno){
        echo "Failed to connect: (" .
        $mysqli->connect_errno . ") " . $mysqli->connect_error;
    }
?>