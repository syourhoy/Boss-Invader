<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$email = $request->Email;
$participant = $request->Participants;
$theme = $request->Theme;
$adresse = $request->Adresse;
$date = $request->Date;

try {
    $bdd = new PDO('mysql:host=localhost;dbname=BossInvader', 'guimeus', '');
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}

$check = "SELECT ID,Telephone,Secteur FROM BossInvader.Users WHERE Email = '{$email}';";
$res = $bdd->query($check);
$final = $res->fetchAll(PDO::FETCH_ASSOC);

$telephone = $final[0]['Telephone'];
$user_id = $final[0]['ID'];
$secteur = $final[0]['Secteur'];

$check = "SELECT * FROM BossInvader.U_Sphere WHERE User_ID = '{$user_id}';";
$res = $bdd->query($check);
$final = $res->fetchAll(PDO::FETCH_ASSOC);



if (empty($final)) {
    $check = "INSERT INTO BossInvader.TablesSphere (Secteur, Participants, Theme, Adresse, RDV, Telephone, Email, Inscrits) VALUES ('{$secteur}', '{$participant}', '{$theme}', '{$adresse}', '{$date}', '{$telephone}', '{$email}', 1);";
    $res = $bdd->query($check);
    
    $check = "SELECT ID FROM BossInvader.TablesSphere WHERE Email = '{$email}';";
    $res = $bdd->query($check);
    $final = $res->fetchAll(PDO::FETCH_ASSOC);
    
    $table_id = $final[0]['ID'];
    
    $check = "INSERT INTO BossInvader.U_Sphere (User_ID, Sphere_ID) VALUES ('{$user_id}', '{$table_id}');";
    $res = $bdd->query($check);
    
    echo json_encode(array('Etat' => true));
} else {
    echo json_encode(array('Etat' => false));
}

$bdd = null;