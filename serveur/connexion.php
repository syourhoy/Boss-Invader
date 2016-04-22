<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$email = $request->Email;
$password = $request->Password;

try {
    $bdd = new PDO('mysql:host=localhost;dbname=BossInvader', 'guimeus', '');
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}

$check = "SELECT * FROM BossInvader.Users WHERE Email = '{$email}'";
$res = $bdd->query($check);
$final = $res->fetchAll(PDO::FETCH_ASSOC);

if (empty($final) || $final[0]['Password'] != $password) {
    echo json_encode(array('Etat' => false, 'Erreur' => $email));
} else {
    echo json_encode(array('Etat' => true, 'Data' => $final[0]));
}

$bdd = null;