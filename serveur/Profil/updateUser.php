<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$email = $request->Email;
$nom = $request->Nom;
$prenom = $request->Prenom;
$password = $request->Password;
$secteur = $request->Secteur;
$metier = $request->Metier;
$telephone = $request->Telephone;

try {
    $bdd = new PDO('mysql:host=localhost;dbname=BossInvader', 'guimeus', '');
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}

$query = "UPDATE BossInvader.Users SET Password = '{$password}', Secteur = '{$secteur}', Metier = '{$metier}', Telephone = '{$telephone}' WHERE Email = '{$email}'";
$prep = $bdd->prepare($query);
$exe = $prep->execute();

echo json_encode(array('Etat' => true));

$bdd = null;