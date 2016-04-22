<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$secteur = $request->Secteur;
$metier = $request->Metier;
$telephone = $request->Telephone;
$email = $request->Email;

try {
    $bdd = new PDO('mysql:host=localhost;dbname=BossInvader', 'guimeus', '');
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}

$stmt = $bdd->prepare("UPDATE BossInvader.Users SET Secteur = '{$secteur}', Metier = '{$metier}', Telephone = '{$telephone}' WHERE Email = '{$email}';");
$test = $stmt->execute();

echo json_encode(array('Etat'=> true));

$bdd = null;