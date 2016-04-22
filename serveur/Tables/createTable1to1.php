<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$email = $request->Email;
$participant = 2;
$secteur = $request->Secteur;
$adresse = $request->Adresse;
$titre = $request->Titre;
$date = $request->Date;
$budget = $request->Budget;
$distance = $request->Distance;
$public = $request->Public;

try {
    $bdd = new PDO('mysql:host=localhost;dbname=BossInvader', 'guimeus', '');
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}

$check = "SELECT ID,Telephone FROM BossInvader.Users WHERE Email = '{$email}'";
$res = $bdd->query($check);
$final = $res->fetchAll(PDO::FETCH_ASSOC);

$telephone = $final[0]['Telephone'];
$user_id = $final[0]['ID'];

$check = "SELECT * FROM BossInvader.U_1to1 WHERE User_ID = '{$user_id}'";
$res = $bdd->query($check);
$final = $res->fetchAll(PDO::FETCH_ASSOC);

if (empty($final)) {
    $check = "INSERT INTO BossInvader.Tables1to1 (Participants, Secteur, Titre, Adresse,RDV, Budget, Distance, Public, Email, Inscrits) VALUES ('{$participant}', '{$secteur}', '{$titre}', '{$adresse}','{$date}', '{$budget}', '{$distance}', '{$public}', '{$email}', 1);";
    $res = $bdd->query($check);
    
    $check = "SELECT ID FROM BossInvader.Tables1to1 WHERE Email = '{$email}'";
    $res = $bdd->query($check);
    $final = $res->fetchAll(PDO::FETCH_ASSOC);
    
    $table_id = $final[0]['ID'];
    
    $check = "INSERT INTO BossInvader.U_1to1 (User_ID, 1to1_ID) VALUES ('{$user_id}', '{$table_id}');";
    $res = $bdd->query($check);
    
    echo json_encode(array('Etat' => true));
} else {
    echo json_encode(array('Etat' => false));
}

$bdd = null;