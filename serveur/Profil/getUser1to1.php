<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$email = $request->Email;

try {
    $bdd = new PDO('mysql:host=localhost;dbname=BossInvader', 'guimeus', '');
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}

$check = "SELECT ID FROM BossInvader.Users WHERE Email = '{$email}';";
$res = $bdd->query($check);
$final = $res->fetch(PDO::FETCH_ASSOC);

$user_id = $final['ID'];

$check = "SELECT Tables1to1.* FROM BossInvader.U_1to1, BossInvader.Tables1to1 WHERE User_ID = '{$user_id}' AND Tables1to1.ID = U_1to1.1to1_ID;";
$res = $bdd->query($check);
$final = $res->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($final);

$bdd = null;