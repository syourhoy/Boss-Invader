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

$check = "SELECT * FROM BossInvader.TablesMixte WHERE Email = '{$email}'";
$res = $bdd->query($check);
$final = $res->fetch(PDO::FETCH_ASSOC);

echo json_encode($final);

$bdd = null;