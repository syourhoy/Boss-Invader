<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$nom = $request->Nom;
$prenom = $request->Prenom;
$email = $request->Email;
$password = $request->Password;

try {
    $bdd = new PDO('mysql:host=localhost;dbname=BossInvader', 'guimeus', '');
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}

$check = "SELECT Email FROM BossInvader.Users WHERE Email = '{$email}';";
$res = $bdd->query($check);
$final = $res->fetchAll(PDO::FETCH_ASSOC);

if (empty($final)) {
    $stmt = $bdd->prepare("INSERT INTO BossInvader.Users (Nom, Prenom, Email, Password) VALUES ('{$nom}', '{$prenom}', '{$email}', '{$password}')");
    $test = $stmt->execute();
	echo json_encode(array('Etat'=> true));
} else {
    echo json_encode(array('Etat'=> false, 'Erreur' => $email));
}

$bdd = null;