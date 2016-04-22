<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$email = $request->Email;
$createur = $request->Createur;

try {
    $bdd = new PDO('mysql:host=localhost;dbname=BossInvader', 'guimeus', '');
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}

$check = "SELECT ID FROM BossInvader.Users WHERE Email = '{$createur}';";
$check2 = "SELECT ID FROM BossInvader.Users WHERE Email = '{$email}';";
$res = $bdd->query($check);
$res2 = $bdd->query($check2);
$final = $res->fetch(PDO::FETCH_ASSOC);
$final2 = $res2->fetch(PDO::FETCH_ASSOC);

$createur_ID = $final['ID'];
$user_ID = $final2['ID'];

$check = "SELECT Sphere_ID FROM BossInvader.U_Sphere WHERE User_ID = '{$createur_ID}';";
$res = $bdd->query($check);
$final = $res->fetch(PDO::FETCH_ASSOC);

$table_ID = $final['Sphere_ID'];

$check = "SELECT Participants,Inscrits FROM BossInvader.TablesSphere WHERE ID = '{$table_ID}';";
$res = $bdd->query($check);
$final = $res->fetch(PDO::FETCH_ASSOC);

$inscrits = $final['Inscrits'];
$particpants = $final['Participants'];

if ($inscrits != $particpants) {
    $inscrits += 1;
    $query = "UPDATE BossInvader.TablesSphere SET Inscrits = '{$inscrits}' WHERE Email = '{$email}';";
    $prep = $bdd->prepare($query);
    $exe = $prep->execute();
    
    $stmt = $bdd->prepare("INSERT INTO BossInvader.U_Sphere (User_ID, Sphere_ID) VALUES ('{$user_ID}', '{$table_ID}');");
    $test = $stmt->execute();
    
    echo json_encode(array('Etat' => true));
} else {
    echo json_encode(array('Etat' => false));
}

$bdd = null;