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

$check = "SELECT TablesMixte.* FROM BossInvader.U_Mixte, BossInvader.TablesMixte WHERE User_ID = '{$user_id}' AND TablesMixte.ID = U_Mixte.Mixte_ID;";
$res = $bdd->query($check);
$final = $res->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($final);

$bdd = null;